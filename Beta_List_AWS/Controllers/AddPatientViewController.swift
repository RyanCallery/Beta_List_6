//
//  AddPatientViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/17/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddPatientViewController: UITableViewController {
    let firstNameCell = "firstNameCell"
    let lastNameCell = "lastNameCell"
    let medicalRecordNumber = "medicalRecordNumber"
    let telephoneNumber = "telephoneNumber"
    let age = "age"
    let parity = "parity"
    let gestationalAge = "gestationalAge"
    let historyOfPresentIllness = "historyOfPresentIllness"
    
    var managedContext: NSManagedObjectContext! 
    
    var patient: Patient?
    override func viewDidLoad() {
        super.viewDidLoad()
        patient = Patient(context: managedContext)
        tableView.register(FirstNameCell.self, forCellReuseIdentifier: firstNameCell)
        tableView.register(LastNameCell.self, forCellReuseIdentifier: lastNameCell)
        tableView.register(MedicalRecordNumberCell.self, forCellReuseIdentifier: medicalRecordNumber)
        tableView.register(TelephoneNumberCell.self, forCellReuseIdentifier: telephoneNumber)
        tableView.register(AgeCell.self, forCellReuseIdentifier: age)
        tableView.register(ParityCell.self, forCellReuseIdentifier: parity)
        tableView.register(GestationalAgeCell.self, forCellReuseIdentifier: gestationalAge)
        tableView.register(HistoryOfPresentIllnessCell.self, forCellReuseIdentifier: historyOfPresentIllness)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderHeight = 50
        tableView.tableFooterView = UIView()
        navigationItem.title = "Add Patient"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePatient))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationController?.navigationBar.isTranslucent = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
       
        
      
    }
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    @objc func savePatient() {
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Unable to save patient to database")
        }
        let patientListViewController = navigationController?.viewControllers[1] as! ListTableViewCellController
        patientListViewController.patient = self.patient 
        navigationController?.popToViewController(patientListViewController, animated: true)

    }
    
    ///  Mark: TableView Data Source and Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: let cell = tableView.dequeueReusableCell(withIdentifier: firstNameCell, for: indexPath) as! FirstNameCell
                cell.addPatientViewController = self
                return cell 
            case 1: let cell = tableView.dequeueReusableCell(withIdentifier: lastNameCell, for: indexPath) as! LastNameCell
                cell.addPatientViewController = self
                return cell
            case 2: let cell = tableView.dequeueReusableCell(withIdentifier: medicalRecordNumber, for: indexPath) as! MedicalRecordNumberCell
                cell.addPatientViewController = self
                return cell
            case 3: let cell = tableView.dequeueReusableCell(withIdentifier: telephoneNumber, for: indexPath) as! TelephoneNumberCell
                cell.addPatientViewController = self
                return cell
            default: fatalError("Only 4 cells")
            }
        case 1:
            switch indexPath.row {
            case 0: let cell = tableView.dequeueReusableCell(withIdentifier: age, for: indexPath) as! AgeCell
                cell.addPatientViewController = self
                return cell
            case 1: let cell = tableView.dequeueReusableCell(withIdentifier: parity, for: indexPath) as! ParityCell
                cell.addPatientViewController = self
                return cell
            case 2: let cell = tableView.dequeueReusableCell(withIdentifier: gestationalAge, for: indexPath) as! GestationalAgeCell
                cell.addPatientViewController = self
                return cell
            case 3: let cell = tableView.dequeueReusableCell(withIdentifier: historyOfPresentIllness, for: indexPath) as! HistoryOfPresentIllnessCell
                cell.addPatientViewController = self
                return cell
            default: fatalError("only 4 rows exist")
            }
        default:
            fatalError("Only 2 sections exist")
        }
        
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Patient Information"
        } else {
            return "Clinical Information"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 
    }
    
    func saveFirstName (_ patientInfo: String){
        patient?.firstName = patientInfo
        
    }
    
    func saveLastName (_ patientInfo: String){
        patient?.lastName = patientInfo
    }
    func saveMRN (_ patientInfo: String){
        patient?.medicalRecordNumber = patientInfo
      
    }
    func saveTelephoneNumber (_ patientInfo: String){
        patient?.telephoneNumber = patientInfo
        
    }
    func saveAge (_ patientInfo: String){
        patient?.age = patientInfo
        
    }
    func saveParity (_ patientInfo: String){
        patient?.parity = patientInfo
        
    }
    func saveGestationalAge (_ patientInfo: String){
        patient?.gestationalAge = patientInfo
        
    }
    func saveHPI (_ patientInfo: String){
        patient?.historyOfPresentIllness = patientInfo
       
    }

    
}
extension AddPatientViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class FirstNameCell: BaseTableViewCell{
    
    var addPatientViewController: AddPatientViewController?
    
    let firstNametTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupViews() {
        addSubview(firstNametTextField)
        firstNametTextField.addTarget(self, action: #selector(saveInfo), for: .editingDidEnd)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": firstNametTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": firstNametTextField]))
        firstNametTextField.delegate = self
        
        
        
    }
    
    @objc func saveInfo() {
        guard let patientInfo = firstNametTextField.text else {return}
        addPatientViewController?.saveFirstName(patientInfo)
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class LastNameCell: BaseTableViewCell {
    
    var addPatientViewController: AddPatientViewController?
    
    let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupViews() {
        addSubview(lastNameTextField)
        lastNameTextField.addTarget(self, action: #selector(saveInfo), for: .editingDidEnd)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": lastNameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": lastNameTextField]))
        lastNameTextField.delegate = self
        
    }
    @objc func saveInfo() {
        guard let patientInfo = lastNameTextField.text else {return}
        addPatientViewController?.saveLastName(patientInfo)
        }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class MedicalRecordNumberCell: BaseTableViewCell{
    var addPatientViewController: AddPatientViewController?
    
    let medicalRecordNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Medical Record Number"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupViews() {
        addSubview(medicalRecordNumberTextField)
        medicalRecordNumberTextField.addTarget(self, action: #selector(saveInfo), for: .editingDidEnd)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": medicalRecordNumberTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": medicalRecordNumberTextField]))
        medicalRecordNumberTextField.delegate = self
    }
    @objc func saveInfo() {
        guard let patientInfo = medicalRecordNumberTextField.text else {return}
        addPatientViewController?.saveMRN(patientInfo)
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class TelephoneNumberCell: BaseTableViewCell{
    var addPatientViewController: AddPatientViewController?
    let telephoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Telephone Number"
        textField.keyboardType = .numberPad 
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupViews() {
        addSubview(telephoneNumberTextField)
        telephoneNumberTextField.addTarget(self, action: #selector(saveInfo), for: .editingDidEnd)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": telephoneNumberTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": telephoneNumberTextField]))
        telephoneNumberTextField.delegate = self
    }
    @objc func saveInfo() {
        guard let patientInfo = telephoneNumberTextField.text else {return}
        addPatientViewController?.saveTelephoneNumber(patientInfo)
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class AgeCell: BaseTableViewCell{
    var addPatientViewController: AddPatientViewController?
    let ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Age"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupViews() {
        addSubview(ageTextField)
        ageTextField.addTarget(self, action: #selector(saveInfo), for: .editingDidEnd)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": ageTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": ageTextField]))
        ageTextField.delegate = self
    }
    
    @objc func saveInfo() {
        guard let patientInfo = ageTextField.text else {return}
        addPatientViewController?.saveAge(patientInfo)
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class ParityCell: BaseTableViewCell{
    var addPatientViewController: AddPatientViewController?
    let parityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Parity"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupViews() {
        addSubview(parityTextField)
        parityTextField.addTarget(self, action: #selector(saveInfo), for: .editingDidEnd)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": parityTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": parityTextField]))
        parityTextField.delegate = self
        
    }
    @objc func saveInfo() {
        guard let patientInfo = parityTextField.text else {return}
        addPatientViewController?.saveParity(patientInfo)
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class GestationalAgeCell: BaseTableViewCell{
    var addPatientViewController: AddPatientViewController?
    let gestationalAgeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Gestational Age"
        textField.keyboardType = .numberPad 
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func setupViews() {
        addSubview(gestationalAgeTextField)
        gestationalAgeTextField.addTarget(self, action: #selector(saveInfo), for: .editingDidEnd)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gestationalAgeTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gestationalAgeTextField]))
        gestationalAgeTextField.delegate = self
        
    }
    @objc func saveInfo() {
        guard let patientInfo = gestationalAgeTextField.text else {return}
        addPatientViewController?.saveGestationalAge(patientInfo)
    }
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
class HistoryOfPresentIllnessCell: BaseTableViewCell, UITextViewDelegate{
    var addPatientViewController: AddPatientViewController?
    let historyOfPresentIllnessTextView: UITextView = {
        let textView = UITextView()
        textView.text = "History of Present Illness"
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func setupViews() {
        historyOfPresentIllnessTextView.delegate = self 
        addSubview(historyOfPresentIllnessTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: historyOfPresentIllnessTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: historyOfPresentIllnessTextView)

    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        historyOfPresentIllnessTextView.text = ""
        historyOfPresentIllnessTextView.textColor = .black
        
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        guard let patientInfo = historyOfPresentIllnessTextView.text else {return}
        addPatientViewController?.saveHPI(patientInfo)
    }
}

class BaseTableViewCell: UITableViewCell, UITextFieldDelegate{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



