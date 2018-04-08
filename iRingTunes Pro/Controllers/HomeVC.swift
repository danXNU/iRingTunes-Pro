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
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(createButton)
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
        
        
        
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
    }
}
