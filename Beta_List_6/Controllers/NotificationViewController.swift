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
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let planTextField: UITextField = {
       let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "Follow up plan"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let dateTextField: UITextField = {
       let textField = UITextField()
        textField.textAlignment = .center
        textField.placeholder = "Select a follow up date"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let setFollowUpButton: UIButton = {
       let button = UIButton(frame: .zero)
        button.setTitle("Set follow up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.delegate = self
        planTextField.delegate = self
        view.backgroundColor = .red
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
        
        view.addConstraintsWithFormat(format: "V:|-200-[v0]-[v1]-30-[v2]-[v3]", views: dateTextField,datePicker, planTextField, setFollowUpButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: dateTextField)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: datePicker)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: planTextField)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: setFollowUpButton)
        
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
        
        let patientListViewController = navigationController?.viewControllers[0] as! ListTableViewCellController
        self.navigationController?.popToRootViewController(animated: true)
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
