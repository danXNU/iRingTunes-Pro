//
//  RTDetailedPlayerView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 16/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class RTDetailedPlayerView: RTPlayerView {

    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
    
    override func loadViewWithSongComponents() {
        super.loadViewWithSongComponents()
        if let song = self.song {
            self.titleLabel.text = song.title
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadUI() {
        riassuntoTimeSong.removeFromSuperview()
        riassuntoTimeSong = nil
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
