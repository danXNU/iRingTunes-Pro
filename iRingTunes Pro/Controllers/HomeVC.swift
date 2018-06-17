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


    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.createButton?.addTarget(self, action: #selector(createRingtone), for: .touchUpInside)
        homeView.managerButton?.addTarget(self, action: #selector(openManager), for: .touchUpInside)
    }

    var homeView = HomeView()
    override func loadView() {
        super.loadView()
        self.view = self.homeView
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc private func createRingtone() {
        let picker = MPMediaPickerController(mediaTypes: .anyAudio)
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        picker.showsCloudItems = false
        
        picker.showsItemsWithProtectedAssets = false
        
        present(picker, animated: true, completion: nil)
    }

    @objc private func openManager() {
        let vc = RTManagerVC()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
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
