//
//  NotificationViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/22/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications 

class NotificationViewController: UIViewController, UITextFieldDelegate {
    
    
    var managedContext: NSManagedObjectContext!
    var patient = Patient()
    
    let datePicker: UIDatePicker = {
       let picker = UIDatePicker(frame: .zero)
        picker.minimumDate = Date()
        picker.layer.cornerRadius = 15
        picker.layer.masksToBounds = true
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.black.cgColor
        picker.backgroundColor = .lightGray
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let planTextField: UITextField = {
       let textField = UITextField() 
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.backgroundColor = .lightGray
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.placeholder = "Follow Up Plan"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateTextField: UITextField = {
       let textField = UITextField()
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .lightGray
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        textField.placeholder = "Select a follow up date"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let setFollowUpButton: UIButton = {
       let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("Set follow up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Follow Up"
        dateTextField.delegate = self
        planTextField.delegate = self
        view.backgroundColor = .white
        setupView()
        
        
        datePicker.addTarget(self, action: #selector(NotificationViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NotificationViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        setupView()
    }

    func setupView() {
        view.addSubview(dateTextField)
        view.addSubview(datePicker)
        view.addSubview(planTextField)
        view.addSubview(setFollowUpButton)
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        dateTextField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 50).isActive = true
        dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        dateTextField.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -5).isActive = true
        
        datePicker.topAnchor.constraint(equalTo: dateTextField.bottomAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        planTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        planTextField.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 30).isActive = true
        planTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        planTextField.widthAnchor.constraint(equalTo: datePicker.widthAnchor).isActive = true
        
        setFollowUpButton.topAnchor.constraint(equalTo: planTextField.bottomAnchor, constant: 30).isActive = true
        setFollowUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setFollowUpButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        setFollowUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        

        
        setFollowUpButton.addTarget(self, action: #selector(returnToPatientList), for: .touchUpInside)
        planTextField.addTarget(self, action: #selector(savePlan), for: .editingDidEnd)
        
        
    }

    @objc func dateChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d.yy h:mm a"
        dateTextField.text = formatter.string(from: datePicker.date)
        patient.followUpDate = datePicker.date as NSDate
        do {
            try managedContext.save()
        }catch let error as NSError {
            print("Error saving follow up date \(error) ")
        }
    }
    
    @objc func returnToPatientList() {
        
        let followUpNotification = UNMutableNotificationContent()
        followUpNotification.title = "Follow up for \(String(describing: patient.firstName)) \(String(describing: patient.lastName))"
        followUpNotification.body = "Scheduled for \(patient.followUpPlan!))"
        followUpNotification.sound = UNNotificationSound.default()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour,.minute,.second], from: (patient.followUpDate! as Date))
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Follow up", content: followUpNotification, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        do {
            try managedContext.save()
        }catch let error as NSError {
            print("Error saving follow up date \(error) ")
        }
        
        let patientListViewController = navigationController?.viewControllers[1] as! ListTableViewCellController
        patientListViewController.tableView.reloadData() 
        navigationController?.popToViewController(patientListViewController, animated: true)
    }
    
    @objc func savePlan() {
        guard let patientPlan = planTextField.text else {return}
        patient.followUpPlan = patientPlan
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error saving follow up plan. \(error) ")
        }
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
}
