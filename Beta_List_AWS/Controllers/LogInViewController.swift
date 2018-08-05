//
//  LogInViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/24/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    
    let betaLabel: UILabel = {
    let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "β"
        label.font = label.font.withSize(200)
        label.textColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        return label
    }()
    
    let listLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(50)
        label.text = "List"
        label.textColor = .black
        return label
    }()
    
    let logInButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(segueToList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let betaListView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true 
    }
    
    func setupViews() {
        
        view.addSubview(betaListView)
        view.addSubview(logInButton)
        
        betaListView.addSubview(betaLabel)
        betaListView.addSubview(listLabel)
        
        betaListView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        betaListView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        betaListView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        betaListView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        betaLabel.topAnchor.constraint(equalTo: betaListView.topAnchor).isActive = true
        betaLabel.leftAnchor.constraint(equalTo: betaListView.leftAnchor).isActive = true
        betaLabel.bottomAnchor.constraint(equalTo: betaListView.bottomAnchor).isActive = true
        betaLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        listLabel.leftAnchor.constraint(equalTo: betaLabel.rightAnchor, constant: -16).isActive = true
        listLabel.bottomAnchor.constraint(equalTo: betaListView.bottomAnchor).isActive = true
        listLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        listLabel.rightAnchor.constraint(equalTo: betaListView.rightAnchor).isActive = true
        
        logInButton.topAnchor.constraint(equalTo: betaListView.bottomAnchor, constant: 50).isActive = true
        logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    @objc func segueToList() {
        let controller = ListTableViewCellController()
        navigationController?.pushViewController(controller, animated: true)
        
    }


   

}
