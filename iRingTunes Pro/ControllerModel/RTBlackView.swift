//
//  RTBlackView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class RTBlackView: UIView {
    
    let gradient = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        reloadGradient()
        self.layer.addSublayer(gradient)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadGradient() {
        gradient.colors = [UIColor.black.cgColor, UIColor.darkGray.darker(by: 15)!.cgColor]
        gradient.frame = self.frame
    }
    
    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        reloadGradient()
        
    }
    
}
