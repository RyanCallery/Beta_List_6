//
//  BetaTrendViewController.swift
//  Beta_List_6
//
//  Created by Ryan Callery on 7/17/18.
//  Copyright © 2018 Ryan Callery. All rights reserved.
//

import UIKit

class BetaTrendViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let cellID = "cellID"
    let headerID = "headerID"
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = self.view.frame
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.backgroundColor = .green
        collectionView?.register(BetaTrendCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! BetaTrendCollectionViewCell
        
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
