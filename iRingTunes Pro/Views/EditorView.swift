//
//  EditorView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 14/02/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

enum EditorViewState {              //USATO PER SAPERE QUANDO LA VIEW VIENE INGRANDITA COSì DA SVOLGERE UN'ANIMAZIONE ALLE CELLE
    case closed
    case large
}

enum EditorViewSliderType {         //TIPO DI SLIDER. USATO NEI MESSAGGI AL DELEGATE
    case songStart
    case songDuration
    case fadeDuration
}

enum EditorViewSwitchType {         //TIPO DI SWITCH. AL MOMENTO SOLO UNO. USATO NEI MESSAGGI AL DELEGATE
    case fade
}

protocol EditorViewDelegate : class {            //DELEGATE CHE PARLERà CON IL CONTROLLER QUANDO GLI SLIDER VENGONO MOSSI
    func sliderDidMoveAt(_ value : Float, sliderType : EditorViewSliderType, view : UIView)
    func switchWasTouched(_ sender: UISwitch, switchType: EditorViewSwitchType)
}

class EditorView: UIView {
    
    weak var delegate : EditorViewDelegate?         //IL DELAGATE CHE COMUNICHERà CON IL CONTROLLER
    
    //TITOLO VARS
    private var titleLabel : UILabel!                       //IL LABEL CONTENTENTE IL TITOLO DELLA CANZONE
    
    public var songName : String? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.titleLabel?.text = self?.songName
            }
        }
    }
    
    //SONG VARS
    fileprivate var songStartContainer : UIView!                //VIEW CHE CONTIENE LO SLIDER INIZIO SONG E EVENTUALMENTE IL LABEL START TIME SONG
    public var songDurationContainer : UIView!             //VIEW CHE CONTIENE LO SLIDER DURATA SONG E EVENTUALMENTE IL LABEL DURARA
    fileprivate var songStartTimeSlider : UISlider!             //LO SLIDER CHE MODIFICA L'INIZIO DELLA CANZONE
    fileprivate var songDurationTimeSlider : UISlider!          //LO SLIDER CHE MODIFICA LA DURATA DELLA CANZONE
    fileprivate var songStartTimeLabel : UILabel!               //IL LABEL CHE MOSTRA QUANDO INZIA LA CANZONE
    fileprivate var songDurationTimeLabel : UILabel!            //IL LABEL CHE MOSTRA A QUANTO è SETTATA LA DURATA DELLA SUONERIA
    
    public var songMaxDuration : Double = 0 {               //VAR CHE DICE/SETTA QUANTO DURA LA CANZONE INTERA (NON LA SUONERIA)
        didSet {
            songStartTimeSlider?.maximumValue = Float(songMaxDuration)
        }
    }
    
    public var currentSongStartTime : Float = 0 {       //VAR CHE DICE/SETTA L'INIZIO DELLA SUONERIA ATTUALE
        didSet {
            DispatchQueue.main.async {
                self.songStartTimeSlider.setValue(self.currentSongStartTime, animated: true)
                self.songStartTimeLabel.text = Double(self.currentSongStartTime).playerValue
            }
        }
    }
    
    public var currentSongDurationValue : Float = 40 {  //VAR CHE DICE/SETTA LA DURATION DELLA SUONERIA ATTUALE
        didSet {
            DispatchQueue.main.async {
                self.songDurationTimeSlider.value = self.currentSongDurationValue
                self.songDurationTimeLabel.text = "\(Int(self.currentSongDurationValue))s"
            }
            
        }
    }
    
    
    //FADE VARS
    public var fadeView: UIView!                       //CONTIENE LE DUE CELLE DELLE IMPOSTAZIONI DEL FADE
    fileprivate var fadeSwitch : UISwitch!                  //LO SWITCH CHE ATTIVA/DISATTIVA IL FADE
    fileprivate var fadeDurationLabel : UILabel!            //IL LABEL CHE DICE QUANTO DURA IL FADE
    fileprivate var fadeDurationSlider : UISlider!          //LO SLIDER CHE MODIFICA LA DURATA DEL FADE
    
    fileprivate var currentFadeDurationValue : Float = 10 {   //VAR CHE DICE/SETTA QUANTO DURA IL FADE
        didSet {
            DispatchQueue.main.async {
                self.fadeDurationSlider?.setValue(self.currentFadeDurationValue, animated: true)
                self.fadeDurationLabel?.text = "\(Int(self.currentFadeDurationValue))s"
            }
        }
    }
    
    fileprivate var fadeActivated : Bool = false {          //VAR CHE DICE/SETTA SE IL FADE è ATTIVO
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.fadeSwitch?.isOn = self!.fadeActivated
            }
        }
    }
    
    //EDITORVIEW VARS
    
    public var state : EditorViewState = .closed {     //VAR CHE DICE IN CHE STATO è LA VIEW E MODIFICA LE SUBVIEWS IN BASE A QUELLO
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
        currentFadeDurationValue = sender.value
        self.delegate?.sliderDidMoveAt(sender.value, sliderType: .fadeDuration, view: self)
    }
    
    @objc private func fadeSwitchDidChangeValue(sender: UISwitch) {     //USATA QUANDO SI PREMRE LO SWITCH DELL'ATTIVA/DISATTIVA FADEIN
        fadeActivated = sender.isOn
        self.delegate?.switchWasTouched(sender, switchType: .fade)
    }
    
    @objc private func songStartSliderDidMove(sender: UISlider) {       //USATA QUANDO LO SLIDER DELL'INIZIO SONG SI MUOVE
        currentSongStartTime = sender.value
        self.delegate?.sliderDidMoveAt(sender.value, sliderType: .songStart, view: self)
    }
    
    @objc private func songDurationSliderDidMove(sender: UISlider) {    //USATA QUANDO LO SLIDER DELLA SONG DURATION SI MUOVE
        currentSongDurationValue = sender.value
        self.delegate?.sliderDidMoveAt(sender.value, sliderType: .songDuration, view: self)
    }
    
    
    
    
    //INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    //CUSTOM COLORS
    public var viewColor : UIColor? {
        didSet {
            if let color = viewColor {
                DispatchQueue.main.async {
                    self.backgroundColor = color
                }
            }
        }
    }
    
    public var startContainerColor : UIColor? {
        didSet {
            if let color = startContainerColor {
                DispatchQueue.main.async {
                    self.songStartContainer.backgroundColor = color
                }
            }
        }
    }
    
    public var durationContainerColor : UIColor? {
        didSet {
            if let color = durationContainerColor {
                DispatchQueue.main.async {
                    self.songDurationContainer.backgroundColor = color
                }
            }
        }
    }
    
    public var titleBackgroundColor : UIColor? {
        didSet {
            if let color = titleBackgroundColor {
                DispatchQueue.main.async {
                    self.titleLabel.backgroundColor = color
                }                
            }
        }
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
        
        
        let songStartTitle = UILabel()
        songStartTitle.text = "Inizio suoneria"
        songStartTitle.textColor = .white
        songStartTitle.textAlignment = .center
        songStartTitle.font = UIFont.preferredFont(forTextStyle: .body).withSize(13)
        songStartTitle.adjustsFontSizeToFitWidth = true
        songStartContainer.addSubview(songStartTitle)
        songStartTitle.translatesAutoresizingMaskIntoConstraints = false
        songStartTitle.topAnchor.constraint(equalTo: songStartContainer.topAnchor).isActive = true
        songStartTitle.centerXAnchor.constraint(equalTo: songStartContainer.centerXAnchor).isActive = true
        songStartTitle.widthAnchor.constraint(equalTo: songStartContainer.widthAnchor).isActive = true
        songStartTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        songStartTimeLabel = UILabel()
        songStartTimeLabel.textColor = .white
        songStartTimeLabel.textAlignment = .center
        songStartTimeLabel.adjustsFontSizeToFitWidth = true
        songStartTimeLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(15)
        songStartContainer.addSubview(songStartTimeLabel)
        songStartTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        songStartTimeLabel.topAnchor.constraint(equalTo: songStartContainer.topAnchor).isActive = true
        songStartTimeLabel.bottomAnchor.constraint(equalTo: songStartContainer.bottomAnchor).isActive = true
        songStartTimeLabel.trailingAnchor.constraint(equalTo: songStartContainer.trailingAnchor).isActive = true
        songStartTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        songStartTimeSlider = UISlider()
        songStartTimeSlider.addTarget(self, action: #selector(songStartSliderDidMove(sender:)), for: [.touchUpInside, .touchUpOutside])
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
        
        
        let songDurationTitle = UILabel()
        songDurationTitle.text = "Durata suoneria"
        songDurationTitle.textColor = .white
        songDurationTitle.textAlignment = .center
        songDurationTitle.font = UIFont.preferredFont(forTextStyle: .body).withSize(13)
        songDurationTitle.adjustsFontSizeToFitWidth = true
        songDurationContainer.addSubview(songDurationTitle)
        songDurationTitle.translatesAutoresizingMaskIntoConstraints = false
        songDurationTitle.topAnchor.constraint(equalTo: songDurationContainer.topAnchor).isActive = true
        songDurationTitle.centerXAnchor.constraint(equalTo: songDurationContainer.centerXAnchor).isActive = true
        songDurationTitle.widthAnchor.constraint(equalTo: songDurationContainer.widthAnchor).isActive = true
        songDurationTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        songDurationTimeLabel = UILabel()
        songDurationTimeLabel.textAlignment = .center
        songDurationTimeLabel.font = UIFont.preferredFont(forTextStyle: .body).withSize(15)
        songDurationTimeLabel.adjustsFontSizeToFitWidth = true
        songDurationTimeLabel.text = "40s"
        songDurationTimeLabel.textColor = .white
        songDurationContainer.addSubview(songDurationTimeLabel)
        songDurationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        songDurationTimeLabel.topAnchor.constraint(equalTo: songDurationContainer.topAnchor).isActive = true
        songDurationTimeLabel.bottomAnchor.constraint(equalTo: songDurationContainer.bottomAnchor).isActive = true
        songDurationTimeLabel.trailingAnchor.constraint(equalTo: songDurationContainer.trailingAnchor).isActive = true
        songDurationTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        songDurationTimeSlider = UISlider()
        songDurationTimeSlider.minimumTrackTintColor = .blue
        songDurationTimeSlider.maximumValue = 40
        songDurationTimeSlider.addTarget(self, action: #selector(songDurationSliderDidMove(sender:)), for: [.touchUpInside, .touchUpOutside])
        songDurationContainer.addSubview(songDurationTimeSlider)
        songDurationTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        songDurationTimeSlider.centerYAnchor.constraint(equalTo: songDurationContainer.centerYAnchor).isActive = true
        songDurationTimeSlider.leadingAnchor.constraint(equalTo: songDurationContainer.leadingAnchor, constant: 10).isActive = true
        songDurationTimeSlider.trailingAnchor.constraint(equalTo: songDurationTimeLabel.leadingAnchor, constant: 0).isActive = true
        //                                         \\
        //  ---FINE CONTAINER DURATION SONG---     \\
        
        
        
        
        
        //---   INIZIO CELL ACTIVATE FADE   ----\\
        let cellActiveFade = UIView()
        cellActiveFade.layer.borderColor = UIColor.white.cgColor
        cellActiveFade.layer.borderWidth = 0.4
        self.addSubview(cellActiveFade)
        
        fadeSwitch = UISwitch()
        fadeSwitch.isOn = false
        fadeSwitch.addTarget(self, action: #selector(fadeSwitchDidChangeValue(sender:)), for: .valueChanged)
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
        fadeDurationSlider.maximumValue = 10
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
        
        fadeActivated = false
        currentFadeDurationValue = 3
        currentSongDurationValue = 40
        currentSongStartTime = 0
        
    }
}

