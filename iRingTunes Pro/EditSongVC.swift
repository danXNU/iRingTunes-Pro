//
//  EditSongVC.swift
//  iRingTunes Lite
//
//  Created by Dani Tox on 06/07/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import MediaPlayer

class EditSongVC: UIViewController {
    
    var imageView : UIImageView {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = #imageLiteral(resourceName: "dark")
        return imageView
    }
    
    
    var editView : UIView {
        var frame : CGRect?
        let iPhoneModel = UIDevice.current.modelName
        
        switch iPhoneModel {
        case "iPhone 5s", "iPhone 5c", "iPhone 5", "iPhone SE":
            frame = CGRect(x: 10, y: 25, width: view.frame.width - 20, height: view.frame.height / 2 - 30)
        default:
            frame = CGRect(x: 10, y: 25, width: view.frame.width - 20, height: view.frame.height / 2)
        }
        
        
        let viewEdit = UIView(frame: frame!)
        viewEdit.layer.masksToBounds = true
        viewEdit.layer.cornerRadius = 10
        viewEdit.center.x = view.center.x
        viewEdit.backgroundColor = UIColor.red
        
        return viewEdit
    }
    
    var titleLabel : UILabel {
        let frame = CGRect(x: 0, y: 27, width: view.frame.width - 70, height: 40)
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = UserDefaults.standard.string(forKey: "musicName")!
        label.font = UIFont.systemFont(ofSize: 20)
        label.center.x = view.center.x
        return label
    }
    
    func addStartSlider(selector: Selector, y: CGFloat) -> UISlider
    {
        let slider = UISlider(frame: CGRect(x: 10, y: y, width: editView.frame.width - 30, height: 20))
        slider.center.x = view.center.x
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.tintColor = UIColor.green
        slider.addTarget(self, action: selector, for: .valueChanged)
        
        return slider
    }
    
    
    @objc func valueChangedOfSlider(slider: UISlider)
    {
        print(slider.value)
        secondsStart = Int(sliderInizio!.value)
        
        
    }
    
    @objc func valueChangedOfSliderFine(slider: UISlider)
    {
        print(slider.value)
        secondsFinish = Int(sliderFine!.value)
        
    }
    
    var secondsStart = 0 {
        didSet {
            let seconds = secondsStart % 60
            let minutes = secondsStart / 60
            if minutes < 10 && seconds < 10 {
                
                inizioLabel?.text = "Start: 0\(minutes):0\(seconds)"
            }
            else if minutes < 10 {
                
                inizioLabel?.text = "Start: 0\(minutes):\(seconds)"
            }
            else if seconds < 10 {
                
                inizioLabel?.text = "Start: \(minutes):0\(seconds)"
            }
            else {
                
                inizioLabel?.text = "Start: \(minutes):\(seconds)"
            }
            
            
            //rinizioLabel?.text = "Start: \(secondsStart)"
            sliderInizio?.value = Float(secondsStart)
            durataLabel?.text = "Duration: \(String(format: "%.0f", arguments: [durata]))s"
            
            audioPlayer?.currentTime = TimeInterval(secondsStart)
            secondsFinish = secondsStart + 40
            
            audioPlayer?.play()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSeconds), userInfo: nil, repeats: true)
        }
    }
    
    var secondsFinish = 0 {
        didSet {
            let seconds = secondsFinish % 60
            let minutes = secondsFinish / 60
            if minutes < 10 && seconds < 10 {
                
                fineLabel?.text = "Finish: 0\(minutes):0\(seconds)"
            }
            else if minutes < 10 {
                
                fineLabel?.text = "Finish: 0\(minutes):\(seconds)"
            }
            else if seconds < 10 {
                
                fineLabel?.text = "Finish: \(minutes):0\(seconds)"
            }
            else {
                
                fineLabel?.text = "Finish: \(minutes):\(seconds)"
            }
            
            
            
            //fineLabel?.text = "Finish: \(secondsFinish)"
            sliderFine?.value = Float(secondsFinish)
            durataLabel?.text = "Duration: \(String(format: "%.0f", arguments: [durata]))s"
            
            if secondsFinish <= secondsStart {
                secondsFinish = secondsStart + 40
            }
            
            audioPlayer?.play()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSeconds), userInfo: nil, repeats: true)
        }
    }
    
    var durata : Double {
        get {
            return Double((sliderFine?.value)! - (sliderInizio?.value)!)
        }
        
    }
    
    var sliderInizio : UISlider?
    var sliderFine : UISlider?
    
    var inizioLabel : UILabel?
    var fineLabel : UILabel?
    
    var durataLabel : UILabel?
    
    var audioPlayer : AVAudioPlayer?
    
    var exportButton : UIButton {
        
        let modeliPhone = UIDevice.current.modelName
        
        var frame : CGRect?
        
        switch modeliPhone {
        case "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE":
            frame = CGRect(x: view.center.x, y: view.frame.maxY - 120, width: 100, height: 50)
        default:
            frame = CGRect(x: view.center.x, y: view.frame.maxY - 170, width: 130, height: 70)
        }
        
        
        let button = UIButton(frame: frame!)
        button.setTitle("Export", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.backgroundColor = UIColor.orange
        
        switch modeliPhone {
        case "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE":
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        default:
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        }
        
        
        button.center.x = view.center.x
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(exportAction), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }
    
    var loadingView : UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = view.center
        activityView.color = UIColor.orange
        activityView.startAnimating()
        return activityView
    }
    
    var exportView : UIView {
        let uiview = UIView(frame: view.frame)
        uiview.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        
        uiview.addSubview(blurView)
        
        blurView.contentView.addSubview(loadingView)
        
        return uiview
    }
    
    
    var fadeIn : Bool!
    
    @objc func exportAction() {
        if (durata < 40.9) {
            if (durata > 0.1) {
                view.addSubview(exportView)
                exportView.tag = 100
                
                let urlString = UserDefaults.standard.string(forKey: "urlSonginCache")
                //print("Sto per rimuovere il file: \(urlString!)")
                //deleteFileAt(path: urlString!)
                
                let urlExport = URL(fileURLWithPath: urlString!)
                
       
                let asset = AVAsset(url: urlExport)
                
                
                let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
                exporter?.outputFileType = AVFileType.m4a
                
                if fadeIn == true {
                    let audioMix = AVMutableAudioMix()
                    let track = asset.tracks(withMediaType: AVMediaType.audio)[0]
                    
                    
                    let secondsDurationFade = UserDefaults.standard.integer(forKey: "fadeInDuration")
                    let startFade = CMTime(value: CMTimeValue(secondsStart), timescale: 1)
                    let durationFade = CMTime(value: CMTimeValue(secondsDurationFade), timescale: 1)
                    
                    
                    let parameters = AVMutableAudioMixInputParameters(track: track)
                    parameters.setVolumeRamp(fromStartVolume: 0.0, toEndVolume: 1.0, timeRange: CMTimeRange(start: startFade, duration: durationFade))
                    audioMix.inputParameters = [parameters]
                    
                    exporter?.audioMix = audioMix
                }
                
                
                let nameSong = UserDefaults.standard.string(forKey: "musicName")
                
                let outputURLString = returnPath(SysPath: .documentDirectory, urlStringtoAdd: "/\(nameSong!).m4r")
                let outputURL = URL(fileURLWithPath: outputURLString)
                
                deleteFileAt(path: outputURLString)
                
                exporter?.outputURL = outputURL
                UserDefaults.standard.set(outputURL, forKey: "FinalURL")
                
                print("OUTPUT URL: \(outputURLString)")
                
                let start = CMTime(value: CMTimeValue((sliderInizio?.value)!), timescale: 1)
                let end = CMTime(value: CMTimeValue((sliderFine?.value)!), timescale: 1)
                exporter?.timeRange = CMTimeRange(start: start, end: end)
                
                
                
                
                exporter?.exportAsynchronously(completionHandler: {
                    let status = exporter?.status
                    
                    
                    switch (status!) {
                    case .completed:
                        print("Completata l'esportazione in file .m4r")
                        self.audioPlayer?.stop()
                        DispatchQueue.main.async {
                            for subview in self.view.subviews {
                                if subview.tag == 100 {
                                    subview.removeFromSuperview()
                                }
                            }
                            let vc = ShareVC()
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                        
                        
                    case .failed(let error):
                        print("Errore nell'esportazione a file .m4r: \(error)")
                    default:
                        print("Errore sconosciuto durante l'esportazion a file .m4r")
                    }
                    
                    
                    
                    
                })
            }
            else {
                let alert = UIAlertController(title: "Error", message: "The End Time is lower than the Start Time. Do You want me to fix it?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    if Float(self.secondsStart + 30) > (self.sliderFine?.maximumValue)! {
                        self.secondsFinish = Int(self.sliderInizio!.maximumValue)
                    }
                    else {
                        self.secondsFinish = self.secondsStart + 30
                    }
                    
                }))
                present(alert, animated: true, completion: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Sorry", message: "You can only create a ringtone that lasts max 40 seconds (it's limited by Apple). BTW do you want me to reduce the ringtone for you?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                if Float(Double(self.secondsStart) + 40.0) > (self.sliderFine?.maximumValue)! {
                    self.secondsFinish = Int(self.sliderInizio!.maximumValue)
                }
                else {
                    self.secondsFinish = Int(Double(self.secondsStart) + 40.0)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func returnPath(SysPath: FileManager.SearchPathDirectory, urlStringtoAdd: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(SysPath, .userDomainMask, true).first?.appending(urlStringtoAdd)
        return path!
    }
    
    
    func deleteFileAt(path: String) {
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(at: URL(fileURLWithPath: path))
            }
            catch {
                print("Errore nell'eliinazione del file: \(error)")
            }
        }
            
        else {
            print("Il file non esiste quindi continuo...")
        }
    }
    
    var backButton : UIButton {
        let frame = CGRect(x: 10, y: view.frame.maxY - 60, width: 85, height: 50)
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Back", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
        
    }
    
    @objc func backAction() {
        audioPlayer?.stop()
        timer?.invalidate()
        let vc = ViewController()
        present(vc, animated: true, completion: nil)
    }
    
    var switchFade : UISwitch {
        let switchB = UISwitch()
        switchB.frame = CGRect(x: editView.frame.minX + 30, y: 220, width: 50, height: 50)
        switchB.isOn = fadeIn
        
        switchB.addTarget(self, action: #selector(changeFadeBool), for: .valueChanged)
        
        return switchB
    }
    
    var buttonForOpenFadeSettings : UIButton {
        let frame = CGRect(x: editView.frame.minX + 20, y: 217.5, width: 80, height: 40)
        let button = UIButton(frame: frame)
        
        button.backgroundColor = UIColor.blue
        button.setTitle("Fade", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(openFadeSettings), for: .touchUpInside)
        
        return button
    }
    
    func rBlurView() -> UIView {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor.clear
        let effect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.view.frame
        
        let button = UIButton(frame: self.view.frame)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(exitFadeSettings), for: .touchUpInside)
        
        
    
        view.addSubview(blurView)
        view.addSubview(button)
        
        return view
    }
    var blurView : UIView?
    
    @objc func exitFadeSettings() {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.containerView?.frame = self.buttonForOpenFadeSettings.frame

            
            
        })  {   (completed) in
            print("Just left Settings")
            self.blurView?.removeFromSuperview()
        }
    }

    var containerView : UIView?
    @objc func openFadeSettings() {
        blurView = rBlurView()
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        //containerView.center = self.view.center
        
        containerView?.frame = buttonForOpenFadeSettings.frame
        containerView?.alpha = 0
        containerView?.layer.masksToBounds = true
        containerView?.layer.cornerRadius = 10
        containerView?.backgroundColor = UIColor.darkGray
        
        let labelActiveDisable = UILabel(frame: CGRect(x: 50, y: 65, width: 200, height: 50))
        labelActiveDisable.text = "Activate/Disable"
        labelActiveDisable.textAlignment = .center
        labelActiveDisable.backgroundColor = UIColor.orange
        labelActiveDisable.layer.masksToBounds = true
        labelActiveDisable.layer.cornerRadius = 10
        labelActiveDisable.font = UIFont.boldSystemFont(ofSize: 19)
        
        let switchFade = UISwitch(frame: CGRect(x: 125, y: 140, width: 50, height: 50))
        switchFade.isOn = fadeIn
        switchFade.addTarget(self, action: #selector(changeFadeBool), for: .valueChanged)
        
        
        
        self.view.addSubview(blurView!)
        blurView?.alpha = 0
        containerView?.addSubview(switchFade)
        containerView?.addSubview(labelActiveDisable)
        blurView?.addSubview(containerView!)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView?.alpha = 1
            
            self.containerView?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            self.containerView?.center = self.view.center
            self.containerView?.alpha = 1
            
            
            
        }) { (completed) in
            print("Opened Fade Settings")
            
            
        }
    }
    
    @objc func changeFadeBool() {
        fadeIn = !fadeIn
        UserDefaults.standard.set(fadeIn, forKey: "isFadeInActivated")
        print(fadeIn)
    }
    
    func addLabal() -> UILabel {
        let frame = CGRect(x: 100, y: 220, width: 80, height: 35)
        let label = UILabel(frame: frame)
        label.center.x = view.center.x
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }
    
    var timerStop : Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fadeIn = UserDefaults.standard.bool(forKey: "isFadeInActivated")
        
        view.addSubview(imageView)
        
        view.addSubview(editView)
        view.addSubview(titleLabel)
        //view.addSubview(inizioLabel)
        
        sliderInizio = addStartSlider(selector: #selector(valueChangedOfSlider(slider: )), y: 110)
        view.addSubview(sliderInizio!)
        
        //inizioLabel.text = "Start: 0"
        
        let frame = CGRect(x: view.center.x / 2, y: 70, width: 300, height: 35)
        inizioLabel = UILabel(frame: frame)
        inizioLabel?.text = "Start: 0"
        inizioLabel?.textColor = UIColor.white
        inizioLabel?.textAlignment = .center
        inizioLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        inizioLabel?.center.x = view.center.x / 2
        
        view.addSubview(inizioLabel!)
        
        
        let frameFine = CGRect(x: view.center.x / 2, y: 135, width: 300, height: 35)
        fineLabel = UILabel(frame: frameFine)
        fineLabel?.text = "Finish: 0"
        fineLabel?.textColor = UIColor.white
        fineLabel?.textAlignment = .center
        fineLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        fineLabel?.center.x = view.center.x / 2
        
        view.addSubview(fineLabel!)
        
        sliderFine = addStartSlider(selector: #selector(valueChangedOfSliderFine(slider:)), y: 175)
        view.addSubview(sliderFine!)
        
        var frameDurata : CGRect?
        
        let iPhoneModel = UIDevice.current.modelName
        
        switch iPhoneModel {
        case "iPhone 5s", "iPhone 5", "iPhone 5c", "iPhone SE":
            frameDurata = CGRect(x: view.center.x / 2, y: 330, width: 300, height: 35)
        case "iPhone 6", "iPhone 6s", "iPhone 7":
            frameDurata = CGRect(x: view.center.x / 2, y: 345, width: 300, height: 35)
        default:
            frameDurata = CGRect(x: view.center.x / 2, y: 300, width: 300, height: 35)
        }
        
        
        durataLabel = UILabel(frame: frameDurata!)
        durataLabel?.text = "Duration: 0"
        durataLabel?.textColor = UIColor.white
        durataLabel?.textAlignment = .center
        durataLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        durataLabel?.center.x = view.center.x
        view.addSubview(durataLabel!)
        
        view.addSubview(buttonForOpenFadeSettings)
        
        let urlMusicString = UserDefaults.standard.string(forKey: "urlSonginCache")
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlMusicString!))
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            
            
            sliderInizio?.maximumValue = Float((audioPlayer?.duration)!)
            sliderFine?.maximumValue = Float((audioPlayer?.duration)!)
            
            
        }
        catch {
            print("Errore audioPlayer: \(error)")
        }
        
        
        view.addSubview(exportButton)
        
        view.addSubview(backButton)
        
        secondsStart = 0
        secondsFinish = Int((sliderInizio?.value)! + Float(40))
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSeconds), userInfo: nil, repeats: true)
        
        currentTimeLabel = addLabal()
        view.addSubview(currentTimeLabel!)
        currentTimeLabel?.text = "00:00"
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stopMusic), userInfo: nil, repeats: true)
    }
    
    @objc func stopMusic() {
        if Int(currentTime!) >= secondsFinish {
            audioPlayer?.stop()
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stopMusic), userInfo: nil, repeats: true)
        }
        
    }
    
    var currentTime : Double?
    var timer : Timer?
    var currentTimeLabel : UILabel?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateSeconds() {
        currentTime = audioPlayer?.currentTime
        let seconds = Int(currentTime!.truncatingRemainder(dividingBy: 60.0))
        let minutes = Int(currentTime! / 60)
        if minutes < 10 && seconds < 10 {
            print("0\(minutes):0\(seconds)")
            currentTimeLabel?.text = "0\(minutes):0\(seconds)"
        }
        else if minutes < 10 {
            print("0\(minutes):\(seconds)")
            currentTimeLabel?.text = "0\(minutes):\(seconds)"
        }
        else if seconds < 10 {
            print("\(minutes):0\(seconds)")
            currentTimeLabel?.text = "\(minutes):0\(seconds)"
        }
        else {
            print("\(minutes):\(seconds)")
            currentTimeLabel?.text = "\(minutes):\(seconds)"
        }
    }
    
}

