//
//  ViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/16/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit
import CoreData 
import UserNotifications

class ListTableViewCellController: UITableViewController {
    
    var patientList: [Patient] = []
    var patient: Patient? {didSet {
        patientList.append(patient!)
        tableView.reloadData() 
        }
    }

    
    let listCell = "ListCell"
    let headerReuseID = "headerID"
    var managedContext: NSManagedObjectContext!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = DatabaseController.context
        tableView.backgroundColor = .blue
        navigationItem.title = "Your Beta List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .blue
        let attributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: listCell)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: headerReuseID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPatient))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        let fetchRequest: NSFetchRequest<Patient> = Patient.fetchRequest()
        do {
            patientList = try managedContext.fetch(fetchRequest)
        } catch {
            fatalError("Unable to perform patient list fetch request")
        }
    }
    
    @objc func addPatient() {
        let controller = AddPatientViewController()
        controller.managedContext = managedContext 
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let patientListCell = tableView.dequeueReusableCell(withIdentifier: listCell, for: indexPath) as!  ListTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd yy"
        patientListCell.firstNameLabel.text = patientList[indexPath.row].firstName
        patientListCell.lastNameLabel.text = patientList[indexPath.row].lastName 
        patientListCell.ageLabel.text = "\(patientList[indexPath.row].age!) y.o."
        patientListCell.parityLabel.text = "P\(patientList[indexPath.row].parity!)"
        patientListCell.gestationalAgeLabel.text = "\(patientList[indexPath.row].gestationalAge!) weeks"
        patientListCell.hpiTextView.text = patientList[indexPath.row].historyOfPresentIllness
        patientListCell.listTableViewController = self
        if patientList[indexPath.row].followUpDate != nil {
        patientListCell.followUpDateLabel.text = formatter.string(from: patientList[indexPath.row].followUpDate! as Date)
        }
        patientListCell.followUpTextView.text = patientList[indexPath.row].followUpPlan
        return patientListCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseID) as! Header
        tableView.sectionHeaderHeight = 20
        header.totalPatientsLabel.text = "Total Patients: \(patientList.count)"
        return header
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let deletedPatient = self.patientList[indexPath.row]
           self.patientList.remove(at: indexPath.row)
            self.managedContext.delete(deletedPatient)
            do {
            try self.managedContext.save()
            } catch {
                fatalError("Unable to delete this patient from CoreData")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let detailViewController = DetailViewController()
        detailViewController.managedContext = self.managedContext
        detailViewController.patient = patientList[indexPath.row]
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    

}
    


class Header: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        let header: UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let totalPatientsLabel: UILabel = {
       let label = UILabel()
        label.text = "Total number of patients"
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupView() {
        addSubview(header)
        header.addSubview(totalPatientsLabel)
        header.addConstraintsWithFormat(format: "H:|[v0]|", views: totalPatientsLabel)
        header.addConstraintsWithFormat(format: "V:|[v0]|", views: totalPatientsLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : header]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": header]))
    }
}

class ListTableViewCell: UITableViewCell {
    
    var listTableViewController: ListTableViewCellController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let firstNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Jane"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.backgroundColor = .white
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Smith"
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "23 yo"
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.vertical)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let parityLabel: UILabel = {
        let label = UILabel()
        label.text = "P1001"
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
        label.font = UIFont.systemFont(ofSize: 20)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gestationalAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "9 wga"
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorLine: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let separatorLineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImage: UIImageView = {
       let imageView = UIImageView()
        let pictureArray = [#imageLiteral(resourceName: "Tiana"), #imageLiteral(resourceName: "Elsa"), #imageLiteral(resourceName: "Cinderella"), #imageLiteral(resourceName: "Jasmine"), #imageLiteral(resourceName: "Snowwhite"), #imageLiteral(resourceName: "Aurora"), #imageLiteral(resourceName: "Pocahontas"), #imageLiteral(resourceName: "Mulan"), #imageLiteral(resourceName: "Belle"), #imageLiteral(resourceName: "Merida")]
        imageView.image = pictureArray[Int(arc4random_uniform(UInt32(pictureArray.count - 1)))]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let hpiTextView: UITextView = {
       let textView = UITextView()
        textView.text = "This patient presented to the ER with bleeding"
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let followUpDateLabel: UILabel = {
       let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.font = label.font.withSize(12)
        return label
    }()
    
    let followUpTextView: UITextView = {
       let textView = UITextView()
        textView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: UILayoutConstraintAxis.horizontal)
        textView.text = "Follow up plan"
        textView.isEditable = false
        textView.backgroundColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let arrowLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "→"
        label.backgroundColor = .lightGray
        return label
    }()
    
    func setupViews() {
        addSubview(profileImage)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        addSubview(ageLabel)
        addSubview(parityLabel)
        addSubview(gestationalAgeLabel)
        addSubview(separatorLine)
        addSubview(hpiTextView)
        addSubview(separatorLineTwo)
        addSubview(followUpDateLabel)
        addSubview(followUpTextView)
        addSubview(arrowLabel)
        
        

        profileImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        profileImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: firstNameLabel.rightAnchor).isActive = true
        lastNameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lastNameLabel.bottomAnchor.constraint(equalTo: gestationalAgeLabel.topAnchor).isActive = true
        ageLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        ageLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        parityLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        parityLabel.leftAnchor.constraint(equalTo: ageLabel.rightAnchor, constant: 8).isActive = true
        parityLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor).isActive = true
        parityLabel.rightAnchor.constraint(equalTo: gestationalAgeLabel.leftAnchor, constant: -8).isActive = true
        gestationalAgeLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        gestationalAgeLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        gestationalAgeLabel.leftAnchor.constraint(equalTo: parityLabel.rightAnchor).isActive = true
        gestationalAgeLabel.bottomAnchor.constraint(equalTo: separatorLine.topAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: ageLabel.bottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        hpiTextView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor).isActive = true
        hpiTextView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        hpiTextView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        hpiTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        separatorLineTwo.topAnchor.constraint(equalTo: hpiTextView.bottomAnchor).isActive = true
        separatorLineTwo.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLineTwo.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        followUpTextView.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor).isActive = true
        followUpTextView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        followUpTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        followUpTextView.rightAnchor.constraint(equalTo: arrowLabel.leftAnchor).isActive = true
        followUpTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true 
        arrowLabel.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor).isActive = true
        arrowLabel.leftAnchor.constraint(equalTo: followUpTextView.rightAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        followUpDateLabel.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor).isActive = true
        followUpDateLabel.leftAnchor.constraint(equalTo: arrowLabel.rightAnchor).isActive = true
        followUpDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        followUpDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        
        
        
//        followUpDateLabel.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor).isActive = true
//        followUpDateLabel.leftAnchor.constraint(equalTo: followUpTextView.rightAnchor).isActive = true
//        followUpDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
//        followUpTextView.topAnchor.constraint(equalTo: separatorLineTwo.bottomAnchor).isActive = true
//        followUpTextView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        followUpTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
//        followUpTextView.rightAnchor.constraint(equalTo: followUpDateLabel.leftAnchor).isActive = true
//        followUpTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    

    
}


