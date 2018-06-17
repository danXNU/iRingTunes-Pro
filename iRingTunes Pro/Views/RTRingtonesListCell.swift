//
//  RTRingtonesListCell.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 17/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class RTRingtonesListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    let songLabel = UILabel()
    private func loadUI() {
        let v = TouchView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.darkGray.darker(by: 20)
        v.layer.cornerRadius = 10
        self.addSubview(v)
        v.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        v.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        v.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7).isActive = true
        v.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        
        v.layer.shadowColor = UIColor.gray.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 0)
        v.layer.shadowOpacity = 1.0
        v.layer.shadowRadius = 10
        v.layer.masksToBounds = false
        
        
        
        songLabel.translatesAutoresizingMaskIntoConstraints = false
        songLabel.font = UIFont.boldSystemFont(ofSize: 17)
        songLabel.textColor = .white
        v.addSubview(songLabel)
        songLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        songLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 10).isActive = true
        songLabel.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -10).isActive = true
        songLabel.heightAnchor.constraint(equalTo: v.heightAnchor, multiplier: 0.35).isActive = true
        
        
        
    }
    
}
