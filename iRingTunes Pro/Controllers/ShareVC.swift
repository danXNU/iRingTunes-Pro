//
//  ShareVC.swift
//  iRingTunes Lite
//
//  Created by Dani Tox on 06/07/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class ShareVC: UIViewController {
    
    var imageView : UIImageView {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = #imageLiteral(resourceName: "dark")
        return imageView
    }
    
    var shareButton : UIButton {
        let frame = CGRect(x: view.center.x, y: view.center.y - 110 , width: 200, height: 100)
        let button = UIButton(frame: frame)
        button.center.x = view.center.x
        
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        button.backgroundColor = UIColor.orange
        button.titleLabel?.textColor = UIColor.white
        button.layer.cornerRadius = 10
        
        return button
        
    }
    
    @objc func share() {
        present(activityController!, animated: true)
    }
    
    var activityController : UIActivityViewController?
    
    var finishButton : UIButton {
        let frame = CGRect(x: view.center.x, y: view.center.y + 10 , width: 200, height: 100)
        let button = UIButton(frame: frame)
        button.center.x = view.center.x
        //button.center.y = view.center.y + 130
        button.setTitle("Finish", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        button.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.textColor = UIColor.white
        button.layer.cornerRadius = 10
        
        return button
    }
    
    @objc func finishAction() {
        let vc = ViewController()
        present(vc, animated: true, completion: nil)
    }
    
    var backButton : UIButton {
        let frame = CGRect(x: 10, y: view.frame.maxY - 70, width: 80, height: 40)
        let button = UIButton(frame: frame)
        
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.backgroundColor = UIColor.gray
        button.titleLabel?.textColor = UIColor.white
        button.layer.cornerRadius = 10
        
        return button
    }
    
    @objc func backAction() {
        let vc = EditSongVC()
        present(vc, animated: true, completion: nil)
    }
    
    var processCompletedLabel : UILabel {
        let iPhoneVersion = UIDevice.current.modelName
        var frame : CGRect?
        
        switch iPhoneVersion {
        case "iPhone 4s", "iPhone 5", "iPhone 5s", "iPhone 5c", "iPhone SE":
            frame = CGRect(x: 10, y: 20, width: view.frame.width - 20, height: 100)
        default:
            frame = CGRect(x: 10, y: 30, width: view.frame.width - 20, height: 120)
        }
        
        let label = UILabel(frame: frame!)
        switch iPhoneVersion {
        case "iPhone 4s", "iPhone 5", "iPhone 5s", "iPhone 5c", "iPhone SE":
            label.font = UIFont.boldSystemFont(ofSize: 20)
        default:
            label.font = UIFont.boldSystemFont(ofSize: 27)
        }
        
        label.backgroundColor = UIColor.init(red:0.13, green:0.47, blue:0.03, alpha:1.0)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Ringtone successfully created! Now follow the tutorial if you don't know how to go ahead"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }
    
    var tutorialButton : UIButton {
        let frame = CGRect(x: view.frame.maxX - 220, y: view.frame.maxY - 70, width: 210, height: 40)
        let button = UIButton(frame: frame)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 10
        button.setTitle("Tutorial", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        button.addTarget(self, action: #selector(tutorialAction), for: .touchUpInside)
        return button
    }
    
    @objc func tutorialAction() {
        let vc = TutorialVC()
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UserDefaults.standard.url(forKey: "FinalURL")
        activityController = UIActivityViewController(activityItems: [item!], applicationActivities: nil)
        
        
        view.addSubview(imageView)
        view.addSubview(shareButton)
        view.addSubview(finishButton)
        view.addSubview(backButton)
        view.addSubview(processCompletedLabel)
        
        view.addSubview(tutorialButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

