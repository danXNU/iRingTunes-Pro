//
//  TouchView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 16/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class TouchView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchDown()
//        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchUp()
        super.touchesEnded(touches, with: event)
//        self.next?.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        onTouchUp()
        super.touchesCancelled(touches, with: event)
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
