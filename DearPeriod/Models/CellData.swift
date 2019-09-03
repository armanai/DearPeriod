//
//  PersonData.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 16/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import Foundation

struct CellData: Codable{
    let date: Date
    var isFertileDay: Bool
    var isPregnancyPossibilityHigh: Bool
    var isPeriodDay: Bool
    var shouldTakeThePill: Bool
    var didTookThePill: Bool
    var isFertileDayFuture: Bool
    var isPeriodDayFuture: Bool
    var shouldTakeThePillInFuture: Bool
    var dayOfCycle: Int?
    var isDateToProlongPeriod: Bool
    var person: Person? {
        return DataManager.shared.data
    }
    
    mutating func removePeriod(){
        self.isPeriodDay = false
    }
    
    mutating func tookPill(){
        self.didTookThePill = true
    }
    
    mutating func didNotTookPill(){
        self.didTookThePill = false
    }
    
    mutating func pregnancyPossiblityHigh(){
        self.isPregnancyPossibilityHigh = true
    }
}
