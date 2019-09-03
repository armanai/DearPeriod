//
//  FormViewController.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 18/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import UIKit
import UserNotifications

class FormViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cycleDurationTextField: UITextField!
    @IBOutlet weak var periodDurationTextField: UITextField!
    @IBOutlet weak var pillsTextField: UITextField!
    @IBOutlet weak var lastPeriodStartedTextField: UITextField!
    @IBOutlet weak var timeForTakingPillsTextField: UITextField!
    
    private let pickerDataPills = ["Yes", "No"]
    private var pickerDataNumbers:[Int] = []
    
    private var datePicker: UIDatePicker?
    private var timePicker: UIDatePicker?
    private var pillsPicker: UIPickerView?
    private var numberPickerPeriod: UIPickerView?
    private var numberPickerCycle: UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing data for the number picker
        pickerDataNumbers = getArrayOfNumbers()
        
        //adding tap gesture to the view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FormViewController.viewTapped(tapGesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //assigning delegates to text fields
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        cycleDurationTextField.delegate = self
        periodDurationTextField.delegate = self
        pillsTextField.delegate = self
        lastPeriodStartedTextField.delegate = self
        timeForTakingPillsTextField.delegate = self
        
        //adding targets to text fields
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cycleDurationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        periodDurationTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        pillsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastPeriodStartedTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        timeForTakingPillsTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //pickers
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(FormViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(FormViewController.timeChanged(datePicker:)), for: .valueChanged)
        
        pillsPicker = UIPickerView()
        pillsPicker?.delegate = self
        pillsPicker?.dataSource = self
        
        numberPickerPeriod = UIPickerView()
        numberPickerPeriod?.delegate = self
        numberPickerPeriod?.dataSource = self
        
        numberPickerCycle = UIPickerView()
        numberPickerCycle?.delegate = self
        numberPickerCycle?.dataSource = self
        
        //adding Pickers to text fields
        pillsTextField.inputView = pillsPicker
        lastPeriodStartedTextField.inputView = datePicker
        timeForTakingPillsTextField.inputView = timePicker
        cycleDurationTextField.inputView = numberPickerCycle
        periodDurationTextField.inputView = numberPickerPeriod
    }
    
    func getArrayOfNumbers() -> [Int]{
        var arrayOfNumbers:[Int] = []
        for i in 1...100{
            arrayOfNumbers.append(i)
        }
        return arrayOfNumbers
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkIfTextFieldIsEmpty(textField: textField)
    }
    
    @objc func viewTapped(tapGesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        lastPeriodStartedTextField.text = Utils.formatDate(date: datePicker.date, format: "dd/MM/yyyy")
    }
    
    @objc func timeChanged(datePicker: UIDatePicker){
        timeForTakingPillsTextField.text = Utils.formatDate(date: datePicker.date, format: "HH:mm")
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        if let nameText = nameTextField.text, !nameText.isEmpty, let lastNameText = lastNameTextField.text, !lastNameText.isEmpty, let periodDurationText = periodDurationTextField.text, let approximatePeriodDuration = Int(periodDurationText), let cycleDurationText = cycleDurationTextField.text, let approximateCycleDuration = Int(cycleDurationText), let pillsText = pillsTextField.text, !pillsText.isEmpty, let lastPeriodStartedText = lastPeriodStartedTextField.text, !lastPeriodStartedText.isEmpty, let firstPeriodRecord = Utils.getDateFromString(stringDate: lastPeriodStartedText, format: "dd/MM/yyyy"), approximateCycleDuration > approximatePeriodDuration{
            
            let isTakingPills = (pillsText == "Yes") ? true : false
            
            let person = Person(firstName: nameText, lastName: lastNameText, approximatePeriodDuration: approximatePeriodDuration, approximateFertileDaysDuration: 3, approximateCycleDuration: approximateCycleDuration, firstPeriodRecord: firstPeriodRecord, isTakingPills: isTakingPills)
            
            if isTakingPills, let timeForPillsText = timeForTakingPillsTextField.text, !timeForPillsText.isEmpty{
                person.timeForTakingPills = timeForPillsText
            }
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                
                person.setNotificationsForDatesStartingFrom(date: firstPeriodRecord)
                
            })
            
            DataManager.shared.savePerson(person: person)
            
            if let homeNavigationController = storyboard?.instantiateViewController(withIdentifier: "Home") as? UINavigationController, let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController{
                
                homeViewController.person = person
                self.present(homeNavigationController, animated: true, completion: nil)
            }
            
        }else{
            Utils.showAlert(view: self, title: "All fields are required.", message: "Please fill out all fields.", preferredStyle: .alert, closeButtonTitle: "Ok")
        }
    }
    
    func checkIfTextFieldIsEmpty(textField: UITextField){
        if let input = textField.text, input.isEmpty {
            invalidTextField(textField: textField)
        }else{
            validTextField(textField: textField)
        }
    }
    
    func invalidTextField(textField: UITextField){
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    }
    
    func validTextField(textField: UITextField){
        textField.layer.borderWidth = 0
    }
}

extension FormViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FormViewController: UIPickerViewDelegate{
}

extension FormViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pillsPicker{
            return pickerDataPills.count
        }
        return pickerDataNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pillsPicker{
            return pickerDataPills[row]
        }
        return "\(pickerDataNumbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(pickerView){
            case pillsPicker:
                pillsTextField.text = pickerDataPills[row]
                break
            case numberPickerPeriod:
                periodDurationTextField.text = "\(pickerDataNumbers[row])"
                break
            case numberPickerCycle:
                cycleDurationTextField.text = "\(pickerDataNumbers[row])"
                break
            default:
                print("error while picking items in uipickerview")
        }
    }
}
