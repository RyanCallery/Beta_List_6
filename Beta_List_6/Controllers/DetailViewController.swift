//
//  DetailViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/17/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit
import CoreData

let betaID = "betaID"
let sonoID = "sonoID "
let betaHeaderID = "betaHeaderID"



class DetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    
    var managedContext: NSManagedObjectContext! = nil
    var patient: Patient? = nil {didSet {
        print("this is \(patient?.hcg) and \(patient?.ultrasound) ")
        
        }
    }
    
    
    let betaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .black
        collection.isPagingEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    
    let sonoCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .green
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var firstNameLabel: UILabel = {
       let label = UILabel()
        label.text = "First Name"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let lastNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Last Name"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let mrnLabel: UILabel = {
       let label = UILabel()
        label.text = "Mrn"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let telephoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let parityLabel: UILabel = {
        let label = UILabel()
        label.text = "P"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let gALabel: UILabel = {
        let label = UILabel()
        label.text = "GA"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hpiTextview: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.text = "HPI"
        return textView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = patient?.firstName != nil ? patient?.firstName : ""
        lastNameLabel.text = patient?.lastName != nil ? patient?.lastName : ""
        mrnLabel.text = patient?.medicalRecordNumber != nil ? patient?.medicalRecordNumber : ""
        telephoneNumberLabel.text = patient?.telephoneNumber != nil ? patient?.telephoneNumber : ""
        ageLabel.text = patient?.age != nil ? "\(patient?.age ?? "") yo" : ""
        parityLabel.text = patient?.parity != nil ? "P\(patient?.parity ?? "")" : ""
        gALabel.text = patient?.gestationalAge != nil ? patient?.gestationalAge : ""
        hpiTextview.text = patient?.historyOfPresentIllness != nil ? patient?.historyOfPresentIllness : ""
        
        view.backgroundColor = .white
        
        betaCollectionView.delegate = self
        betaCollectionView.dataSource = self
        sonoCollectionView.delegate = self
        sonoCollectionView.dataSource = self
        
        setupNavigationBarItems()
       
        betaCollectionView.register(BetaCollectionViewCell.self, forCellWithReuseIdentifier: betaID)
        sonoCollectionView.register(SonoCollectionViewCell.self, forCellWithReuseIdentifier: sonoID)
        
        setupStack()
    }
    
    private func setupNavigationBarItems(){
        
        
        
        let ultrasoundButton = UIButton(type: .roundedRect)
        ultrasoundButton.imageView?.contentMode = .scaleAspectFit
       ultrasoundButton.setImage(#imageLiteral(resourceName: "UltrasoundBlack") .withRenderingMode(.alwaysOriginal),for: .normal)
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
        let nameStack = UIStackView(arrangedSubviews: [firstNameLabel, lastNameLabel])
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        nameStack.axis = .horizontal
        nameStack.distribution = .fillEqually
        
        let phoneAndMrnNumberStack = UIStackView(arrangedSubviews: [mrnLabel, telephoneNumberLabel])
        phoneAndMrnNumberStack.translatesAutoresizingMaskIntoConstraints = false
        phoneAndMrnNumberStack.axis = .horizontal
        phoneAndMrnNumberStack.distribution = .fillEqually
        
        let ageParityGaStack = UIStackView(arrangedSubviews: [ageLabel, parityLabel, gALabel])
        ageParityGaStack.translatesAutoresizingMaskIntoConstraints = false
        ageParityGaStack.axis = .horizontal
        ageParityGaStack.distribution = .fillEqually
        
        let hpiStack = UIStackView(arrangedSubviews: [hpiTextview])
        hpiStack.translatesAutoresizingMaskIntoConstraints = false
        hpiStack.distribution = .fillEqually
        hpiStack.axis = .horizontal
        
        let patientInformationStack = UIStackView(arrangedSubviews: [nameStack, phoneAndMrnNumberStack,  ageParityGaStack, hpiStack])
        patientInformationStack.translatesAutoresizingMaskIntoConstraints = false
        patientInformationStack.axis = .vertical
        patientInformationStack.distribution = .fillEqually
        
        let betaTrendButton: UIButton = {
           let button = UIButton(frame: .zero)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("β", for: .normal)
            button.backgroundColor = .red
            button.layer.cornerRadius = 15
            button.layer.masksToBounds = true 
            return button
        }()
        
        let betaTrendButtonView = UIView()
        betaTrendButtonView.translatesAutoresizingMaskIntoConstraints = false
        betaTrendButtonView.backgroundColor = .cyan
        betaTrendButtonView.addSubview(betaTrendButton)
        betaTrendButton.centerXAnchor.constraint(equalTo: betaTrendButtonView.centerXAnchor).isActive = true
        betaTrendButton.centerYAnchor.constraint(equalTo: betaTrendButtonView.centerYAnchor).isActive = true
        betaTrendButton.widthAnchor.constraint(equalToConstant: 30)
        betaTrendButton.heightAnchor.constraint(equalToConstant: 30)
        
        let betaStackView = UIStackView(arrangedSubviews: [betaTrendButtonView, betaCollectionView])
        betaStackView.translatesAutoresizingMaskIntoConstraints = false
        betaStackView.axis = .horizontal
        betaStackView.addConstraintsWithFormat(format: "H:|[v0(40)]-[v1]|", views: betaTrendButtonView, betaCollectionView)
        
        
        
        let collectionViewStack = UIStackView(arrangedSubviews: [betaStackView, sonoCollectionView])
        collectionViewStack.arrangedSubviews[0].heightAnchor.constraint(equalTo: collectionViewStack.heightAnchor, multiplier: 0.33).isActive = true
        collectionViewStack.translatesAutoresizingMaskIntoConstraints = false
        collectionViewStack.axis = .vertical
        collectionViewStack.spacing = 8
        
        let mainStack = UIStackView(arrangedSubviews: [patientInformationStack, collectionViewStack])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.spacing = 8
        mainStack.axis = .vertical
        mainStack.arrangedSubviews[1].heightAnchor.constraint(equalTo: mainStack.arrangedSubviews[0].heightAnchor, multiplier: 2).isActive = true
        
        view.addSubview(mainStack)
        let safeAreaGuide = view.safeAreaLayoutGuide
        mainStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainStack.topAnchor.constraintEqualToSystemSpacingBelow(safeAreaGuide.topAnchor, multiplier: 1).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == betaCollectionView{
        return CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func setupViews() {
        super.setupViews()
        backgroundColor = .red
        
        let betaView = UIView()
        betaView.translatesAutoresizingMaskIntoConstraints = false
        betaView.backgroundColor = .green
        betaView.addSubview(betaLabel)
        betaView.addConstraintsWithFormat(format: "V:|[v0]|", views: betaLabel)
        betaView.addConstraintsWithFormat(format: "H:|[v0]|", views: betaLabel)
        
        let dateView = UIView()
        dateView.translatesAutoresizingMaskIntoConstraints = false
        dateView.backgroundColor = .purple
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
        backgroundColor = .orange
        
        
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


