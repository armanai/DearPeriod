//
//  CustomCell.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 15/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pillImage: UIImageView!
    @IBOutlet weak var fertileImage: UIImageView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var periodView: UIView!
    @IBOutlet weak var cycleDay: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    func setPillImage(shouldTakeThePill: Bool, didTookThePill: Bool, shouldTakeThePillInFuture: Bool = false){
        if shouldTakeThePillInFuture{
            pillImage.image = #imageLiteral(resourceName: "pill")
            pillImage.layer.opacity = 0.2
        }
        
        if shouldTakeThePill{
            if shouldTakeThePillInFuture{
                pillImage.layer.opacity = 0.2
            }
            
            if didTookThePill{
                pillImage.image = #imageLiteral(resourceName: "pillColor")
            }else{
                pillImage.image = #imageLiteral(resourceName: "pill")
            }
        }
    }
    
    func setFertileDaysImage(isFertileDay: Bool, isFertileDayFuture:Bool = false, isPregnancyPossibilityHigh:Bool = false){
        if isFertileDayFuture{
            fertileImage.image = #imageLiteral(resourceName: "flowerColor")
            fertileImage.layer.opacity = 0.1
        }
        if isFertileDay {
            fertileImage.image = #imageLiteral(resourceName: "flowerColor")
            if isPregnancyPossibilityHigh{
                fertileImage.image = #imageLiteral(resourceName: "ovulation")
            }
        }
    }
    
    func setPeriod(isPeriodDay: Bool, possiblePeriodDay:Bool = false){
        if possiblePeriodDay{
            periodView.isHidden = false
            periodView.layer.opacity = 0.1
        }
        if isPeriodDay {
            periodView.isHidden = false
            dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func reset(){
        periodView.isHidden = true
        pillImage.image = nil
        fertileImage.image = nil
        fertileImage.layer.opacity = 1
        pillImage.layer.opacity = 1
        periodView.layer.opacity = 1
    }
}
