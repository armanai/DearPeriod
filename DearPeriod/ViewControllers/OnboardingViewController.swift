//
//  OnboardingVCViewController.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 04/12/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController {
    
    let onboardingItemInfos:[OnboardingItemInfo] = {
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "1"),
                               title: "Welcome!",
                               description: "Thank you for downloading DearPeriod ❤️",
                               pageIcon: #imageLiteral(resourceName: "flowerColor"),
                               color: #colorLiteral(red: 1, green: 0.8842272251, blue: 0.9453912489, alpha: 1),
                               titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               titleFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light),
                               descriptionFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "neco"),
                               title: "Every flower is unique 🌸",
                               description: "DearPeriod will change its predictions as your cycle changes, and by confirming the start and end dates of your period, DearPeriod enables you to predict and track your period and fertile days.",
                               pageIcon: #imageLiteral(resourceName: "flowerColor"),
                               color: #colorLiteral(red: 0.8727470464, green: 1, blue: 0.8606232569, alpha: 1),
                               titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               titleFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light),
                               descriptionFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "pillhero"),
                               title: "Got pills?",
                               description: "DearPeriod will track your pill intake for you, and notify you to make sure you don't accidentally get a bun in the over 😜",
                               pageIcon: #imageLiteral(resourceName: "flowerColor"),
                               color: #colorLiteral(red: 0.8610770517, green: 0.8780811797, blue: 1, alpha: 1),
                               titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               titleFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light),
                               descriptionFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "3"),
                               title: "Every change starts with yourself 🙏",
                               description: "To start, please tell us a little bit about yourself, so we can tailor the best possible calendar just for you!",
                               pageIcon: #imageLiteral(resourceName: "flowerColor"),
                               color: #colorLiteral(red: 0.9733991399, green: 0.9764705896, blue: 0.8361709163, alpha: 1),
                               titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               titleFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light),
                               descriptionFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)),
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "2"),
                               title: "",
                               description: "",
                               pageIcon: #imageLiteral(resourceName: "flowerColor"),
                               color: #colorLiteral(red: 0.9568627477, green: 0.8027570224, blue: 0.7490885915, alpha: 1),
                               titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                               descriptionColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),
                               titleFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light),
                               descriptionFont: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light))
        ]
    }()

    @IBOutlet weak var getStartedButton: UIButton!
    let onboardingView:PaperOnboarding = PaperOnboarding()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        
        onboardingView.delegate = self
        onboardingView.dataSource = self
        
        view.addSubview(onboardingView)
        view.addSubview(getStartedButton)
        
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboardingView,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}


extension OnboardingViewController: PaperOnboardingDataSource{
    func onboardingItemsCount() -> Int {
        return onboardingItemInfos.count
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItemInfos[index]
    }
}

extension OnboardingViewController: PaperOnboardingDelegate{
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == onboardingItemInfos.count-1{
            UIView.animate(withDuration: 0.4) {
                self.getStartedButton.alpha = 1
            }
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != onboardingItemInfos.count-1{
            if self.getStartedButton.alpha == 1{
                UIView.animate(withDuration: 0.2) {
                    self.getStartedButton.alpha = 0
                }
            }
        }
    }
}
