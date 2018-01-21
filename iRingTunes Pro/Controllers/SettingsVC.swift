//
//  SettingsVC.swift
//  iRingTunes Lite
//
//  Created by Dani Tox on 06/07/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    var imageView : UIImageView {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = #imageLiteral(resourceName: "dark")
        return imageView
    }
    
    var backButton : UIButton {
        let frame = CGRect(x: 10, y: view.frame.maxY - 60, width: 100, height: 50)
        let button = UIButton(frame: frame)
        button.setTitle("Back", for: .normal)
        button.backgroundColor = UIColor.darkGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.titleLabel?.textColor = UIColor.white
        button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var clearCacheButton : UIButton {
        let frame = CGRect(x: 0, y: view.center.y - 50, width: 250, height: 60)
        let button = UIButton(frame: frame)
        button.center.x = view.center.x
        
        
        button.backgroundColor = UIColor.blue
        button.setTitle("Clear cache", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        button.titleLabel?.textColor = UIColor.white
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
        
        return button
    }
    
    
    @objc func clearCache() {
        let fileManager = FileManager()
        let offset = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        
        do {
        let files = try fileManager.contentsOfDirectory(atPath: offset)
            print("File prima della pulizia: \(files)")
            
            for file in files {
                if file != "Snapshots" {
                    print("Elimino questo file: \(file)")
                    try fileManager.removeItem(atPath: offset.appending("/\(file)"))
                }
            }
            print("File dopo la pulizia: \(files)")
            
            let newFiles = try fileManager.contentsOfDirectory(atPath: offset)
            if newFiles.count == 1 {
                let alert = UIAlertController(title: "Cache cleared", message: "The cache has been cleared successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Cache Error", message: "There was an error when clearing the cache. Try to close and reopen the app and retry", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        catch {
            print("Errore cache: \(error)")
        }
        
    }
    

    
    var setFadeInButton : UIButton {
        let frame = CGRect(x: 200, y: self.view.frame.height / 2 + 30, width: 250, height: 70)
        let button = UIButton(frame: frame)
        button.center.x = self.view.center.x
        
        
        button.setTitle("Set Fade In duration", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.orange
        
        button.addTarget(self, action: #selector(openSlider), for: .touchUpInside)
        
        return button
    }

    var blurView : UIView {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor.clear
        
        let blurEff = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEff)
        blurView.frame = view.frame
        
        view.addSubview(blurView)
        
        var escButton : UIButton {
            let button = UIButton(frame: self.view.frame)
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
            
            return button
        }
        
        view.addSubview(escButton)
        
        view.tag = 100
        return view
        
    }
    
    @objc func dismissView() {
        for subview in self.view.subviews {
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }
    
    @objc func openSlider () {
        self.view.addSubview(blurView)
        self.view.addSubview(slider!)
        self.view.addSubview(fadeIndicatorLabel!)
        
        fadeDuration = UserDefaults.standard.integer(forKey: "fadeInDuration")
        slider?.value = Float(fadeDuration)
    }

    
    var fadeDuration : Int = UserDefaults.standard.integer(forKey: "fadeInDuration") {
        didSet {
            UserDefaults.standard.set(fadeDuration, forKey: "fadeInDuration")
            print(fadeDuration)
            fadeIndicatorLabel?.text = "\(fadeDuration)"
        }
    }
    
    var slider : UISlider?
    var fadeIndicatorLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(backButton)
        view.addSubview(clearCacheButton)
        
        setupViews()

        view.addSubview(setFadeInButton)
        
        
        
    }
    
    @objc func changeFadeSliderValue(sender: UISlider) {
        fadeDuration = Int(sender.value)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViews() {
        slider = UISlider(frame: CGRect(x: 20, y: view.center.y, width: view.frame.width - 40, height: 50))
        slider?.maximumValue = 10
        slider?.minimumValue = 0
        slider?.addTarget(self, action: #selector(changeFadeSliderValue(sender:)), for: .valueChanged)
        
        fadeIndicatorLabel = UILabel(frame: CGRect(x: Int(view.center.x), y: Int((slider?.center.y)! - 80), width: 100, height: 50))
        fadeIndicatorLabel?.center.x = view.center.x
        fadeIndicatorLabel?.text = "\(UserDefaults.standard.integer(forKey: "fadeInDuration"))"
        fadeIndicatorLabel?.backgroundColor = UIColor.blue
        fadeIndicatorLabel?.textColor = UIColor.white
        fadeIndicatorLabel?.layer.masksToBounds = true
        fadeIndicatorLabel?.layer.cornerRadius = 10
        fadeIndicatorLabel?.textAlignment = .center
        fadeIndicatorLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        
        fadeIndicatorLabel?.tag = 100
        slider?.tag = 100
        blurView.tag = 100
        
        
    }
}

