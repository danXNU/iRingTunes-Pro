//
//  RTManagerSongInfoView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class RTManagerSongInfoView: RTBlackView {

    var titleLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let playButton = UIBouncyButton()
    let shareButton = UIButton()
    let removeButton = UIButton()
    let renameButton = UIButton()
    private func loadUI() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 23)
        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(titleLabel)
        if #available(iOS 11.0, *) {
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        } else {
            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            let navigationBarHeight = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.navigationBar.frame.height ?? 0.0
            let offset = statusBarHeight + navigationBarHeight
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        }
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playButton)
        playButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        shareButton.titleLabel?.textColor = .white
        shareButton.backgroundColor = UIColor.green.darker()
        addSubview(shareButton)
        
        removeButton.setTitle("Remove", for: .normal)
        removeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        removeButton.titleLabel?.textColor = .white
        removeButton.backgroundColor = UIColor.red
        addSubview(removeButton)
        
        renameButton.setTitle("Rename", for: .normal)
        renameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        renameButton.titleLabel?.textColor = .white
        renameButton.backgroundColor = UIColor.orange.lighter(by: 8)
        addSubview(renameButton)
        
        
        
        let stackView = UIStackView(arrangedSubviews: [shareButton, renameButton, removeButton])
        (stackView.subviews as? [UIButton])?.forEach({ $0.layer.cornerRadius = 10 })
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.35).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        
    }
}
