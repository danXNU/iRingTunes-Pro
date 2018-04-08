//
//  HomeVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 13/02/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

/*
import UIKit
import MediaPlayer

class HomeVC_OLD: UIViewController {

    var createButton : UIButton!
    var managerButton : UIButton!
    
    
    var songSelected : Song?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }

    
    
}

extension HomeVC_OLD : MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        guard let nameSong = mediaItemCollection.items.first!.title else { return }
        guard let url = mediaItemCollection.items.first!.assetURL else { return }
        
        songSelected = Song(title: nameSong, url: url)
        dismiss(animated: true) {
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    let vc = EditorVC_OLD()
                } else {
                    // Fallback on earlier versions
                }
                let navigationVC = UINavigationController(rootViewController: vc)
                self.present(navigationVC, animated: true, completion: nil)
            }
        }
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true)
    }
}


extension HomeVC_OLD {
    
    func setViews() {
     
        let backgroundView = UIImageView(image: #imageLiteral(resourceName: "dark"))
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.text = "iRingTunes Pro"
        titleLabel.textAlignment = .center
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .red
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 30, left: 30, bottom: 0, right: 30),
                          size: .init(width: 0, height: 60))
        
        
        
        createButton = UIButton()
        createButton.setTitle("Create", for: .normal)
        createButton.backgroundColor = .orange
        createButton.titleLabel?.textColor = .white
        createButton.titleLabel?.textAlignment = .center
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        createButton.addTarget(self, action: #selector(createButtonTouched), for: .touchUpInside)
        
        
        managerButton = UIButton()
        managerButton.setTitle("Manager", for: .normal)
        managerButton.backgroundColor = .gray
        managerButton.titleLabel?.textColor = .white
        managerButton.titleLabel?.textAlignment = .center
        managerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        
        [createButton, managerButton].forEach({ $0.layer.cornerRadius = 20 })
        
        let stackView = UIStackView(arrangedSubviews: [createButton, managerButton])
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .zero, size: .init(width: 300, height: 280))
        
    }
    
    @objc private func createButtonTouched() {
        let mediaPicker = MPMediaPickerController(mediaTypes: .music)
        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = false
        present(mediaPicker, animated: true)
    }
}
*/
