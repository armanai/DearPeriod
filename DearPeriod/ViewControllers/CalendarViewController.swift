//
//  ViewController.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 14/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var periodControlButton: UIButton!
    @IBOutlet weak var nextFertileDaysLabel: UILabel!
    @IBOutlet weak var nextPeriodLabel: UILabel!
    
    let endPeriodText: String = "End period"
    let startPeriodText: String = "Start period"
    
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.gray
    let selectedMonthColor = UIColor.black
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if person == nil{
            person = DataManager.shared.data
        }

        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        
        setDataToView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         self.calendarView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let startDate = person?.firstPeriodRecord
        calendarView.viewWillTransition(to: size, with: coordinator, anchorDate: startDate)
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState, cellData: CellData?){
        guard let validCell = view as? CustomCell else{ return }
        
        if cellState.isSelected{
            validCell.selectedView.isHidden = false
        }else{
            validCell.selectedView.isHidden = true
        }
        
        if let cellData = person?.getCellDataByDate(date: cellState.date){
            if cellData.isPeriodDay{
                periodControlButton.setTitle(endPeriodText, for: .normal)
            }else{
                periodControlButton.setTitle(startPeriodText, for: .normal)
            }
        }
        
        handleCellSelectedTextColor(validCell: validCell , cellState: cellState, cellData: cellData)
    }
    
    func handleCellSelectedTextColor(validCell: CustomCell, cellState: CellState, cellData: CellData?){
        if cellState.isSelected{
            validCell.dateLabel.textColor = selectedMonthColor
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                if let cellData = cellData, cellData.isPeriodDay {
                    validCell.dateLabel.textColor = .white
                }else{
                    validCell.dateLabel.textColor = monthColor
                }
            }else{
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellDisplayData(view: JTAppleCell?, cellState: CellState, cellData: CellData?){
        guard let validCell = view as? CustomCell else{ return }
        
        if let cellData = cellData{
            if let dayOfCycle = cellData.dayOfCycle{
                validCell.cycleDay.text = "\(dayOfCycle)"
            }
            
            validCell.setFertileDaysImage(isFertileDay: cellData.isFertileDay, isFertileDayFuture: cellData.isFertileDayFuture, isPregnancyPossibilityHigh: cellData.isPregnancyPossibilityHigh)
            
            validCell.setPeriod(isPeriodDay: cellData.isPeriodDay, possiblePeriodDay: cellData.isPeriodDayFuture)
            
            validCell.setPillImage(shouldTakeThePill: cellData.shouldTakeThePill, didTookThePill: cellData.didTookThePill, shouldTakeThePillInFuture: cellData.shouldTakeThePillInFuture)
        }else{
            validCell.cycleDay.text = ""
        }
    }
    
    func handleDoubleTapOnCell(cell: JTAppleCell?, cellState: CellState, cellData: CellData?){
        guard let validCell = cell as? CustomCell else{ return }
        if validCell.selectedView.isHidden == false {
            self.presentAlertOnCellDoubleTap(cell: validCell, cellState: cellState)
        }
    }
    
    func presentAlertOnCellDoubleTap(cell: CustomCell, cellState: CellState){
        let cellData = person?.getCellDataByDate(date: cellState.date)
       
        if let cellData = cellData{
            let alert = UIAlertController(title: Utils.formatDate(date: cellState.date, format: "dd.MM.yyyy"), message: "What change do you want to make for this date?", preferredStyle: .alert)
            
            if !cellData.isPeriodDay{
                if cellData.isDateToProlongPeriod{
                    alert.addAction(UIAlertAction(title: "Longer period", style: .default, handler: {(_) in
                        self.person?.prolongPeriod(date: cellState.date)
                        self.reloadCalendarData()
                    }))
                }else{
                    alert.addAction(UIAlertAction(title: startPeriodText, style: .default, handler: {(_) in
                        self.person?.startPeriod(date: cellState.date)
                        self.reloadCalendarData()
                    }))
                }
            }else{
                alert.addAction(UIAlertAction(title: endPeriodText, style: .default, handler: {(_) in
                    self.person?.endPeriod(date: cellState.date)
                    self.reloadCalendarData()
                }))
            }
            if cellData.shouldTakeThePill{
                if !cellData.didTookThePill{
                    alert.addAction(UIAlertAction(title: "Take pill", style: .default, handler: {(_) in
                        self.person?.takePill(date: cellState.date)
                        self.reloadCalendarData()
                    }))
                }else{
                    alert.addAction(UIAlertAction(title: "Did not took the pill", style: .default, handler: {(_) in
                        self.person?.didNotTookPill(date: cellState.date)
                        self.reloadCalendarData()
                    }))
                }
            }
            
            if !alert.actions.isEmpty {
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: {() in
                    self.reloadCalendarData()
                })
            }
        }
    }
    
    func reloadCalendarData(){
        if let person = DataManager.shared.data{
            self.person = person
        }
        self.calendarView.reloadData()
    }
    
    func setUpCalendarLabels(from visibleDates: DateSegmentInfo){
        guard let monthDates = visibleDates.monthDates.first else{
            return
        }

        yearLabel.text = Utils.formatDate(date: monthDates.date, format: "YYYY")
        monthLabel.text = Utils.formatDate(date: monthDates.date, format: "MMMM")
    }
    
    func setDataToView(){
        //Setup calendar spaceing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //select todays date
        calendarView.selectDates([ Date() ])
        calendarView.scrollToDate(Date())
        
        //Setup calendar labels
        calendarView.visibleDates{ visibleDates in
            self.setUpCalendarLabels(from: visibleDates)
        }
        
        //set next fertile and period days
        if let person = person, let nextFertileDays = person.getNextFertileDate(), let nextPeriodDays = person.getNextPeriodDate(){
            nextFertileDaysLabel.text = Utils.formatDate(date: nextFertileDays, format: "dd/MM")
            nextPeriodLabel.text = Utils.formatDate(date: nextPeriodDays, format: "dd/MM")
        }
        
        //set the period control button
        if let selectedDate = calendarView.selectedDates.first, let cellDataSelectedDate = person?.getCellDataByDate(date: selectedDate){
            if cellDataSelectedDate.isPeriodDay{
                periodControlButton.setTitle(endPeriodText, for: .normal)
            }else{
                periodControlButton.setTitle(startPeriodText, for: .normal)
            }
        }
    }
    
    @IBAction func periodControlButtonTapped(_ sender: UIButton) {
        if let date = self.calendarView.selectedDates.first, let title = sender.title(for: .normal), let cellData = person?.getCellDataByDate(date: date){
            if title == startPeriodText{
                if !cellData.isPeriodDay{
                    person?.startPeriod(date: date)
                    sender.setTitle(endPeriodText, for: .normal)
                    print("Start period")
                }
            }else{
                if cellData.isPeriodDay{
                    person?.endPeriod(date: date)
                    sender.setTitle(startPeriodText, for: .normal)
                    print("End period")
                }
            }
            self.reloadCalendarData()
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let initialDate: Date
        
        if let person = person {
            initialDate = person.firstPeriodRecord
        }else{
            initialDate = Date()
        }
        
        let startDate = initialDate
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: initialDate)
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate ?? initialDate)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.dateLabel.text = cellState.text
        
        let cellData = person?.getCellDataByDate(date: cellState.date)
        
        handleCellSelected(view: cell, cellState: cellState, cellData: cellData)
        handleCellDisplayData(view: cell, cellState: cellState, cellData: cellData)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cellData = person?.getCellDataByDate(date: cellState.date)
        handleCellSelected(view: cell, cellState: cellState, cellData: cellData)
        handleCellDisplayData(view: cell, cellState: cellState, cellData: cellData)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let cellData = person?.getCellDataByDate(date: cellState.date)
        handleDoubleTapOnCell(cell: cell, cellState: cellState, cellData: cellData)
        handleCellSelected(view: cell, cellState: cellState, cellData: cellData)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let cellData = person?.getCellDataByDate(date: cellState.date)
        handleCellSelected(view: cell, cellState: cellState, cellData: cellData)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarLabels(from: visibleDates)
    }
}


