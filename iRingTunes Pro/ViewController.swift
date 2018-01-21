//
//  ViewController.swift
//  iRingTunes Lite
//
//  Created by Dani Tox on 06/07/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//


import UIKit
import MediaPlayer

class ViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    var imageView : UIImageView {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = #imageLiteral(resourceName: "dark")
        return imageView
    }
    
    var titleLabel : UILabel {
        let iPhoneVersion = UIDevice.current.modelName
        var frame : CGRect?
        
        switch iPhoneVersion {
        case "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE":
            frame = CGRect(x: view.center.x, y: 40, width: 300, height: 70)
        case "iPhone 6", "iPhone 6s", "iPhone 7":
            frame = CGRect(x: view.center.x, y: 40, width: 280, height: 70)
        default:
            frame = CGRect(x: view.center.x, y: 40, width: 320, height: 70)
        }
        
        
        let label = UILabel(frame: frame!)
        label.backgroundColor = UIColor.red
        label.text = "iRingTunes v1.0"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.center.x = view.center.x
        return label
    }
    
    var creaSuoneriaButton : UIButton {
        let frame = CGRect(x: view.center.x, y: view.center.y, width: 280, height: 90)
        let button = UIButton(frame: frame)
        button.setTitle("Create Ringtone", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 34)
        button.titleLabel?.textColor = UIColor.white
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 10
        button.center = view.center
        button.addTarget(self, action: #selector(createSuoneria), for: .touchUpInside)
        return button
    }
    
    @objc func createSuoneria() {
        let selectMusicController = MPMediaPickerController(mediaTypes: .anyAudio)
        selectMusicController.allowsPickingMultipleItems = false
        selectMusicController.delegate = self
        present(selectMusicController, animated: true, completion: nil)
    }
    
    var gestioneSuonerieButton : UIButton {
        let frame = CGRect(x: view.center.x, y: view.center.y + 65, width: 280, height: 50)
        let button = UIButton(frame: frame)
        button.center.x = view.center.x
        button.backgroundColor = UIColor.darkGray
        button.layer.cornerRadius = 10
        button.setTitle("Ringtones Manager", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(openRManager), for: .touchUpInside)
        return button
    }
    
    @objc func openRManager() {
        let vc = RingotnesManagerVC()
        present(vc, animated: true, completion: nil)
    }
    
    var settingsButton : UIButton {
        let frame = CGRect(x: view.frame.maxX - 110, y: view.frame.maxY - 60, width: 100, height: 50)
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Settings", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor.white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        return button
    }
    
    @objc func openSettings() {
        let vc = SettingsVC()
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(creaSuoneriaButton)
        view.addSubview(gestioneSuonerieButton)
        view.addSubview(settingsButton)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        for subView in view.subviews {
            if subView.tag == 100 {
                subView.removeFromSuperview()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        dismiss(animated: true, completion: nil)
        
        var labelExporting : UILabel {
            let frame = CGRect(x: view.center.x, y: view.center.y, width: 200, height: 50)
            let label = UILabel(frame: frame)
            label.font = UIFont.boldSystemFont(ofSize: 25)
            label.textColor = UIColor.orange
            label.text = "Exporting..."
            label.textAlignment = .center
            label.center.x = view.center.x + 10
            label.center.y = view.center.y - 70
            return label
        }
        
        var loadingView : UIActivityIndicatorView {
            let actView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            actView.center = self.view.center
            actView.color = UIColor.orange
            actView.startAnimating()
            return actView
        }
        
        var blurView : UIView {
            let frame = self.view.frame
            let viewS = UIView(frame: frame)
            viewS.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = viewS.frame
            viewS.addSubview(blurView)
            viewS.tag = 100
            
            blurView.contentView.addSubview(loadingView)
            blurView.contentView.addSubview(labelExporting)
            return viewS
        }
        
        self.view.addSubview(blurView)
        
        
        let urlMusic = mediaItemCollection.items.first?.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        
        let musicName = mediaItemCollection.items.first?.title
        
        let exporturlString = directory(Sys_directory: .cachesDirectory).appending("/\(musicName!).m4a")
        
        deleteFileAt(path: exporturlString as NSString)
        
        let exportURL = urlMusic!
        
        let asset = AVAsset(url: exportURL)
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputFileType = AVFileType.m4a
        exporter?.outputURL = URL(fileURLWithPath: exporturlString)
        
        print(exporter?.outputURL ?? "Error exporter.outputurl")
        
        exporter?.exportAsynchronously(completionHandler: {
            let exporterStatus = exporter?.status
            switch (exporterStatus!) {
            case .completed:
                print("Completato")
                DispatchQueue.main.async {
                    for subView in self.view.subviews {
                        if subView.tag == 100 {
                            subView.removeFromSuperview()
                        }
                    }
                    UserDefaults.standard.set(exporturlString, forKey: "urlSonginCache")
                    UserDefaults.standard.set(musicName, forKey: "musicName")
                    let vc = EditSongVC()
                    self.present(vc, animated: true, completion: nil)
                }
                
            case .failed:
                print("Errore: \(String(describing: exporter?.error))")
            case .unknown:
                print("Erroe sconosciuto: \(String(describing: exporter?.error))")
            default:
                print("Qualche altro errore: \(String(describing: exporter?.error))")
            }
        })
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("Nessuna musica scelta")
        self.dismiss(animated: true, completion: nil)
    }
    
    func directory (Sys_directory: FileManager.SearchPathDirectory) -> NSString {
        let dir = NSSearchPathForDirectoriesInDomains(Sys_directory, .userDomainMask, true).first! as NSString
        return dir
    }
    
    func deleteFileAt(path: NSString) {
        let fileManager = FileManager()
        
        
        print("DELETE FILE: path: \(path)")
        
        if fileManager.fileExists(atPath: path as String) {
            
            do {
                try fileManager.removeItem(atPath: path as String)
                print("File eliminato con successo!")
            }
            catch {
                print("Errore nell'eliminare il file: \(error)")
            }
            
            
        }
        else {
            print("Il file non esiste quindi proseguo...")
        }
    }
}


