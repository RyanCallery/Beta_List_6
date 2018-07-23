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
    let footerReuseID = "footerID"
    var managedContext: NSManagedObjectContext!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = DatabaseController.context
        tableView.backgroundColor = .blue
        navigationItem.title = "Your Beta List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .blue 
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: listCell)
        tableView.register(Footer.self, forHeaderFooterViewReuseIdentifier: footerReuseID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPatient))
        navigationItem.rightBarButtonItem?.tintColor = .white 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        patientListCell.ageLabel.text = patientList[indexPath.row].age
        patientListCell.parityLabel.text = patientList[indexPath.row].parity
        patientListCell.gestationalAgeLabel.text = patientList[indexPath.row].gestationalAge
        patientListCell.hpiTextView.text = patientList[indexPath.row].historyOfPresentIllness
        patientListCell.listTableViewController = self
        if patientList[indexPath.row].followUpDate != nil {
        patientListCell.followUpDateLabel.text = formatter.string(from: patientList[indexPath.row].followUpDate! as Date)
        }
        patientListCell.followUpTextView.text = patientList[indexPath.row].followUpPlan
        return patientListCell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerReuseID) as! Footer
        tableView.sectionFooterHeight = 50
        return footer
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
    


class Footer: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        let footerView: UIView = {
       let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func setupView() {
        addSubview(footerView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : footerView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": footerView]))
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Smith"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "23 yo"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let parityLabel: UILabel = {
        let label = UILabel()
        label.text = "P1001"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gestationalAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "9 wga"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let profileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "MeridithGray ")
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
        label.font = label.font.withSize(12)
        return label
    }()
    
    let followUpTextView: UITextView = {
       let textView = UITextView()
        textView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: UILayoutConstraintAxis.horizontal)
        textView.text = "Follow up plan"
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func setupViews() {
        addSubview(profileImage)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        addSubview(ageLabel)
        addSubview(parityLabel)
        addSubview(gestationalAgeLabel)
        addSubview(hpiTextView)
        
        let followUpStack = UIStackView(arrangedSubviews: [followUpDateLabel, followUpTextView])
        followUpStack.translatesAutoresizingMaskIntoConstraints = false
        followUpStack.axis = .horizontal
        
        addSubview(followUpStack)
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0(50)]-8-[v1]-8-[v2]", views: profileImage, firstNameLabel, lastNameLabel)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(50)]-8-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImage, "v1": firstNameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1]-8-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : ageLabel, "v1": parityLabel, "v3": gestationalAgeLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": hpiTextView]))
        addConstraintsWithFormat(format: "H:|[v0]|", views: followUpStack)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(50)]-[v1]-[v2(50)]-[v3(50)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImage, "v1" : ageLabel, "v2": hpiTextView, "v3": followUpStack]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(50)]-[v1]-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImage, "v1": parityLabel, "v2": hpiTextView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0(50)]-[v1]-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : profileImage, "v1": gestationalAgeLabel, "v2": hpiTextView]))
        
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(50)]-[v1]-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : nameLabel, "v1": ageLabel, "v2": hpiTextView]))
        
    }
    

    
}


