//
//  RTManagerSongInfoVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class RTManagerSongInfoVC: UIViewController {

    let managerInfoView = RTManagerSongInfoView()
    let model = RTGenericModel()
    
    var songName : String? {
        didSet {
            if let name = songName {
                managerInfoView.titleLabel.text = name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ringtone"
        
        managerInfoView.shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        managerInfoView.removeButton.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
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

    override func loadView() {
        super.loadView()
        self.view = managerInfoView 
    }

}
