//
//  BetaTrendViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/17/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class BetaTrendViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var patient: Patient? = nil
    let cellID = "cellID"
    let headerID = "headerID"
    var hcgArray = [Hcg]()
    var betaLevelsOnlyArray = [String]()
    var datesOnlyArray = [Date]()
    lazy var betaIntervalChange = percentChangeOverTime(betaLevelsOnlyArray)
    lazy var dateInterval = [String]()
    let calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Beta Trend"
        let frame = self.view.frame
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .black
        collectionView?.register(BetaTrendCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        pullHcgObjectsFromCoreData()
        createHcgArrayForCalculations()
        createDateArrayForCalculation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateInterval = dateIntervalCalculation(datesOnlyArray)
    }
    
    func pullHcgObjectsFromCoreData(){
        if patient?.hcg?.count != 0 {
            for object in 0...(patient?.hcg?.count)! - 1 {
                hcgArray.append(patient!.hcg?.object(at: object) as! Hcg)
            }
            }
        }
    func createHcgArrayForCalculations(){
        if hcgArray.isEmpty == false {
            for betaValue in 0...hcgArray.count - 1 {
            betaLevelsOnlyArray.append(hcgArray[betaValue].hcgLevel!)
            }
            }
        }
    
    func createDateArrayForCalculation() {
        if hcgArray.isEmpty == false {
            for dateValue in 0...hcgArray.count - 1 {
                datesOnlyArray.append(hcgArray[dateValue].date! as Date)
            }
        }
    }
    func percentChangeOverTime(_ betaChange: [String]) -> [String]{
        
        var percentIncreaseStringArray = [""]
        
        if betaLevelsOnlyArray.count > 1 {
            // convert the array of strings into an array of doubles
            var percentIncreaseArray = [Double]()
            let doubleArray = betaLevelsOnlyArray.map{beta in Double(beta)!}
            for index in 0...doubleArray.count - 2 {
            // calcultate the percent change between interval beta levels
                print("Is the percent change function working")
                let increase = doubleArray[index + 1] - doubleArray[index]
                let percentIncrease = (increase / doubleArray[index]) * 100
                percentIncreaseArray.append(percentIncrease)
            }
            // truncate the interval change so it doesn't have any decimal places for the view
            let truncatedArray = percentIncreaseArray.map{beta in beta.truncate(places: 0, number: beta)}
            let truncatedArrayAsString = truncatedArray.map{beta in String(beta)}
            percentIncreaseStringArray.append(contentsOf: truncatedArrayAsString)
            
        } else if betaLevelsOnlyArray.count == 1 {
            percentIncreaseStringArray.append("")
        }
        return percentIncreaseStringArray
    }
    
    func dateIntervalCalculation(_ date: [Date]) -> [String] {
        var dateIntervalsCalculated = [""]
        
        if date.count > 1 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            for index in 0...date.count - 2 {
            let eachDateInterval = date[index + 1].hours(from: date[index])
                print("is the date interval calc func working")
                if eachDateInterval > 48 {
                    dateFormatter.dateFormat = "d"
                } else {
                    dateFormatter.dateFormat = "h"
                }
                let eachIntervalAsString = String(eachDateInterval)
                dateIntervalsCalculated.append(eachIntervalAsString)
            }
            
        } else {
            dateIntervalsCalculated.append("")
            
        }
        return dateIntervalsCalculated
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfHcgValuesForPatient = patient?.hcg?.count else{return 0}
        return numberOfHcgValuesForPatient
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BetaTrendCollectionViewCell
        let formatter = DateFormatter()
        let hourFormatter = DateFormatter()
        formatter.dateFormat = "M.d.yy"
        hourFormatter.dateFormat = "h:mm a"
        let betaObject = patient?.hcg?.object(at: indexPath.item) as! Hcg
        cell.betaLabel.text = betaObject.hcgLevel
        cell.dateLabel.text = formatter.string(from: betaObject.date! as Date)
        cell.timeLabel.text = hourFormatter.string(from: betaObject.date! as Date)
        if dateInterval[indexPath.item] != "" {
            cell.dateIntervalTextView.text = "\(dateInterval[indexPath.item]) since previous beta" }
        else {
            cell.dateIntervalTextView.text = ""
        }
        if betaIntervalChange[indexPath.item] != "" {
            cell.percentChangeLabel.text = "𝝙\(betaIntervalChange[indexPath.item])%"
        }
        
        if cell.dateIntervalTextView.text != "" {
            cell.dateIntervalTextView.backgroundColor = .lightGray
            cell.dateIntervalTextView.layer.borderColor = UIColor.black.cgColor
            cell.dateIntervalTextView.layer.borderWidth = 1
        } else {
            cell.dateIntervalTextView.backgroundColor = .white
        }
        
        if betaIntervalChange[indexPath.item] == "" {
            cell.percentChangeLabel.backgroundColor = .white
            cell.viewForThePercentChangeLabel.backgroundColor = .white
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    

}

class BetaTrendCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = label.font.withSize(20)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
       let label = UILabel()
        label.text = "Time"
        label.font = label.font.withSize(15)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateIntervalTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = textView.font?.withSize(15)
        textView.backgroundColor = .blue
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let betaLabel: UILabel = {
        let label = UILabel()
        label.text = "Beta"
        label.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        label.font = label.font.withSize(40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let percentChangeLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        label.font = label.font.withSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let betaView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let viewForDateAndTime: UIView = {
       let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let viewForBetaValue: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        return view
    }()
    
    let viewForTheDateIntervalLabel: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let arrowView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let arrowLabel: UILabel = {
       let label = UILabel()
        label.text = "͢"
        label.font = label.font.withSize(20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewForThePercentChangeLabel: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        return view
    }()
    
    func setupViews() {
        addSubview(dateView)
        addSubview(betaView)
        dateView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dateView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        dateView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        betaView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        betaView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        betaView.leftAnchor.constraint(equalTo: dateView.rightAnchor).isActive = true
        betaView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        dateView.addSubview(viewForDateAndTime)
        dateView.addSubview(viewForTheDateIntervalLabel)
        dateView.addSubview(arrowView)
        viewForTheDateIntervalLabel.addSubview(dateIntervalTextView)
        viewForDateAndTime.centerXAnchor.constraint(equalTo: dateView.centerXAnchor).isActive = true
        viewForDateAndTime.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 10).isActive = true
        viewForDateAndTime.widthAnchor.constraint(equalTo: dateView.widthAnchor, multiplier: 0.5).isActive = true
        viewForDateAndTime.heightAnchor.constraint(equalTo: dateView.heightAnchor, multiplier: 0.5).isActive = true
        arrowView.leftAnchor.constraint(equalTo: viewForDateAndTime.rightAnchor, constant: 5).isActive = true
        arrowView.rightAnchor.constraint(equalTo: dateView.rightAnchor, constant: 0).isActive = true
        arrowView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowView.centerYAnchor.constraint(equalTo: viewForDateAndTime.centerYAnchor).isActive = true
        viewForTheDateIntervalLabel.centerXAnchor.constraint(equalTo: dateView.centerXAnchor).isActive = true
        viewForTheDateIntervalLabel.topAnchor.constraint(equalTo: viewForDateAndTime.bottomAnchor, constant: 5).isActive = true
        viewForTheDateIntervalLabel.leftAnchor.constraint(equalTo: dateView.leftAnchor).isActive = true
        viewForTheDateIntervalLabel.rightAnchor.constraint(equalTo: dateView.rightAnchor).isActive = true
        viewForTheDateIntervalLabel.bottomAnchor.constraint(equalTo: dateView.bottomAnchor, constant: -2).isActive = true 
        dateIntervalTextView.centerXAnchor.constraint(equalTo: viewForTheDateIntervalLabel.centerXAnchor).isActive = true
        dateIntervalTextView.heightAnchor.constraint(equalTo: viewForTheDateIntervalLabel.heightAnchor).isActive = true
        dateIntervalTextView.widthAnchor.constraint(equalTo: viewForDateAndTime.widthAnchor).isActive = true
        dateIntervalTextView.topAnchor.constraint(equalTo: viewForTheDateIntervalLabel.topAnchor).isActive = true
        
        
        betaView.addSubview(viewForBetaValue)
        betaView.addSubview(viewForThePercentChangeLabel)
        viewForBetaValue.leftAnchor.constraint(equalTo: betaView.leftAnchor).isActive = true
        viewForBetaValue.topAnchor.constraint(equalTo: betaView.topAnchor, constant: 10).isActive = true
        viewForBetaValue.heightAnchor.constraint(equalToConstant: 80).isActive = true
        viewForBetaValue.widthAnchor.constraint(equalToConstant: 80).isActive = true
        viewForThePercentChangeLabel.leftAnchor.constraint(equalTo: viewForBetaValue.rightAnchor, constant: 10).isActive = true
        viewForThePercentChangeLabel.bottomAnchor.constraint(equalTo: viewForBetaValue.bottomAnchor).isActive = true
        viewForThePercentChangeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        viewForThePercentChangeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        viewForBetaValue.addSubview(betaLabel)
        viewForThePercentChangeLabel.addSubview(percentChangeLabel)
        betaLabel.centerXAnchor.constraint(equalTo: viewForBetaValue.centerXAnchor).isActive = true
        betaLabel.centerYAnchor.constraint(equalTo: viewForBetaValue.centerYAnchor).isActive = true
        percentChangeLabel.centerXAnchor.constraint(equalTo: viewForThePercentChangeLabel.centerXAnchor).isActive = true
        percentChangeLabel.centerYAnchor.constraint(equalTo: viewForThePercentChangeLabel.centerYAnchor).isActive = true
        
        
        
        
        
        viewForDateAndTime.addSubview(dateLabel)
        viewForDateAndTime.addSubview(timeLabel)
        dateLabel.topAnchor.constraint(equalTo: viewForDateAndTime.topAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: viewForDateAndTime.leftAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: viewForDateAndTime.widthAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalTo: viewForDateAndTime.heightAnchor, multiplier: 0.5).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: viewForDateAndTime.leftAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: viewForDateAndTime.bottomAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: dateLabel.widthAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: dateLabel.heightAnchor).isActive = true
        
        arrowView.addSubview(arrowLabel)
        arrowLabel.topAnchor.constraint(equalTo: arrowView.topAnchor).isActive = true
        arrowLabel.leftAnchor.constraint(equalTo: arrowView.leftAnchor).isActive = true
        arrowLabel.rightAnchor.constraint(equalTo: arrowView.rightAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: arrowView.bottomAnchor).isActive = true
        
        
//        addSubview(dateLabel)
//        addSubview(betaLabel)
//        addSubview(dateIntervalLabel)
//        addSubview(percentChangeLabel)
//
//
//
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dateLabel]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dateIntervalLabel]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0]-8-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dateLabel, "v1": dateIntervalLabel  ]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(100)]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": betaLabel]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0]-8-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": betaLabel, "v1": percentChangeLabel]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(100)]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": percentChangeLabel]))
//
    }
    
    
    
}
extension Double {
    public func truncate(places: Int, number: Double) -> Double {
        
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
}

extension Date {
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
}
