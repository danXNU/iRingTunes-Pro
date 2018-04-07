//
//  TestVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 28/01/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import MediaPlayer

class TestVC: UIViewController {
    
    //MODELS
    public var exporter : RTExporter?
    public var rtPlayer : RTPlayer!
    
    //CONSTARINTS
    private var bottomCon : NSLayoutConstraint!
    
    //VIEWS
    private var expandViewButton : UIButton!
    private var editorView : EditorView!
    private var editorPlayerView : EditorPlayerView!
    
    
    var isFadeInActive : Bool = false
    var fadeDuration : Int = 3
    
    public var songName : String = "" {
        didSet {
            editorView.songName = self.songName
        }
    }
    
    public var selectedSongUrl : URL? {
        didSet {
            if let url = selectedSongUrl {
                self.loadPlayerAndUIWith(url)
            }
        }
    }
    
    lazy var exportButton : UIButton = {
        let button = UIButton()
        button.setTitle("Export", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.darkGray.darker(by: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var tempView : UIView = {
        let w = UIView()
        w.backgroundColor = .clear
        w.isUserInteractionEnabled = false
        w.translatesAutoresizingMaskIntoConstraints = false
        return w
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.darkGray.darker(by: 15)!.cgColor]
        gradient.frame = view.frame
        view.layer.addSublayer(gradient)
        
        
        let vc = MPMediaPickerController(mediaTypes: .anyAudio)
        vc.allowsPickingMultipleItems = false
        vc.delegate = self
        present(vc, animated: true)
        
        
        editorView = EditorView()
        editorView.layer.masksToBounds = true
        editorView.layer.cornerRadius = 10
        view.addSubview(editorView)
        editorView.translatesAutoresizingMaskIntoConstraints = false
        editorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        editorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        editorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        bottomCon = editorView.bottomAnchor.constraint(equalTo: editorView.songDurationContainer.bottomAnchor, constant: 10)
        bottomCon.isActive = true
        
        editorView.delegate = self
        editorView.songName = "Test musica da VC"
        
        expandViewButton = UIButton()
        expandViewButton.addTarget(self, action: #selector(animate), for: [.touchUpInside, .touchUpOutside])
        expandViewButton.backgroundColor = editorView.backgroundColor
        expandViewButton.layer.cornerRadius = 5
        expandViewButton.layer.masksToBounds = true
        expandViewButton.setTitle("↓", for: .normal)
        view.addSubview(expandViewButton)
        expandViewButton.translatesAutoresizingMaskIntoConstraints = false
        expandViewButton.topAnchor.constraint(equalTo: editorView.bottomAnchor, constant: -5).isActive = true
        expandViewButton.centerXAnchor.constraint(equalTo: editorView.centerXAnchor).isActive = true
        expandViewButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        expandViewButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        editorPlayerView = EditorPlayerView()
        editorPlayerView.backgroundColor = .blue
        editorPlayerView.layer.cornerRadius = 10
        editorPlayerView.delegate = self
        view.addSubview(editorPlayerView)
        editorPlayerView.anchor(top: expandViewButton.bottomAnchor,
                    leading: view.leadingAnchor,
                    bottom: nil,
                    trailing: view.trailingAnchor,
                    padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                    size: .init(width: 0, height: 120))
        
        view.addSubview(tempView)
        [ tempView.topAnchor.constraint(equalTo: editorPlayerView.bottomAnchor),
          tempView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          tempView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          tempView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].forEach({ $0.isActive = true })

        view.addSubview(exportButton)
        exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        exportButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        exportButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exportButton.centerYAnchor.constraint(equalTo: tempView.centerYAnchor).isActive = true
        
    }

    
    public func loadPlayerAndUIWith(_ url : URL) {
        rtPlayer = RTPlayer(songURL: url)
        rtPlayer?.actionToRepeat = { (playerCurrentValue) in
            if let playerValue = playerCurrentValue {
                self.editorPlayerView.setCurrentSongTime(playerValue)
            }
        }
        rtPlayer?.completionStart = { [weak self] in
            self?.editorPlayerView?.changeMusicStateButton?.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        rtPlayer?.completionPause = { [weak self] in
            self?.editorPlayerView?.changeMusicStateButton?.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        rtPlayer?.prepare { (code) in
            print("TestVC.mediaPickerDidPick...().player.prepare() ha ritornato il codice: \(code)")
        }
        
        rtPlayer?.setRingtoneTime(start: 0, duration: 40)
        
        editorPlayerView?.riassuntoTimeSong.text = "\(0.0.playerValue) - \(40.0.playerValue)"
        
        rtPlayer?.play(startingAt: 0) { (code) in
            print("TestVC.mediaPickerDidPick...().player.play() ha ritornato il codice: \(code)")
        }
        
        let fullSongDuration = rtPlayer.getSongDuration()
        
        editorPlayerView.fullSongDuration = fullSongDuration
        editorView.songMaxDuration = fullSongDuration
    }
    

    
    //SELECTORS
    
    @objc private func export() {
        
    }

    @objc private func animate() {
        
        switch editorView.state {
        case .closed:
            bottomCon.isActive = false
            bottomCon = editorView.bottomAnchor.constraint(equalTo: editorView.fadeView.bottomAnchor, constant: 10)
            bottomCon.isActive = true
            self.editorView.state = .large
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            expandViewButton.setTitle("↑", for: .normal)
        case .large:
            bottomCon.isActive = false
            bottomCon = editorView.bottomAnchor.constraint(equalTo: editorView.songDurationContainer.bottomAnchor, constant: 10)
            bottomCon.isActive = true
            self.editorView.state = .closed
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            expandViewButton.setTitle("↓", for: .normal)
        }
        
        
    }
    

}

extension TestVC : MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true)
        
        let musicTmp = mediaItemCollection.items.first
        guard let url2 = musicTmp?.value(forProperty: MPMediaItemPropertyAssetURL) as? URL else { return }
        
        self.loadPlayerAndUIWith(url2)
        
        
        
        
        
        return
        
        //OTTENGO LA MUSICA DALLA LIBRERIA
        let music = mediaItemCollection.items.first
        
        //OTTENGO L'URL DELLA MUSICA
        guard
            let url = music?.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        else {
            print("TestVC: music.value() == nil")
            return
        }
        
        //OTTENGO DEI VALORI DI PROVA
        let start = CMTime(seconds: 10, preferredTimescale: 1)
        let duration = CMTime(seconds: 30, preferredTimescale: 1)
        let range = CMTimeRange(start: start, duration: duration)
        
        //LI SETTO NELLA CLASSE SONGATTRIBUTES
        let attributes = SongAttributes(songName: music!.title!, timeRange: range, startFade: nil, durationFade: nil)
        exporter = RTExporter(initialSong: url, fadeIn: false, songAttributes: attributes)
        
        //MI SETTO COME DELGATE
        exporter?.delegate = self
        
        //PREPARO L'EXPORTER
        exporter?.prepare()
        
        //ESPORTO
        exporter?.export()
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true)
    }
}


extension TestVC : ExporterDelegate {
    func exportDidFinish(withCode code: Int, andMsg msg: String?) {
        switch code {
        case 0:
            print("SUCCESSO NELL'EXPORT")
            
            
        case 1:
            print("ERRORE NELL'EXPORT")
            print(msg!)
        default:
            print("ricevuto un errore")
        }
    }
    
    
}

extension TestVC : EditorViewDelegate {
    func sliderDidMoveAt(_ value: Float, sliderType: EditorViewSliderType, view: UIView) {
        let senderView = view as? EditorView
        let durationOpt = senderView?.currentSongDurationValue
        
        switch sliderType {
        case .fadeDuration:
            print("Lo slider del fade è stato messo su: \(Int(value))s")
            
            self.fadeDuration = Int(value)
            
            
        case .songDuration:
            if let playerStartRingtone = rtPlayer?.startRingtone {
                rtPlayer?.setRingtoneTime(start: playerStartRingtone, duration: Int(value))
                editorPlayerView?.riassuntoTimeSong?.text = "\(playerStartRingtone.playerValue) - \((playerStartRingtone + Double(value)).playerValue)"
            }

            
        case .songStart:
            if let duration = durationOpt {
                rtPlayer?.setRingtoneTime(start: Double(value), duration: Int(duration))
                editorPlayerView?.riassuntoTimeSong?.text = "\(Double(value).playerValue) - \(Double(value + duration).playerValue)"
            }
            rtPlayer?.setCurrentTime(Double(value))
        }
    }
    
    func switchWasTouched(_ sender: UISwitch, switchType: EditorViewSwitchType) {
        switch switchType {
        case .fade:
            print("Lo switch del fade è stato messo su: \(sender.isOn ? "Acceso" : "Spento")")
            self.isFadeInActive = sender.isOn
        }
    }
    
    
}


extension TestVC : EditorPlayerViewDelegate {
    func musicStateDidChange() {
        if rtPlayer?.isPlaying() == Optional(true) {
            rtPlayer?.pause()
        } else {
            rtPlayer?.resume()
        }
    }
    
    
    func reloadStateSent() {
        let startTime = Double(self.editorView.currentSongStartTime)
        rtPlayer?.setCurrentTime(startTime)
    }
    
}


