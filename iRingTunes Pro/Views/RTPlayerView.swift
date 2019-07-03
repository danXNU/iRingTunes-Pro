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
    func reloadStateSent()
}

class RTPlayerSong {
    var duration : Double
    var title : String
    var path : String
    
    init(duration: Double, title: String) {
        self.duration = duration
        self.title = title
        
        let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        self.path = offset.appending("/\(title)")
    }
}

class RTPlayerView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    public var viewColor : UIColor? {
        didSet {
            if let color = viewColor {
                DispatchQueue.main.async {
                    self.backgroundColor = color
                }
            }
        }
    }
    
    var song : RTPlayerSong? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewWithSongComponents()
            }
        }
    }
    public func loadViewWithSongComponents() {
        if let song = self.song {
            self.fullSongDuration = song.duration
            self.titleLabel.text = song.title
        }
    }
    
    weak var delegate : EditorPlayerViewDelegate?
    
    var changeMusicStateButton : UIButton!
    var currentTimeSlider : UISlider!
    var restartMusicButton : UIButton!
    var currentTimeLabel : UILabel!
    var maxSongTimeLabel : UILabel!
    
    var titleLabel : UILabel!
    
    var fullSongDuration : Double = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.currentTimeSlider?.maximumValue = Float(self!.fullSongDuration)
                self?.maxSongTimeLabel?.text = self?.fullSongDuration.playerValue
            }
        }
    }
    
    public func setCurrentSongTime(_ time : Double) {
        self.currentTimeSlider.value = Float(time)
        self.currentTimeLabel.text = time.playerValue
    }

    @objc private func changeStateButtonPressed() {
        delegate?.musicStateDidChange()
    }
    
    @objc private func restartRingtone() {
        delegate?.reloadStateSent()
    }
    
}
extension RTPlayerView {
    func setViews() {
        self.backgroundColor = .blue
        
        //PLAY/PAUSE BUTTON
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
        currentTimeSlider.minimumTrackTintColor = .red
        currentTimeSlider.maximumValue = 10 //TEMP, DA SOSTITUIRE CON LA DURATA DELLA CANZONE
        currentTimeSlider.value = 5         //TEMP
        self.addSubview(currentTimeSlider)
        currentTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        currentTimeSlider.topAnchor.constraint(equalTo: changeMusicStateButton.bottomAnchor, constant: 15).isActive = true
        currentTimeSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        currentTimeSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        
        //RELOAD BUTTON
        restartMusicButton = UIButton()
        restartMusicButton.setTitle("", for: .normal)
        restartMusicButton.setImage(#imageLiteral(resourceName: "reload"), for: .normal)
        restartMusicButton.layer.borderWidth = 0
        restartMusicButton.layer.borderColor = UIColor.white.cgColor
        restartMusicButton.addTarget(self, action: #selector(restartRingtone), for: .touchUpInside)
        self.addSubview(restartMusicButton)
        restartMusicButton.translatesAutoresizingMaskIntoConstraints = false
        restartMusicButton.centerYAnchor.constraint(equalTo: changeMusicStateButton.centerYAnchor).isActive = true
        restartMusicButton.leadingAnchor.constraint(equalTo: changeMusicStateButton.trailingAnchor, constant: 30).isActive = true
        restartMusicButton.heightAnchor.constraint(equalTo: changeMusicStateButton.heightAnchor, multiplier: 0.7).isActive = true
        restartMusicButton.widthAnchor.constraint(equalTo: restartMusicButton.heightAnchor).isActive = true
        
        
        currentTimeLabel = UILabel()
        currentTimeLabel.textColor = .white
        currentTimeLabel.layer.borderColor = UIColor.white.cgColor
        currentTimeLabel.layer.borderWidth = 0
        currentTimeLabel.adjustsFontSizeToFitWidth = true
        currentTimeLabel.text = "00:00"
        self.addSubview(currentTimeLabel)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.leadingAnchor.constraint(equalTo: currentTimeSlider.leadingAnchor).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: currentTimeSlider.topAnchor).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        maxSongTimeLabel = UILabel()
        maxSongTimeLabel.textColor = .white
        maxSongTimeLabel.layer.borderColor = UIColor.white.cgColor
        maxSongTimeLabel.layer.borderWidth = 0
        maxSongTimeLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(maxSongTimeLabel)
        maxSongTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        maxSongTimeLabel.trailingAnchor.constraint(equalTo: currentTimeSlider.trailingAnchor).isActive = true
        maxSongTimeLabel.bottomAnchor.constraint(equalTo: currentTimeSlider.topAnchor).isActive = true
        maxSongTimeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        maxSongTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        titleLabel = UILabel()
        titleLabel?.textColor = .white
        titleLabel.layer.borderColor = UIColor.white.cgColor
        titleLabel.layer.borderWidth = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = "00:00 - 00:00"
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}
