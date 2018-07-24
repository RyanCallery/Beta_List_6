//
//  DetailViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/17/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


let betaID = "betaID"
let sonoID = "sonoID "
let betaHeaderID = "betaHeaderID"



class DetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    
    var managedContext: NSManagedObjectContext! = nil
    var patient: Patient? = nil
    
    
    
    let betaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .lightGray
        collection.isPagingEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    
    let sonoCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .lightGray
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var firstNameLabel: UILabel = {
       let label = UILabel()
        label.text = "First Name"
        label.backgroundColor = .white
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let lastNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Last Name"
        label.backgroundColor = .white
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let mrnLabel: UILabel = {
       let label = UILabel()
        label.text = "Mrn"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let telephoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.font = label.font.withSize(30)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let parityLabel: UILabel = {
        let label = UILabel()
        label.text = "P"
        label.font = label.font.withSize(30)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gALabel: UILabel = {
        let label = UILabel()
        label.text = "GA"
        label.backgroundColor = .white
        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followUpButton: UIButton = {
       let button = UIButton(frame: .zero)
        button.setTitle("Follow Up", for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button 
    }()
    
    let patientInformationView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let betaTrendButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("β", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(segueToBetaTrendVC), for: .touchUpInside)
        return button
    }()
    
    let lineSeparatorOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    let lineSeparatorTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    let lineSeparatorThree: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let lineSeparatorFour: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    let lineSeparatorFive: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = patient?.firstName != nil ? patient?.firstName : ""
        lastNameLabel.text = patient?.lastName != nil ? patient?.lastName : ""
        mrnLabel.text = patient?.medicalRecordNumber != nil ? "MRN: \(patient?.medicalRecordNumber ?? "")" : ""
        telephoneNumberLabel.text = patient?.telephoneNumber != nil ? "Cell: \(patient?.telephoneNumber ?? "")" : ""
        ageLabel.text = patient?.age != nil ? "\(patient?.age ?? "") yo" : ""
        parityLabel.text = patient?.parity != nil ? "P\(patient?.parity ?? "")" : ""
        gALabel.text = patient?.gestationalAge != nil ? "\(patient?.gestationalAge ?? "") weeks" : ""
        
        view.backgroundColor = .white
        
        betaCollectionView.delegate = self
        betaCollectionView.dataSource = self
        sonoCollectionView.delegate = self
        sonoCollectionView.dataSource = self
        
        setupNavigationBarItems()
       
        betaCollectionView.register(BetaCollectionViewCell.self, forCellWithReuseIdentifier: betaID)
        sonoCollectionView.register(SonoCollectionViewCell.self, forCellWithReuseIdentifier: sonoID)
        followUpButton.addTarget(self, action: #selector(segueToFollowUpView), for: .touchUpInside)
        setupStack()
    }
    
    @objc func segueToFollowUpView(){
        let controller = NotificationViewController()
        controller.managedContext = self.managedContext
        controller.patient = self.patient!
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func setupNavigationBarItems(){
        
        
        
        let ultrasoundButton = UIButton(type: .system)
        ultrasoundButton.imageView?.contentMode = .scaleAspectFit
        ultrasoundButton.setImage(#imageLiteral(resourceName: "UltrasoundBlack") .withRenderingMode(.alwaysOriginal),for: .normal)
        ultrasoundButton.setTitle("+", for: .normal)
        ultrasoundButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        ultrasoundButton.addTarget(self, action: #selector(addUltrasound), for: .touchUpInside)
        
        let addHcgButton = UIButton(type: .system)
        addHcgButton.setTitle("Add β", for: .normal)
        addHcgButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        addHcgButton.addTarget(self, action: #selector(addBeta), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addHcgButton), UIBarButtonItem(customView: ultrasoundButton)]
    }
    
    @objc func addBeta() {
        print("beta hcg added")
        let alert = UIAlertController(title: "Add New Beta", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "HCG"
        })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action) in
            print("Saved beta")
            
            if let hcgText = alert.textFields?.first?.text {
                let date = Date()
                let hcg = Hcg(context: self.managedContext)
                hcg.hcgLevel = hcgText
                hcg.date = date as NSDate
                hcg.methotrexate = false
                self.patient?.addToHcg(hcg)
                do {
                    try self.managedContext.save()
                    self.betaCollectionView.reloadData()
                    
                } catch {
                    fatalError("Unable to save HCG value")
                }
                
            } else {
                return
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            print("Cancel beta")
        })
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    @objc func addUltrasound(){
        let alert = UIAlertController(title: "Add Ultrasound", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Uterus"
        })
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Left Ovary"
        })
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Right Ovary"
        })
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Free fluid"
        })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action) in
            print("Saved ultrasound")
            let ultrasound = Ultrasound(context: self.managedContext)
            let date = Date()
            if let uterusText = alert.textFields?.first?.text {
                ultrasound.uterus = uterusText
                ultrasound.date = date as NSDate
            }
            if let leftOvaryText = alert.textFields![1].text {
                ultrasound.leftOvary = leftOvaryText
                ultrasound.date = date as NSDate
            }
            if let rightOvaryText = alert.textFields![2].text {
            ultrasound.rightOvary = rightOvaryText
                ultrasound.date = date as NSDate
            }
            if let fluidText = alert.textFields![3].text {
            ultrasound.fluid = fluidText
                ultrasound.date = date as NSDate
            }
            do {
                self.patient?.addToUltrasound(ultrasound)
                try self.managedContext.save()
                self.sonoCollectionView.reloadData()
                
            }
            catch {
            fatalError("Unable to save ultrasound value")
            }
                
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            print("Cancel sono")
        })
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func setupStack() {
        
        patientInformationView.addSubview(firstNameLabel)
        patientInformationView.addSubview(lastNameLabel)
        patientInformationView.addSubview(followUpButton)
        patientInformationView.addSubview(mrnLabel)
        patientInformationView.addSubview(telephoneNumberLabel)
        patientInformationView.addSubview(ageLabel)
        patientInformationView.addSubview(parityLabel)
        patientInformationView.addSubview(gALabel)
        patientInformationView.addSubview(lineSeparatorOne)
        patientInformationView.addSubview(lineSeparatorTwo)
        patientInformationView.addSubview(lineSeparatorThree)
        
        // set x, y, width, height  for each object in patientInformationView
        
        firstNameLabel.topAnchor.constraint(equalTo: patientInformationView.topAnchor).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: patientInformationView.leftAnchor, constant: 10).isActive = true
        firstNameLabel.bottomAnchor.constraint(equalTo: mrnLabel.topAnchor).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        firstNameLabel.rightAnchor.constraint(equalTo: lastNameLabel.leftAnchor, constant: -10).isActive = true
        
        lastNameLabel.topAnchor.constraint(equalTo: patientInformationView.topAnchor).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: firstNameLabel.rightAnchor).isActive = true
        lastNameLabel.bottomAnchor.constraint(equalTo: mrnLabel.topAnchor).isActive = true

        
        followUpButton.topAnchor.constraint(equalTo: patientInformationView.topAnchor).isActive = true
        followUpButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        followUpButton.rightAnchor.constraint(equalTo: patientInformationView.rightAnchor).isActive = true
        followUpButton.bottomAnchor.constraint(equalTo: mrnLabel.topAnchor).isActive = true
        
        mrnLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        mrnLabel.leftAnchor.constraint(equalTo: patientInformationView.leftAnchor, constant: 20).isActive = true
        mrnLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        mrnLabel.rightAnchor.constraint(equalTo: telephoneNumberLabel.leftAnchor, constant: -20).isActive = true

        
        telephoneNumberLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        telephoneNumberLabel.leftAnchor.constraint(equalTo: mrnLabel.rightAnchor).isActive = true
        telephoneNumberLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true

        lineSeparatorOne.topAnchor.constraint(equalTo: mrnLabel.bottomAnchor).isActive = true
        lineSeparatorOne.widthAnchor.constraint(equalTo: patientInformationView.widthAnchor).isActive = true
        lineSeparatorOne.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        lineSeparatorTwo.bottomAnchor.constraint(equalTo: ageLabel.topAnchor).isActive = true
        lineSeparatorTwo.widthAnchor.constraint(equalTo: patientInformationView.widthAnchor).isActive = true
        lineSeparatorTwo.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
       ageLabel.leftAnchor.constraint(equalTo: patientInformationView.leftAnchor, constant: 10).isActive = true
        ageLabel.bottomAnchor.constraint(equalTo: patientInformationView.bottomAnchor).isActive = true
        ageLabel.rightAnchor.constraint(equalTo: parityLabel.leftAnchor, constant: -20).isActive = true
        ageLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        parityLabel.leftAnchor.constraint(equalTo: ageLabel.rightAnchor).isActive = true
        parityLabel.bottomAnchor.constraint(equalTo: patientInformationView.bottomAnchor).isActive = true
        parityLabel.rightAnchor.constraint(equalTo: gALabel.leftAnchor, constant: -20).isActive = true
        parityLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        gALabel.bottomAnchor.constraint(equalTo: patientInformationView.bottomAnchor).isActive = true
        gALabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        lineSeparatorThree.bottomAnchor.constraint(equalTo: patientInformationView.bottomAnchor).isActive = true
        lineSeparatorThree.widthAnchor.constraint(equalTo: patientInformationView.widthAnchor).isActive = true
        lineSeparatorThree.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        let betaTrendButtonView = UIView()
        betaTrendButtonView.translatesAutoresizingMaskIntoConstraints = false
        betaTrendButtonView.backgroundColor = .lightGray
//        betaTrendButtonView.layer.borderColor = UIColor.black.cgColor
//        betaTrendButtonView.layer.borderWidth = 1
        betaTrendButtonView.addSubview(betaTrendButton)
        betaTrendButton.centerXAnchor.constraint(equalTo: betaTrendButtonView.centerXAnchor).isActive = true
        betaTrendButton.centerYAnchor.constraint(equalTo: betaTrendButtonView.centerYAnchor).isActive = true
        betaTrendButton.widthAnchor.constraint(equalToConstant: 30)
        betaTrendButton.heightAnchor.constraint(equalToConstant: 30)
        
        let betaStackView = UIStackView(arrangedSubviews: [betaTrendButtonView, betaCollectionView])
        betaStackView.translatesAutoresizingMaskIntoConstraints = false
        betaStackView.axis = .horizontal
        betaStackView.addConstraintsWithFormat(format: "H:|[v0(40)]-[v1]|", views: betaTrendButtonView, betaCollectionView)
        
        let collectionViewStack = UIStackView(arrangedSubviews: [lineSeparatorFour,betaStackView,lineSeparatorFive, sonoCollectionView])
        lineSeparatorFour.topAnchor.constraint(equalTo: collectionViewStack.topAnchor).isActive = true
        lineSeparatorFour.widthAnchor.constraint(equalTo: collectionViewStack.widthAnchor).isActive = true
        lineSeparatorFour.heightAnchor.constraint(equalToConstant: 0.5)
        lineSeparatorFive.topAnchor.constraint(equalTo: betaStackView.bottomAnchor).isActive = true
        lineSeparatorFive.widthAnchor.constraint(equalTo: collectionViewStack.widthAnchor).isActive = true
        lineSeparatorFive.heightAnchor.constraint(equalToConstant: 1).isActive = true
        collectionViewStack.arrangedSubviews[1].heightAnchor.constraint(equalTo: collectionViewStack.heightAnchor, multiplier: 1/3).isActive = true
        collectionViewStack.translatesAutoresizingMaskIntoConstraints = false
        collectionViewStack.axis = .vertical
        collectionViewStack.spacing = 0
        
        let mainStack = UIStackView(arrangedSubviews: [patientInformationView, collectionViewStack])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.spacing = 0
        mainStack.axis = .vertical
        mainStack.arrangedSubviews[1].heightAnchor.constraint(equalTo: mainStack.arrangedSubviews[0].heightAnchor, multiplier: 2).isActive = true
        
        view.addSubview(mainStack)
        let safeAreaGuide = view.safeAreaLayoutGuide
        mainStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainStack.topAnchor.constraintEqualToSystemSpacingBelow(safeAreaGuide.topAnchor, multiplier: 1).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
    }
    
    @objc func segueToBetaTrendVC() {
        let layout = UICollectionViewFlowLayout()
        let controller = BetaTrendViewController(collectionViewLayout: layout)
        controller.patient = self.patient 
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == betaCollectionView{
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return inset
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.betaCollectionView {
            return (patient?.hcg!.count)!
        } else {
            return (patient?.ultrasound!.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == betaCollectionView {
        let betaCell = collectionView.dequeueReusableCell(withReuseIdentifier: betaID, for: indexPath) as! BetaCollectionViewCell
            let betaObject = patient?.hcg?.object(at: indexPath.item) as! Hcg
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateFormat = "M.d"
            timeFormatter.dateFormat = "h:mm a"
            betaCell.betaLabel.text = betaObject.hcgLevel
            betaCell.dateLabel.text = dateFormatter.string(from: betaObject.date! as Date)
            betaCell.timeLabel.text = timeFormatter.string(from: betaObject.date! as Date)
            if betaObject.methotrexate == true {
                betaCell.betaLabel.backgroundColor = .yellow
            }

            return betaCell
        } else {
            let sonoCell = collectionView.dequeueReusableCell(withReuseIdentifier: sonoID, for: indexPath) as! SonoCollectionViewCell
            let sonoObject = patient?.ultrasound?.object(at: indexPath.item) as! Ultrasound
            let formatter = DateFormatter()
            formatter.dateFormat = "M.d.yy h:mm a"
            sonoCell.dateLabel.text = formatter.string(from: sonoObject.date! as Date)
            sonoCell.uterusTextView.text = sonoObject.uterus
            sonoCell.leftOvaryTextView.text = sonoObject.leftOvary
            sonoCell.rightOvaryTextView.text = sonoObject.rightOvary
            sonoCell.fluidTextView.text = sonoObject.fluid
            return sonoCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == betaCollectionView {
            let betaObject = patient?.hcg?.object(at: indexPath.item) as! Hcg
            betaObject.methotrexate = true
            patient?.replaceHcg(at: indexPath.item, with: betaObject)
            do {
                try self.managedContext.save()
            }catch {
                fatalError("Unable to save updated mtx input")
            }
            betaCollectionView.reloadData()
        }
    }
    
class BetaCollectionViewCell: BaseCollectionViewCell {
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.text = "Date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
       let label = UILabel()
        label.text = "Time"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let betaLabel: UILabel = {
       let label = UILabel()
        label.text = "beta"
        label.font = label.font.withSize(35)
        label.layer.cornerRadius = 30
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.black.cgColor
        label.backgroundColor = #colorLiteral(red: 0.09107228369, green: 0.6968451142, blue: 0.113052167, alpha: 1)
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func setupViews() {
        super.setupViews()
        backgroundColor = .red
        
        let betaView = UIView()
        betaView.translatesAutoresizingMaskIntoConstraints = false
        betaView.backgroundColor = .lightGray
        betaView.addSubview(betaLabel)
        betaView.addConstraintsWithFormat(format: "V:|[v0]|", views: betaLabel)
        betaView.addConstraintsWithFormat(format: "H:|[v0]|", views: betaLabel)
        
        let dateView = UIView()
        dateView.translatesAutoresizingMaskIntoConstraints = false
        dateView.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        dateView.addSubview(dateLabel)
        dateView.addSubview(timeLabel)
        dateLabel.topAnchor.constraint(equalTo: dateView.topAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: dateView.widthAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: dateView.bottomAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: dateView.widthAnchor).isActive = true
        
        
        
        addSubview(dateView)
        addSubview(betaView)
        dateView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        dateView.bottomAnchor.constraint(equalTo: betaView.topAnchor).isActive = true
        dateView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33).isActive = true
        betaView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        betaView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        

    }
    
    
    
}

class SonoCollectionViewCell: BaseCollectionViewCell, UITextViewDelegate {
//    var date = Date()
//    let formatter = DateFormatter()
    
    let ultrasoundFindingsLabel: UILabel = {
       let label = UILabel()
        label.text = "Ultrasound Findings"
        label.font = label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let uterusLabel: UILabel = {
       let label = UILabel()
        label.text = "Uterus"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let leftOvaryLabel: UILabel = {
       let label = UILabel()
        label.text = "LOV"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let rightOvaryLabel: UILabel = {
       let label = UILabel()
        label.text = "ROV"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let freeFluidLabel: UILabel = {
       let label = UILabel()
        label.text = "Fluid"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uterusTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    let leftOvaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    let rightOvaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    let fluidTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    
    let lineSeparatory: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        
        
        setupStacks()
        
    }
    
    func setupStacks(){
        let ultrasoundHeadView = UIView()
        ultrasoundHeadView.translatesAutoresizingMaskIntoConstraints = false
        ultrasoundHeadView.addSubview(ultrasoundFindingsLabel)
        ultrasoundHeadView.addSubview(dateLabel)
        ultrasoundHeadView.addSubview(lineSeparatory)
        ultrasoundHeadView.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2(1)]|", views: ultrasoundFindingsLabel, dateLabel, lineSeparatory)
        ultrasoundHeadView.addConstraintsWithFormat(format: "H:|[v0]|", views: ultrasoundFindingsLabel)
        ultrasoundHeadView.addConstraintsWithFormat(format: "H:|[v0]|", views: dateLabel)
        ultrasoundHeadView.addConstraintsWithFormat(format: "H:|[v0]|", views: lineSeparatory)
        
        let uterusStack = UIStackView(arrangedSubviews: [uterusLabel, uterusTextView])
        uterusStack.axis = .horizontal
        uterusStack.translatesAutoresizingMaskIntoConstraints = false
        uterusStack.addConstraintsWithFormat(format: "H:|[v0(60)]-[v1]|", views: uterusLabel, uterusTextView)
        
        let leftOvaryStack = UIStackView(arrangedSubviews: [leftOvaryLabel, leftOvaryTextView])
        leftOvaryStack.axis = .horizontal
        leftOvaryStack.translatesAutoresizingMaskIntoConstraints = false
        leftOvaryStack.addConstraintsWithFormat(format: "H:|[v0(60)]-[v1]|", views: leftOvaryLabel, leftOvaryTextView)
        
        let rightOvaryStack = UIStackView(arrangedSubviews: [rightOvaryLabel, rightOvaryTextView])
        rightOvaryStack.axis = .horizontal
        rightOvaryStack.translatesAutoresizingMaskIntoConstraints = false
        rightOvaryStack.addConstraintsWithFormat(format: "H:|[v0(60)]-[v1]|", views: rightOvaryLabel, rightOvaryTextView)
        
        let fluidStack = UIStackView(arrangedSubviews: [freeFluidLabel, fluidTextView])
        fluidStack.axis = .horizontal
        fluidStack.translatesAutoresizingMaskIntoConstraints = false
        fluidStack.addConstraintsWithFormat(format: "H:|[v0(60)]-[v1]|", views: freeFluidLabel, fluidTextView)
        
        let mainStack = UIStackView(arrangedSubviews: [uterusStack, leftOvaryStack, rightOvaryStack, fluidStack])
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 6
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(ultrasoundHeadView)
        addSubview(mainStack)
        addConstraintsWithFormat(format: "H:|[v0]|", views: ultrasoundHeadView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainStack)
        addConstraintsWithFormat(format: "V:|[v0]-6-[v1]-4-|", views: ultrasoundHeadView, mainStack)
        
    }
    
}

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
    }
}


}


