//
//  EditorVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 08/04/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class EditorVC : RTEditorViewController {
    
    lazy var backButton : UIBarButtonItem = {
        let b = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(dismissVC))
        return b
    }()
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(backButton, animated: true)
        
        editorViewTitleSongColor = UIColor.darkGray
        editorViewContainerStartSongColor = UIColor.darkGray.darker(by: 10)
        editorViewContainerDurationSongColor = UIColor.darkGray.darker(by: 10)
        editorViewColor = UIColor.darkGray.darker(by: 17)
        editorPlayerViewColor = UIColor.darkGray.darker(by: 17)
        
        
    }
}
