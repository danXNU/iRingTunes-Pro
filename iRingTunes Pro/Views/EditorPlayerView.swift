//
//  EditorPlayerView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 02/04/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class EditorPlayerView: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    var changeMusicStateButton : UIButton!
    var currentTimeSlider : UISlider!
    var restartMusicButton : UIButton!
    
}
extension EditorPlayerView {
    func setViews() {
        self.backgroundColor = .blue
        
        changeMusicStateButton = UIButton()
        changeMusicStateButton?.setTitle("Play", for: .normal)
        changeMusicStateButton.layer.borderColor = UIColor.white.cgColor
        changeMusicStateButton.layer.borderWidth = 0.5
        self.addSubview(changeMusicStateButton)
        changeMusicStateButton.translatesAutoresizingMaskIntoConstraints = false
        changeMusicStateButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        changeMusicStateButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        changeMusicStateButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        changeMusicStateButton.widthAnchor.constraint(equalTo: changeMusicStateButton.heightAnchor, multiplier: 1).isActive = true
        
        
        
        currentTimeSlider = UISlider()
        currentTimeSlider.setThumbImage(UIImage(), for: .normal)
        currentTimeSlider.minimumTrackTintColor = .green
        currentTimeSlider.maximumValue = 10 //TEMP, DA SOSTITUIRE CON LA DURATA DELLA CANZONE
        currentTimeSlider.value = 5         //TEMP
        self.addSubview(currentTimeSlider)
        currentTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        currentTimeSlider.topAnchor.constraint(equalTo: changeMusicStateButton.bottomAnchor, constant: 15).isActive = true
        currentTimeSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        currentTimeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        
        
        restartMusicButton = UIButton()
        restartMusicButton.setTitle("R", for: .normal)
        restartMusicButton.layer.borderWidth = 0.5
        restartMusicButton.layer.borderColor = UIColor.white.cgColor
        self.addSubview(restartMusicButton)
        restartMusicButton.translatesAutoresizingMaskIntoConstraints = false
        restartMusicButton.centerYAnchor.constraint(equalTo: changeMusicStateButton.centerYAnchor).isActive = true
        restartMusicButton.leadingAnchor.constraint(equalTo: changeMusicStateButton.trailingAnchor, constant: 30).isActive = true
        restartMusicButton.heightAnchor.constraint(equalTo: changeMusicStateButton.heightAnchor, multiplier: 0.7).isActive = true
        restartMusicButton.widthAnchor.constraint(equalTo: restartMusicButton.heightAnchor).isActive = true
        
        
    }
}
