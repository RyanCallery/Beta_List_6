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
        let frame = self.view.frame
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .green
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
        formatter.dateFormat = "M.d.yy"
        let betaObject = patient?.hcg?.object(at: indexPath.item) as! Hcg
        cell.betaLabel.text = betaObject.hcgLevel
        cell.dateLabel.text = formatter.string(from: betaObject.date! as Date)
        cell.dateIntervalLabel.text = dateInterval[indexPath.item]
        cell.percentChangeLabel.text = betaIntervalChange[indexPath.item]

        
//        let size = CGSize(width: 50, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        let estimatedFrame = NSString(string: cell.percentChangeLabel.text!).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)], context: nil)
//        cell.percentChangeLabel.frame = CGRect(x: 0, y: 0, width: estimatedFrame.width, height: estimatedFrame.height)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath)
        header.backgroundColor = .blue
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
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
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateIntervalLabel: UILabel = {
        let label = UILabel()
        label.text = "Date Interval"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let betaLabel: UILabel = {
        let label = UILabel()
        label.text = "Beta"
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let percentChangeLabel: UILabel = {
       let label = UILabel()
        label.text = "53%"
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        backgroundColor = .red
        addSubview(dateLabel)
        addSubview(betaLabel)
        addSubview(dateIntervalLabel)
        addSubview(percentChangeLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dateLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dateIntervalLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0]-8-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dateLabel, "v1": dateIntervalLabel  ]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(100)]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": betaLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0]-8-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": betaLabel, "v1": percentChangeLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(100)]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": percentChangeLabel]))
        
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
