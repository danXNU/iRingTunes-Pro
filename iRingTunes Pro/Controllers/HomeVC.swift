//
//  HomeVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 08/04/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import MediaPlayer

class HomeVC: UIViewController {

    
    lazy var createButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = UIColor.darkGray.darker(by: 15)
        b.setTitle("Create", for: .normal)
        b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        b.titleLabel?.textColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 10
        b.addTarget(self, action: #selector(createRingtone), for: .touchUpInside)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        view.addSubview(createButton)
        [ createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          createButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
          createButton.widthAnchor.constraint(equalToConstant: 120),
          createButton.heightAnchor.constraint(equalToConstant: 60) ].forEach({ $0.isActive = true })
    }

    
    @objc private func createRingtone() {
        let picker = MPMediaPickerController(mediaTypes: .anyAudio)
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        present(picker, animated: true, completion: nil)
    }

}

extension HomeVC: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        guard let nameSong = mediaItemCollection.items.first!.title else { return }
        guard let url = mediaItemCollection.items.first!.assetURL else { return }
        
        let vc = EditorVC()
        vc.songName = nameSong
        vc.selectedSongUrl = url
        
        
        let nav = UINavigationController(rootViewController: vc)
        
        dismiss(animated: true) {
            DispatchQueue.main.async {
                self.present(nav, animated: true, completion: nil)
            }
        }
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}
