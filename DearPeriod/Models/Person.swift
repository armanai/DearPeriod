//
//  WomenData.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 14/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import Foundation
import UserNotifications

class Person: Codable{
    let firstName: String
    let lastName: String
    var approximatePeriodDuration: Int
    var approximateFertileDaysDuration: Int
    let firstPeriodRecord: Date
    var approximateCycleDuration: Int
    var lastPeriodStarted: Date
    var isTakingPills: Bool
    var timeForTakingPills: String
    var periodDates: [Date]?
    var periodDuartions: [Int] = []
    var cycleDurations: [Int] = []
    var data: [Int: [Int: [Int: CellData?]]] = [:]
    let calendar = Calendar.current
    
    init(firstName: String, lastName: String, timeForTakingPills: String = "18:00" ,approximatePeriodDuration: Int = 5, approximateFertileDaysDuration: Int = 2, approximateCycleDuration: Int = 26, firstPeriodRecord: Date, isTakingPills: Bool = false, isPillPause: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.timeForTakingPills = timeForTakingPills
        self.approximatePeriodDuration = approximatePeriodDuration
        self.approximateFertileDaysDuration = approximateFertileDaysDuration
        self.approximateCycleDuration = approximateCycleDuration
        self.lastPeriodStarted = firstPeriodRecord
        self.firstPeriodRecord = firstPeriodRecord
        self.isTakingPills = isTakingPills
        
        cycleDurations.append(approximateCycleDuration)
        periodDuartions.append(approximatePeriodDuration)
        
        initializeEmptyCalendarDataArray(from: firstPeriodRecord)
        showCycle(startingDate: firstPeriodRecord)
        showPossibleCycles(fromDate: firstPeriodRecord)
    }
    
    func initializeEmptyCalendarDataArray(from: Date){
        let calendar = Calendar.current
        //initialize dictionary a year from today
        let dateEnding = calendar.date(byAdding: .year, value: 1, to: Date())
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: from, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date, let dateEnding = dateEnding {
                if date > dateEnding {
                    stop = true
                }else{
                    var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
                    
                    if let year = components.year, let month = components.month, let day = components.day{
                        if data[year] == nil{
                            data[year] = [:]
                        }
                        
                        if data[year]?[month] == nil{
                            data[year]?[month] = [:]
                        }
                        
                        data[year]?[month]?[day] = nil
                    }
                }
            }
        }
    }
    
    func rerenderPossibleData(startingForm: Date){
        showPossibleCycles(fromDate: startingForm)
    }
    
    func showCycle(startingDate: Date){
        var indexDayOfCycle = 1
        let dateEnding = calendar.date(byAdding: .day, value: self.approximateCycleDuration, to: startingDate)
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: startingDate, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date, let dateEnding = dateEnding {
                if date > dateEnding {
                    stop = true
                }else{
                    if indexDayOfCycle <= approximatePeriodDuration {
                        self.setCellDataByDate(date: date, cellData: CellData(date: date, isFertileDay: false, isPregnancyPossibilityHigh: false, isPeriodDay: true, shouldTakeThePill: false, didTookThePill: false, isFertileDayFuture: false, isPeriodDayFuture: false, shouldTakeThePillInFuture: false, dayOfCycle: indexDayOfCycle, isDateToProlongPeriod: false))
                    } else {
                        if indexDayOfCycle == approximateCycleDuration-18 || indexDayOfCycle == approximateCycleDuration-17 || indexDayOfCycle == approximateCycleDuration-16 {
                            var cellData = CellData(date: date, isFertileDay: true, isPregnancyPossibilityHigh: false, isPeriodDay: false, shouldTakeThePill: self.isTakingPills, didTookThePill: false, isFertileDayFuture: false, isPeriodDayFuture: false, shouldTakeThePillInFuture: false, dayOfCycle: indexDayOfCycle, isDateToProlongPeriod: false)
                            if(indexDayOfCycle == approximateCycleDuration-17){
                                cellData.pregnancyPossiblityHigh()
                            }
                            self.setCellDataByDate(date: date, cellData: cellData)
                        }else{
                            if indexDayOfCycle == approximatePeriodDuration || indexDayOfCycle == approximatePeriodDuration+1 || indexDayOfCycle == approximatePeriodDuration+2{
                                self.setCellDataByDate(date: date, cellData: CellData(date: date, isFertileDay: false, isPregnancyPossibilityHigh: false, isPeriodDay: false, shouldTakeThePill: self.isTakingPills, didTookThePill: false, isFertileDayFuture: false, isPeriodDayFuture: false, shouldTakeThePillInFuture: false, dayOfCycle: indexDayOfCycle, isDateToProlongPeriod: true))
                                print("added prolonged days")
                            }else{
                                self.setCellDataByDate(date: date, cellData: CellData(date: date, isFertileDay: false, isPregnancyPossibilityHigh:false, isPeriodDay: false, shouldTakeThePill: self.isTakingPills, didTookThePill: false, isFertileDayFuture: false, isPeriodDayFuture: false, shouldTakeThePillInFuture: false, dayOfCycle: indexDayOfCycle, isDateToProlongPeriod: false))
                            }
                        }
                    }
                    
                    indexDayOfCycle += 1
                }
            }
        }
        
        self.periodDuartions.append(approximatePeriodDuration)
    }
    
    func showPossibleCycles(fromDate: Date){
        var dataShowed = false

        guard var possibleCycleStarts = calendar.date(byAdding: .day, value: self.approximateCycleDuration, to: fromDate) else{
            print("Function showPossibleCycles: Got nil when creating date")
            return
        }
        
        var possibleCycleEnds = calendar.date(byAdding: .day, value: self.approximateCycleDuration, to: possibleCycleStarts)
        
        guard let yearFromToday = calendar.date(byAdding: .year, value: 1, to: Date()) else{
            print("Function showPossibleCycles: Could not find date a year form today")
            return
        }
        
        while !dataShowed {
            if possibleCycleStarts > yearFromToday{
                dataShowed = true
            }
            
            showPossibleCycle(startingDate: possibleCycleStarts)
            
            if let possibleCycleEnd = possibleCycleEnds, let newPossibleCycleStarts = calendar.date(byAdding: .day, value: 1, to: possibleCycleEnd){
                possibleCycleStarts = newPossibleCycleStarts
                possibleCycleEnds = calendar.date(byAdding: .day, value: self.approximateCycleDuration, to: possibleCycleStarts)
            }
        }
    }
    
    func showPossibleCycle(startingDate: Date){
        var indexDayOfCycle = 1
        let calendar = Calendar.current
        let dateEnding = calendar.date(byAdding: .day, value: self.approximateCycleDuration, to: startingDate)
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: startingDate, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date, let dateEnding = dateEnding {
                if date > dateEnding {
                    stop = true
                }else{
                    if indexDayOfCycle <= approximatePeriodDuration {
                        self.setCellDataByDate(date: date, cellData: CellData(date: date, isFertileDay: false, isPregnancyPossibilityHigh: false, isPeriodDay: false, shouldTakeThePill: false, didTookThePill: false, isFertileDayFuture: false, isPeriodDayFuture: true, shouldTakeThePillInFuture: false, dayOfCycle: indexDayOfCycle, isDateToProlongPeriod: false))
                    } else {
                        if indexDayOfCycle == approximateCycleDuration-18 || indexDayOfCycle == approximateCycleDuration-17 || indexDayOfCycle == approximateCycleDuration-16{
                            self.setCellDataByDate(date: date, cellData: CellData(date: date, isFertileDay: false, isPregnancyPossibilityHigh: false, isPeriodDay: false, shouldTakeThePill: false, didTookThePill: false, isFertileDayFuture: true, isPeriodDayFuture: false, shouldTakeThePillInFuture: self.isTakingPills, dayOfCycle: indexDayOfCycle, isDateToProlongPeriod: false))
                        }else{
                            self.setCellDataByDate(date: date, cellData: CellData(date: date, isFertileDay: false, isPregnancyPossibilityHigh: false, isPeriodDay: false, shouldTakeThePill: false, didTookThePill: false, isFertileDayFuture: false, isPeriodDayFuture: false, shouldTakeThePillInFuture: self.isTakingPills, dayOfCycle: indexDayOfCycle, isDateToProlongPeriod: false))
                        }
                    }
                    
                    indexDayOfCycle += 1
                }
            }
        }
    }
    
    func startPeriod(date: Date){
        let dateStarting = calendar.date(byAdding: .day, value: -1, to: date)
        let renderPossibleDataFromDate = calendar.date(byAdding: .day, value: approximateCycleDuration, to: date)
        
        if let dateStaring = dateStarting, let renderPossibleDataFromDate = renderPossibleDataFromDate{
            self.showCycle(startingDate: dateStaring)
            self.rerenderPossibleData(startingForm: renderPossibleDataFromDate)
        }
        
        DataManager.shared.savePerson(person: self)
    }
    
    func endPeriod(date: Date){
        let dateStarting = calendar.date(byAdding: .day, value: -1, to: date)
        let dateEnding = calendar.date(byAdding: .year, value: 1, to: date)
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        
        if let dateStarting = dateStarting{
            calendar.enumerateDates(startingAfter: dateStarting, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
                if let date = date, let dateEnding = dateEnding {
                    if date > dateEnding {
                        stop = true
                    }else{
                        if var cellData = self.getCellDataByDate(date: date){
                            if cellData.isPeriodDay{
                                cellData.removePeriod()
                                self.setCellDataByDate(date: date, cellData: cellData)
                            }else{
                                stop = true
                            }
                        }
                    }
                }
            }
        }
        
        self.periodDuartions.append(self.calculatePeriodDurationIfEnded(on: date)-1)

        DataManager.shared.savePerson(person: self)
    }
    
    func prolongPeriod(date: Date){
        var calculationsDone = false
        var index = 0
        var dateToCheck = calendar.date(byAdding: .day, value: index * -1, to: date)
        
        while !calculationsDone {
            if let dateToCheck = dateToCheck, var cellData = self.getCellDataByDate(date: dateToCheck){
                if cellData.isDateToProlongPeriod{
                    index += 1
                    cellData.isPeriodDay = true
                    self.setCellDataByDate(date: cellData.date, cellData: cellData)
                }else{
                    calculationsDone = true
                }
            }
            
            dateToCheck = calendar.date(byAdding: .day, value: index * -1, to: date)
        }
    }
    
    func takePill(date: Date){
        if var cellData = self.getCellDataByDate(date: date){
            cellData.tookPill()
            self.setCellDataByDate(date: date, cellData: cellData)
        }
    }
    
    func didNotTookPill(date: Date){
        if var cellData = self.getCellDataByDate(date: date){
            cellData.didNotTookPill()
            self.setCellDataByDate(date: date, cellData: cellData)
        }
    }
    
    func getDayOfPeriod() -> Int{
        var dayOfPeriod:Int = 1
        var calculationsDone = false
        var dateToCheck = calendar.date(byAdding: .day, value: dayOfPeriod * -1, to: Date())
        
        while !calculationsDone {
            if let dateToCheck = dateToCheck, let cellData = self.getCellDataByDate(date: dateToCheck){
                if cellData.isPeriodDay{
                    dayOfPeriod += 1
                }else{
                    calculationsDone = true
                }
            }
            
            dateToCheck = calendar.date(byAdding: .day, value: dayOfPeriod * -1, to: Date())
        }
        
        return dayOfPeriod
    }
    
    func getDaysToPeriod() -> Int{
        var daysToPeriod:Int = 0
        let dateEnding = calendar.date(byAdding: .year, value: 1, to: Date())
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        
        calendar.enumerateDates(startingAfter: Date(), matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date, let dateEnding = dateEnding {
                if date > dateEnding {
                    stop = true
                }else{
                    if let cellData = self.getCellDataByDate(date: date), (cellData.isPeriodDay || cellData.isPeriodDayFuture){
                        stop = true
                    }
                    daysToPeriod += 1
                }
            }
        }
        
        return daysToPeriod
    }
    
    func getNextFertileDate() -> Date?{
        var nextFertileDays:Date? = nil
        let dateEnding = calendar.date(byAdding: .year, value: 1, to: Date())
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        
        calendar.enumerateDates(startingAfter: Date(), matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date, let dateEnding = dateEnding {
                if date > dateEnding {
                    stop = true
                }else{
                    if let cellData = self.getCellDataByDate(date: date), (cellData.isFertileDayFuture || cellData.isFertileDay){
                        nextFertileDays = date
                        stop = true
                    }
                }
            }
        }
        
        return nextFertileDays
    }
    
    func getNextPeriodDate() -> Date?{
        var nextPeriodDate:Date? = nil
        let dateEnding = calendar.date(byAdding: .year, value: 1, to: Date())
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        
        calendar.enumerateDates(startingAfter: Date(), matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date, let dateEnding = dateEnding {
                if date > dateEnding {
                    stop = true
                }else{
                    if let cellData = self.getCellDataByDate(date: date), (cellData.isPeriodDayFuture || cellData.isPeriodDay){
                        nextPeriodDate = date
                        stop = true
                    }
                }
            }
        }
        
        return nextPeriodDate
    }
    
    func calculatePeriodDurationIfEnded(on date: Date) -> Int{
        var periodDuration:Int = 1
        var calculationsDone = false
        var dateToCheck = calendar.date(byAdding: .day, value: periodDuration * -1, to: date)
        
        while !calculationsDone {
            if let dateToCheck = dateToCheck, let cellData = self.getCellDataByDate(date: dateToCheck){
                if cellData.isPeriodDay{
                    periodDuration += 1
                }else{
                    calculationsDone = true
                }
            }
            
            dateToCheck = calendar.date(byAdding: .day, value: periodDuration * -1, to: date)
        }
        
        self.calculateApproximatePeriodDuration()
        return periodDuration
    }
    
    func calculateApproximatePeriodDuration(){
        var periodDurationSum = 0
        
        for duration in self.periodDuartions{
            periodDurationSum += duration
        }
        
        self.approximatePeriodDuration = Int(periodDurationSum / self.periodDuartions.count)
    }
    
    //get and set data
    func getCellDataByDate(date: Date) -> CellData?{
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
        
        guard let year = components.year, let month = components.month, let day = components.day else {
            return nil
        }
        
        return data[year]?[month]?[day] ?? nil
    }
    
    func setCellDataByDate(date: Date, cellData: CellData){
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
        
        if let year = components.year, let month = components.month, let day = components.day{
            data[year]?[month]?[day] = cellData
        }
    }
    
    func getTimeForTakingPillsComponent() -> [Int]{
        let time:[String] = self.timeForTakingPills.components(separatedBy: ":")
        var hour:Int = 18
        var minutes:Int = 0
        
        if !time.isEmpty && time.count == 2, let h = Int(time[0]), let m = Int(time[1]){
            hour = h
            minutes = m
        }
        
        return [hour, minutes]
    }
    
    //notifications
    func addNotificationForDate(date: Date){
        let timeToTakePills = getTimeForTakingPillsComponent()
        let content = UNMutableNotificationContent()
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
        
        content.sound = UNNotificationSound.default
        
        components.hour = timeToTakePills[0]
        components.minute = timeToTakePills[1]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        guard let cellData = getCellDataByDate(date: date) else{
            return
        }
        
        if cellData.shouldTakeThePill && !cellData.didTookThePill{
            content.title = "It is pills time"
            content.body = "Please take your pill."
        }
        
        if cellData.isPeriodDayFuture && !cellData.isPeriodDay{
            content.title = "Period"
            content.body = "Did you forgot to start your period?"
        }
        
        let request = UNNotificationRequest(identifier: Utils.formatDate(date: date, format: "dd/MM/yyyy"), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    //delete all notifications and add new ones
    func setNotificationsForDatesStartingFrom(date: Date){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let calendar = Calendar.current
        let dateEnding = calendar.date(byAdding: .month, value: 1, to: Date())
        let components = DateComponents(hour: 0, minute: 0, second: 0)
        calendar.enumerateDates(startingAfter: date, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
            if let date = date, let dateEnding = dateEnding {
                if date > dateEnding {
                    stop = true
                }else{
                    addNotificationForDate(date: date)
                }
            }
        }
    }
}
