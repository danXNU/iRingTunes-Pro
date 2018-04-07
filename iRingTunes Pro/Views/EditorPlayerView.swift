//
//  EditorPlayerView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 02/04/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

protocol EditorPlayerViewDelegate : NSObjectProtocol {
    func musicStateDidChange()
}


class EditorPlayerView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    weak var delegate : EditorPlayerViewDelegate?
    
    var changeMusicStateButton : UIButton!
    var currentTimeSlider : UISlider!
    var restartMusicButton : UIButton!
    
    
    var fullSongDuration : Double = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.currentTimeSlider?.maximumValue = Float(self!.fullSongDuration)
            }
        }
    }
    
    public func setCurrentSongTime(_ time : Double) {
        self.currentTimeSlider.value = Float(time)
    }

    @objc private func changeStateButtonPressed() {
        print("ChangeStateMusic pressed")
        delegate?.musicStateDidChange()
    }
    
}
extension EditorPlayerView {
    func setViews() {
        self.backgroundColor = .blue
        
        changeMusicStateButton = UIButton()
        changeMusicStateButton?.setTitle("", for: .normal)
        changeMusicStateButton?.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        changeMusicStateButton.layer.borderColor = UIColor.white.cgColor
        changeMusicStateButton.layer.borderWidth = 0
        changeMusicStateButton.addTarget(self, action: #selector(changeStateButtonPressed), for: .touchUpInside)
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
        restartMusicButton.setTitle("", for: .normal)
        restartMusicButton.setImage(#imageLiteral(resourceName: "reload"), for: .normal)
        restartMusicButton.layer.borderWidth = 0
        restartMusicButton.layer.borderColor = UIColor.white.cgColor
        self.addSubview(restartMusicButton)
        restartMusicButton.translatesAutoresizingMaskIntoConstraints = false
        restartMusicButton.centerYAnchor.constraint(equalTo: changeMusicStateButton.centerYAnchor).isActive = true
        restartMusicButton.leadingAnchor.constraint(equalTo: changeMusicStateButton.trailingAnchor, constant: 30).isActive = true
        restartMusicButton.heightAnchor.constraint(equalTo: changeMusicStateButton.heightAnchor, multiplier: 0.7).isActive = true
        restartMusicButton.widthAnchor.constraint(equalTo: restartMusicButton.heightAnchor).isActive = true
        
        
    }
}
