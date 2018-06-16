//
//  RTManagerView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class RTManagerView: UIView {

    let tableView = UITableView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initUI() {
        self.backgroundColor = .black
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 0.1
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        self.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}
