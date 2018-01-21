//
//  TutorialVC.swift
//  iRingTunes Lite
//
//  Created by Dani Tox on 06/07/17.
//  Copyright © 2017 Dani Tox. All rights reserved.
//

import UIKit
import AVFoundation

class TutorialVC: UIViewController, UIWebViewDelegate {
    
    var imageView : UIImageView {
        let imageView = UIImageView(frame: view.frame)
        imageView.image = #imageLiteral(resourceName: "dark")
        return imageView
    }
    
    var titleLabel : UILabel {
        var frame : CGRect?
        let iPhoneVersion = UIDevice.current.modelName
        
        switch iPhoneVersion {
        case "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s", "iPhone SE":
            frame = CGRect(x: view.center.x, y: 20, width: 300, height: 70)
        default:
            frame = CGRect(x: view.center.x, y: 20, width: 320, height: 70)
        }
        let label = UILabel(frame: frame!)
        
        label.center.x = view.center.x
        label.backgroundColor = UIColor.red
        label.text = "Tutorial"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        
        return label
    }
    
    var backButton : UIButton {
        let frame = CGRect(x: 10, y: view.frame.maxY - 60, width: 100, height: 50)
        let button = UIButton(frame: frame)
        
        button.backgroundColor = UIColor.darkGray
        button.setTitle("Back", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 27)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        return button
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        
        let safariView = UIWebView(frame: CGRect(x: 0, y: 105, width: self.view.frame.width, height: self.view.frame.height - (60 + 105 + 10)))
        let request = URLRequest(url: URL(string: "http://ipswdownloaderpy.altervista.org/iRingTunes/Tutorial.html")!)
        
        safariView.delegate = self
        safariView.scalesPageToFit = true
        
        view.addSubview(safariView)
        safariView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("error: \(error)")
    }
    
    
}
