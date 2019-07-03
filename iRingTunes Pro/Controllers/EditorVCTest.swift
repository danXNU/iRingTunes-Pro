//
//  EditorVC.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 13/02/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class EditorVCTest: UIViewController {
    
    var heightContainer : NSLayoutConstraint!
    var containerView : UIView!
    var blurView : UIVisualEffectView!
    
    var feedbackGenerator : UIImpactFeedbackGenerator?
    
    var vibrated : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Editor"
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            setViews()
        }
        
        
        
    }



}

extension EditorVCTest {
    
    @available(iOS 11.0, *)
    func setViews() {
        let backgroundView = UIImageView(image: #imageLiteral(resourceName: "dark"))
        view.addSubview(backgroundView)
        backgroundView.fillSuperview()
        
        
        let effect = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: effect)
        blurView.alpha = 0
        let tapView = UITapGestureRecognizer(target: self, action: #selector(tapBlur))
        blurView.addGestureRecognizer(tapView)
        view.addSubview(blurView)
        blurView.fillSuperview()
        
        
        let holdRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(holdView))
        holdRecognizer.minimumPressDuration = 0.3
        containerView = UIView()
        containerView.backgroundColor = .orange
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 20
        containerView.addGestureRecognizer(holdRecognizer)
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.safeAreaLayoutGuide.leadingAnchor,
                             bottom: nil,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor,
                             padding: .init(top: 20, left: 20, bottom: 0, right: 20),
                             size: .zero)
        heightContainer = containerView.heightAnchor.constraint(equalToConstant: 200)
        heightContainer.isActive = true
        
        
        feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator?.prepare()
        
        
        let navButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = navButton
    }
    
    @objc private func cancel() {
        feedbackGenerator = nil
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func holdView() {
        heightContainer.isActive = false
        heightContainer = containerView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height - 80)
        heightContainer.isActive = true
        
        vibrate()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @objc private func tapBlur() {
        heightContainer.isActive = false
        heightContainer = containerView.heightAnchor.constraint(equalToConstant: 200)
        heightContainer.isActive = true
        
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (completed) in
            self.vibrated = false
        })
    }
    
    private func vibrate() {
        if vibrated == false {
            feedbackGenerator?.impactOccurred()
            vibrated = true
        }
    }
    
}
