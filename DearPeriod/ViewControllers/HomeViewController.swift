//
//  HomeViewController.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 18/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cycleDateLabel: UILabel!
    @IBOutlet weak var fertileDateLabel: UILabel!
    @IBOutlet weak var dayDescriptionLabel: UILabel!
    @IBOutlet weak var periodControlButton: UIButton!
    
    let endPeriodText: String = "End period"
    let startPeriodText: String = "Start period"
    
    var person: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if person == nil{
            person = DataManager.shared.data
        }
        let calendar = Calendar.current
        //initialize dictionary a year from today
        if let dateEnding = calendar.date(byAdding: .day, value: -1, to: Date()){
            person?.setNotificationsForDatesStartingFrom(date: dateEnding)
        }
        
        self.setDataToView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
    }
    
    func reloadData(){
        if let person = DataManager.shared.data{
            self.person = person
        }
        self.setDataToView()
    }
  
    @IBAction func periodControlButtonTapped(_ sender: UIButton) {
        if let title = sender.title(for: .normal), let cellData = person?.getCellDataByDate(date: Date()){
            if title == startPeriodText {
                if !cellData.isPeriodDay{
                    person?.startPeriod(date: Date())
                    sender.setTitle(endPeriodText, for: .normal)
                }
            }else{
                if cellData.isPeriodDay{
                    person?.endPeriod(date: Date())
                    sender.setTitle(startPeriodText, for: .normal)
                }
            }
        }
        self.reloadData()
    }
    
    @IBAction func calendarTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showCalendar", sender: self)
    }
    
    func setDataToView(){
        guard let person = person else{
            return
        }
        
        //setting the day label
        if let cellData = person.getCellDataByDate(date: Date()) {
            if cellData.isPeriodDay{
                dayDescriptionLabel.text = "Day of period"
                dayLabel.text = String(person.getDayOfPeriod())
            }else{
                dayDescriptionLabel.text = "Days to period"
                dayLabel.text = String(person.getDaysToPeriod())
            }
        }
        
        //setting fertile days and next period labels
        if let nextFertileDaysStart = person.getNextFertileDate(), let nextPeriodStarts = person.getNextPeriodDate() {
            cycleDateLabel.text = Utils.formatDate(date: nextPeriodStarts, format: "dd/MM")
            fertileDateLabel.text = Utils.formatDate(date: nextFertileDaysStart, format: "dd/MM")
        }
        
        //seting period control button
        if let cellDataToday = person.getCellDataByDate(date: Date()) {
            if cellDataToday.isPeriodDay{
                periodControlButton.setTitle(endPeriodText, for: .normal)
            }else{
                periodControlButton.setTitle(startPeriodText, for: .normal)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVc = segue.destination as? CalendarViewController{
            detailVc.person = person
        }
    }
}
