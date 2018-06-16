//
//  RTManagerSongInfoVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import AVFoundation

class RTManagerSongInfoVC: UIViewController, UITextFieldDelegate, AVAudioPlayerDelegate {

    let managerInfoView = RTManagerSongInfoView()
    let model = RTGenericModel()
    
    var songName : String? {
        didSet {
            if let name = songName {
                managerInfoView.titleLabel.text = name
            }
        }
    }
    
    let renameTextField = UITextField()
    var ycon = NSLayoutConstraint()
    var containerView : UIVisualEffectView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ringtone"
        
        managerInfoView.shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        managerInfoView.removeButton.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        managerInfoView.renameButton.addTarget(self, action: #selector(renameAction), for: .touchUpInside)
        managerInfoView.playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        
        initUI()
        
        createPlayer()
    }
    
    private func createPlayer() {
        guard let songTitle = songName else { return }
        let url = URL(fileURLWithPath: model.getPath(fromName: songTitle))
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
    }
    
    
    var audioPlayer : AVAudioPlayer?
    @objc private func playAction() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
            audioPlayer = nil
            managerInfoView.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            createPlayer()
            audioPlayer?.play()
            managerInfoView.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        
    }
    
    @objc private func removeAction() {
        let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = offset.appending("/\(songName ?? "")")
        let fl = FileManager.default
        do {
            try fl.removeItem(atPath: path)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc private func shareAction() {
        if let name = songName {
            let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let path = offset.appending("/\(name)")
            let url = URL(fileURLWithPath: path)
            
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityVC, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Errore", message: "Errore file", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    @objc private func renameAction() {
        renameTextField.text = songName
        ycon.isActive = false
        ycon = renameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20)
        ycon.isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 0.85
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.renameTextField.becomeFirstResponder()
            self.renameTextField.selectedTextRange = self.renameTextField.textRange(from: self.renameTextField.beginningOfDocument, to: self.renameTextField.endOfDocument)
        })
        //model.rename(file: , with: )
    }
    @objc private func containerTouched() {
        dismissContainerView(save: false)
    }

    private func dismissContainerView(save: Bool) {
        renameTextField.resignFirstResponder()
        ycon.isActive = false
        ycon = renameTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80)
        ycon.isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            if save {
               self.realRenameAction()
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        dismissContainerView(save: true)
        return false
    }
    
    private func realRenameAction() {
        if let newName = renameTextField.text, let origName = songName {
            model.rename(file: origName, with: newName, completion: { [weak self] in
                var newName_d = newName
                if !newName_d.hasSuffix(".m4r") { newName_d.append(".m4r")}
                self?.songName = newName_d
            }, errorHandler: { (errorMsg) in
                let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            })
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = managerInfoView 
    }

    
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        managerInfoView.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        audioPlayer = nil
        
    }
    
    
    
    
    
    fileprivate func initUI() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(containerTouched))
        
        let effect = UIBlurEffect(style: .dark)
        containerView = UIVisualEffectView(effect: effect)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.alpha = 0
        containerView.addGestureRecognizer(gesture)
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
        renameTextField.translatesAutoresizingMaskIntoConstraints = false
        renameTextField.text = songName
        renameTextField.borderStyle = .roundedRect
        renameTextField.textColor = .white
        renameTextField.backgroundColor = UIColor.black
        renameTextField.returnKeyType = .done
        renameTextField.delegate = self
        view.addSubview(renameTextField)
        renameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        renameTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        renameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ycon = renameTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80)
        ycon.isActive = true
    }
    
    
    
}
