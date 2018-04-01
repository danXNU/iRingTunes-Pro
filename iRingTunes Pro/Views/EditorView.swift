//
//  EditorView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 14/02/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

enum EditorViewState {
    case closed
    case large
}

class EditorView: UIView {
    
    //TITOLO VARS
    var titleLabel : UILabel!                       //IL LABEL CONTENTENTE IL TITOLO DELLA CANZONE
    
    
    //SONG VARS
    var songStartContainer : UIView!                //VIEW CHE CONTIENE LO SLIDER INIZIO SONG E EVENTUALMENTE IL LABEL START TIME SONG
    var songDurationContainer : UIView!             //VIEW CHE CONTIENE LO SLIDER DURATA SONG E EVENTUALMENTE IL LABEL DURARA
    var songStartTimeSlider : UISlider!             //LO SLIDER CHE MODIFICA L'INIZIO DELLA CANZONE
    var songDurationTimeSlider : UISlider!          //LO SLIDER CHE MODIFICA LA DURATA DELLA CANZONE
    var songStartTimeLabel : UILabel!               //IL LABEL CHE MOSTRA QUANDO INZIA LA CANZONE
    var songDurationTimeLabel : UILabel!            //IL LABEL CHE MOSTRA A QUANTO è SETTATA LA DURATA DELLA SUONERIA
    
    var songMaxDuration : Float = 0 {               //VAR CHE DICE/SETTA QUANTO DURA LA CANZONE INTERA (NON LA SUONERIA)
        didSet {
            songStartTimeSlider?.maximumValue = songMaxDuration
        }
    }
    
    
    //FADE VARS
    var fadeView: UIView!                       //CONTIENE LE DUE CELLE DELLE IMPOSTAZIONI DEL FADE
    var fadeSwitch : UISwitch!                  //LO SWITCH CHE ATTIVA/DISATTIVA IL FADE
    var fadeDurationLabel : UILabel!            //IL LABEL CHE DICE QUANTO DURA IL FADE
    var fadeDurationSlider : UISlider!          //LO SLIDER CHE MODIFICA LA DURATA DEL FADE
    
    var currentFadeDurationValue : Int = 10 {   //VAR CHE DICE/SETTA QUANTO DURA IL FADE
        didSet {
            DispatchQueue.main.async {
                print("Called")
                self.fadeDurationSlider?.setValue(Float(self.currentFadeDurationValue), animated: true)
                self.fadeDurationLabel?.text = "\(self.currentFadeDurationValue)s"
            }
        }
    }
    
    
    
    
    //EDITORVIEW VARS
    
    var state : EditorViewState = .closed {     //VAR CHE DICE IN CHE STATO è LA VIEW E MODIFICA LE SUBVIEWS IN BASE A QUELLO
        didSet {
            DispatchQueue.main.async {
                switch self.state {
                case .closed:
                    UIView.animate(withDuration: 0.5, animations: {
                        self.fadeView.alpha = 0
                    })
                case .large:
                    UIView.animate(withDuration: 0.5, animations: {
                        self.fadeView.alpha = 1
                    })
                }
            }
        }
    }
    
    
    //SELECTORS
    
    @objc private func fadeDurationSliderDidMove(sender: UISlider) {    //SELECTOR CHIAMATO QUANDO LO SLIDER DURATA DEL FADE SI MUOVE
        self.fadeDurationLabel?.text = "\(Int(sender.value))s"
    }
    
    @objc private func fadeSwitchDidChangeValue(sender: UISwitch) {     //USATA QUANDO SI PREMRE LO SWITCH DELL'ATTIVA/DISATTIVA FADEIN
        
    }
    
    @objc private func songStartSliderDidMove(sender: UISlider) {       //USATA QUANDO LO SLIDER DELL'INIZIO SONG SI MUOVE
        
    }
    
    @objc private func songDurationSliderDidMove(sender: UISlider) {    //USATA QUANDO LO SLIDER DELLA SONG DURATION SI MUOVE
        
    }
    
    
    
    
    //INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

extension EditorView {
    private func initViews() {
        self.backgroundColor = .red
        
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.yellow.darker(by: 15)
        titleLabel.textColor = .darkGray
        titleLabel.textAlignment = .center
        titleLabel.text = "Test nome"
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10
        addSubview(titleLabel)
        titleLabel.anchor(top: self.topAnchor,
                          leading: self.leadingAnchor,
                          bottom: nil,
                          trailing: self.trailingAnchor,
                          padding: .init(top: 10, left: 15, bottom: 0, right: 15),
                          size: .init(width: 0, height: 30))
        
        
        
        //  ---INIZIO CONTAINER START SONG---   \\
        songStartContainer = UIView()
        songStartContainer.backgroundColor = .blue
        songStartContainer.layer.cornerRadius = 10
        addSubview(songStartContainer)
        songStartContainer.anchor(top: titleLabel.bottomAnchor,
                              leading: self.leadingAnchor,
                              bottom: nil,
                              trailing: self.trailingAnchor,
                              padding: .init(top: 10, left: 15, bottom: 0, right: 15),
                              size: .init(width: 0, height: 70))
        
        songStartTimeLabel = UILabel()
        songStartTimeLabel.textColor = .white
        songStartTimeLabel.textAlignment = .center
        songStartTimeLabel.adjustsFontSizeToFitWidth = true
        songStartTimeLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(17)
        songStartTimeLabel.text = "30:57"
        songStartContainer.addSubview(songStartTimeLabel)
        songStartTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        songStartTimeLabel.topAnchor.constraint(equalTo: songStartContainer.topAnchor).isActive = true
        songStartTimeLabel.bottomAnchor.constraint(equalTo: songStartContainer.bottomAnchor).isActive = true
        songStartTimeLabel.trailingAnchor.constraint(equalTo: songStartContainer.trailingAnchor).isActive = true
        songStartTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        songStartTimeSlider = UISlider()
        songStartTimeSlider.minimumTrackTintColor = .purple
        songStartContainer.addSubview(songStartTimeSlider)
        songStartTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        songStartTimeSlider.centerYAnchor.constraint(equalTo: songStartContainer.centerYAnchor).isActive = true
        songStartTimeSlider.leadingAnchor.constraint(equalTo: songStartContainer.leadingAnchor, constant: 10).isActive = true
        songStartTimeSlider.trailingAnchor.constraint(equalTo: songStartTimeLabel.leadingAnchor, constant: 0).isActive = true
        //                                      \\
        //  ---FINE CONTAINER START SONG---     \\
        
        
        
        
        
        
        //  ---INIZIO CONTAINER DURATION SONG---   \\
        songDurationContainer = UIView()
        songDurationContainer.backgroundColor = .purple
        songDurationContainer.layer.cornerRadius = 10
        addSubview(songDurationContainer)
        songDurationContainer.anchor(top: songStartContainer.bottomAnchor,
                                 leading: self.leadingAnchor,
                                 bottom: nil,
                                 trailing: self.trailingAnchor,
                                 padding: .init(top: 10, left: 15, bottom: 0, right: 15),
                                 size: .init(width: 0, height: 70))
        
        songDurationTimeSlider = UISlider()
        songDurationTimeSlider.minimumTrackTintColor = .blue
        songDurationContainer.addSubview(songDurationTimeSlider)
        songDurationTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        songDurationTimeSlider.centerYAnchor.constraint(equalTo: songDurationContainer.centerYAnchor).isActive = true
        songDurationTimeSlider.leadingAnchor.constraint(equalTo: songDurationContainer.leadingAnchor, constant: 10).isActive = true
        songDurationTimeSlider.trailingAnchor.constraint(equalTo: songDurationContainer.trailingAnchor, constant: -10).isActive = true
        //                                         \\
        //  ---FINE CONTAINER DURATION SONG---     \\
        
        
        
        
        
        //---   INIZIO CELL ACTIVATE FADE   ----\\
        let cellActiveFade = UIView()
        cellActiveFade.layer.borderColor = UIColor.white.cgColor
        cellActiveFade.layer.borderWidth = 0.4
        self.addSubview(cellActiveFade)
        
        fadeSwitch = UISwitch()
        fadeSwitch.isOn = false
        cellActiveFade.addSubview(fadeSwitch)
        fadeSwitch.translatesAutoresizingMaskIntoConstraints = false
        fadeSwitch.trailingAnchor.constraint(equalTo: cellActiveFade.trailingAnchor, constant: -10).isActive = true
        fadeSwitch.centerYAnchor.constraint(equalTo: cellActiveFade.centerYAnchor).isActive = true
        
        let label = UILabel()
        label.text = "Attiva Fade-In"
        label.textColor = .white
        cellActiveFade.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: cellActiveFade.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: fadeSwitch.leadingAnchor, constant: -10).isActive = true
        label.centerYAnchor.constraint(equalTo: cellActiveFade.centerYAnchor).isActive = true
        
        
        //|                                    |\\
        //---   FINE CELL ACTIVATE FADE     ----\\
        
        
        
        
        
        //---   INIZIO CELL DURATION FADE   ----\\
        let cellDurationFade = UIView()
        self.addSubview(cellDurationFade)
        
        
        fadeDurationLabel = UILabel()
        fadeDurationLabel.textAlignment = .center
        fadeDurationLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(20)
        fadeDurationLabel.textColor = .white
        fadeDurationLabel.layer.borderColor = UIColor.white.cgColor
        cellDurationFade.addSubview(fadeDurationLabel)
        
        fadeDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        fadeDurationLabel.topAnchor.constraint(equalTo: cellDurationFade.topAnchor).isActive = true
        fadeDurationLabel.bottomAnchor.constraint(equalTo: cellDurationFade.bottomAnchor).isActive = true
        fadeDurationLabel.trailingAnchor.constraint(equalTo: cellDurationFade.trailingAnchor).isActive = true
        fadeDurationLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        fadeDurationSlider = UISlider()
        fadeDurationSlider.maximumValue = 40
        fadeDurationSlider.minimumTrackTintColor = .green
        fadeDurationSlider.addTarget(self, action: #selector(fadeDurationSliderDidMove(sender:)), for: .valueChanged)
        cellDurationFade.addSubview(fadeDurationSlider)
        fadeDurationSlider.translatesAutoresizingMaskIntoConstraints = false
        fadeDurationSlider.centerYAnchor.constraint(equalTo: cellDurationFade.centerYAnchor).isActive = true
        fadeDurationSlider.leadingAnchor.constraint(equalTo: cellDurationFade.leadingAnchor, constant: 10).isActive = true
        fadeDurationSlider.trailingAnchor.constraint(equalTo: fadeDurationLabel.leadingAnchor, constant: 0).isActive = true
        //---   FINE CELL DURATION FADE ----\\
        
        
        
        
        
        
        
        
        let stackCells = UIStackView(arrangedSubviews: [cellActiveFade, cellDurationFade])
        stackCells.axis = .vertical
        stackCells.alignment = .fill
        stackCells.distribution = .fillEqually
        //self.addSubview(stackCells)
        
        
        fadeView = UIView()
        fadeView.addSubview(stackCells)
        fadeView.layer.borderColor = UIColor.white.cgColor
        fadeView.layer.borderWidth = 0.5
        addSubview(fadeView)
        fadeView.anchor(top: songDurationContainer.bottomAnchor,
                        leading: self.leadingAnchor,
                        bottom: nil,
                        trailing: self.trailingAnchor,
                        padding: .init(top: 15, left: -1, bottom: 0, right: -1),
                        size: .init(width: 0, height: 100))
        stackCells.fillSuperview()
        
        currentFadeDurationValue = 3
        
    }
}

