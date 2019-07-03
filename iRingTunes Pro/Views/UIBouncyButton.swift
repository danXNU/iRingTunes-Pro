//
//  UIBouncyButton.swift
//  DonBoscoApp
//
//  Created by Dani Tox on 24/03/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit


class UIBouncyButton: UIButton {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let ret = super.beginTracking(touch, with: event)
        
        if ret {
            onTouchDown()
        }
        
        return ret
    }
    
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        onTouchUp()
        super.endTracking(touch, with: event)
    }
    
    
    override func cancelTracking(with event: UIEvent?) {
        onTouchUp()
        super.cancelTracking(with: event)
    }
    
    
    func onTouchDown() {
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 2.0,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: { () -> Void in
                        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    
    func onTouchUp() {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 3.0,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: { () -> Void in
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
}
