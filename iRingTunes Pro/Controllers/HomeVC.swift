//
//  HomeVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 08/04/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.createButton?.addTarget(self, action: #selector(createButtonPressed(_:)), for: .touchUpInside)
        homeView.managerButton?.addTarget(self, action: #selector(openManagerButtonPressed), for: .touchUpInside)
    }

    var homeView = HomeView()
    override func loadView() {
        super.loadView()
        self.view = self.homeView
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    @objc private func createButtonPressed(_ sender: UIButton) {
        //DA LOCALIZZARE
        let alert = UIAlertController(title: "Source", message: "Da qualche sorgente vuoi prendere la musica?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Files", style: .default) { (action) in
            self.showFilesViewer()
        }
        let action2 = UIAlertAction(title: "Music Library", style: .default) { (action) in
            DispatchQueue.main.async {
                self.showMusicPicker()
            }
        }
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.minY, width: 0, height: 0)
        alert.popoverPresentationController?.permittedArrowDirections = .up
        
        present(alert, animated: true)
        
    }

    private func showFilesViewer() {
        let types: [String] = [
            kUTTypeMP3 as String,
            kUTTypeMPEG4Audio as String
        ]
        let vc = UIDocumentPickerViewController(documentTypes: types, in: .import)
        vc.delegate = self
        if #available(iOS 11.0, *) {
            vc.allowsMultipleSelection = false
        } else {
            // Fallback on earlier versions
        }
        self.present(vc, animated: true)
    }
    
    private func showMusicPicker() {
        let picker = MPMediaPickerController(mediaTypes: .anyAudio)
        picker.delegate = self
        picker.allowsPickingMultipleItems = false
        picker.showsCloudItems = false
        
        picker.showsItemsWithProtectedAssets = false
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func openManagerButtonPressed() {
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

extension HomeVC: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let songName = url.lastPathComponent
        
        let vc = EditorVC()
        vc.songName = songName
        vc.selectedSongUrl = url

        let nav = UINavigationController(rootViewController: vc)
        
//        dismiss(animated: true) {
            DispatchQueue.main.async {
                self.present(nav, animated: true)
            }
//        }
        
    }
}
