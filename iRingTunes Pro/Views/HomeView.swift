//
//  HomeView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 14/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class HomeView: RTBlackView {
    
    var createButton : UIBouncyButton?
    var managerButton : UIBouncyButton?
    var titleLabel : UILabel?
    
//    let gradient = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        gradient.colors = [UIColor.black.cgColor, UIColor.darkGray.darker(by: 15)!.cgColor]
//        gradient.frame = self.frame
//        self.layer.addSublayer(gradient)
        setup()
    }
    
//    override func layoutMarginsDidChange() {
//        super.layoutMarginsDidChange()
//        print("LAYOUT MARGINS DID CHANGE")
//        gradient.frame = self.frame
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        createButton = UIBouncyButton()
        createButton?.translatesAutoresizingMaskIntoConstraints = false
        createButton?.setTitle("Create", for: .normal)
        createButton?.backgroundColor = UIColor.darkGray.darker(by: 15)
        createButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        createButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        createButton?.titleLabel?.minimumScaleFactor = 0.7
        createButton?.titleLabel?.textColor = .white
        createButton?.layer.cornerRadius = 10
        
        createButton?.layer.shadowColor = UIColor.black.cgColor
        createButton?.layer.shadowOffset = CGSize(width: 0, height: 1)
        createButton?.layer.shadowOpacity = 1.0
        createButton?.layer.shadowRadius = 10
        createButton?.layer.masksToBounds = false
        self.addSubview(createButton!)
        
        
        managerButton = UIBouncyButton()
        managerButton?.translatesAutoresizingMaskIntoConstraints = false
        managerButton?.setTitle("Ringtones Manager", for: .normal)
        managerButton?.backgroundColor = UIColor.darkGray.darker(by: 10)
        managerButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        managerButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        managerButton?.titleLabel?.minimumScaleFactor = 0.7
        managerButton?.titleLabel?.textColor = .white
        managerButton?.layer.cornerRadius = 10
        
        managerButton?.layer.shadowColor = UIColor.black.cgColor
        managerButton?.layer.shadowOffset = CGSize(width: 0, height: 1)
        managerButton?.layer.shadowOpacity = 1.0
        managerButton?.layer.shadowRadius = 10
        managerButton?.layer.masksToBounds = false
        self.addSubview(managerButton!)
        
        
        let stackView = UIStackView(arrangedSubviews: [createButton!, managerButton!])
        stackView.arrangedSubviews[0].heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5) .isActive = true
        
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        titleLabel = UILabel()
        titleLabel?.text = "iRingTunes"
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.backgroundColor = UIColor.red
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.7
        titleLabel?.layer.cornerRadius = 10
        
        titleLabel?.layer.shadowColor = UIColor.red.cgColor
        titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 1)
        titleLabel?.layer.shadowOpacity = 1.0
        titleLabel?.layer.shadowRadius = 10
        titleLabel?.layer.masksToBounds = false

        
        self.addSubview(titleLabel!)
        
        if #available(iOS 11.0, *) {
            titleLabel?.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            let topSpace = UIApplication.shared.statusBarFrame.size.height + 10
            titleLabel?.topAnchor.constraint(equalTo: self.topAnchor, constant: topSpace).isActive = true
        }
        titleLabel?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        titleLabel?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel?.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
}
