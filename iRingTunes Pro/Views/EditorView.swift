//
//  EditorView.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 14/02/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class EditorView: UIView {
    
    weak var delegate : EditorViewDelegate!
    
    var totalSongDuration : Float = 0 {
        didSet {
            startTimeSlider.maximumValue = totalSongDuration
        }
    }
    
    private var startTimeSlider : UISlider!
    private var durationTimeSlider : UISlider!
    
    var titleLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditorView {
    private func initViews() {
        self.backgroundColor = .red
        
        let holdGR = UILongPressGestureRecognizer(target: self, action: #selector(holded(sender: )))
        holdGR.minimumPressDuration = 0.3
        addGestureRecognizer(holdGR)
        

        titleLabel = UILabel()
        titleLabel.text = "Untitled"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.backgroundColor = .orange
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10
        addSubview(titleLabel)
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor,
                          leading: safeAreaLayoutGuide.leadingAnchor,
                          bottom: nil,
                          trailing: safeAreaLayoutGuide.trailingAnchor,
                          padding: .init(top: 5, left: 20, bottom: 0, right: 20),
                          size: .init(width: 0, height: 30))
        
       
        
        let startTimeLabel = UILabel()
        startTimeLabel.textAlignment = .center
        startTimeLabel.text = "ASD"
        startTimeLabel.backgroundColor = .clear
        addSubview(startTimeLabel)
        
        
        
        startTimeSlider = UISlider()
        startTimeSlider.backgroundColor = .clear
        addSubview(startTimeSlider)
//        startTimeSlider.anchor(top: titleLabel.bottomAnchor,
//                               leading: safeAreaLayoutGuide.leadingAnchor,
//                               bottom: nil,
//                               trailing: safeAreaLayoutGuide.trailingAnchor,
//                               padding: .init(top: 7, left: 20, bottom: 0, right: 20),
//                               size: .init(width: 0, height: 50))
        
        
        let stackView = UIStackView(arrangedSubviews: [startTimeLabel, startTimeSlider])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        //addSubview(stackView)
        
        
        let startContainerView = UIView()
        startContainerView.backgroundColor = .gray
        startContainerView.layer.masksToBounds = true
        startContainerView.layer.cornerRadius = 10
        addSubview(startContainerView)
        startContainerView.layer.shadowColor = UIColor.black.cgColor
        startContainerView.layer.shadowRadius = 10
        startContainerView.layer.shadowOffset = .zero
        startContainerView.layer.shadowOpacity = 1
        startContainerView.addSubview(stackView)
        startContainerView.anchor(top: titleLabel.bottomAnchor,
                         leading: leadingAnchor,
                         bottom: nil,
                         trailing: trailingAnchor,
                         padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 70))
        stackView.anchor(top: startContainerView.topAnchor,
                         leading: startContainerView.leadingAnchor,
                         bottom: startContainerView.bottomAnchor,
                         trailing: startContainerView.trailingAnchor,
                         padding: .init(top: 0, left: 15, bottom: 10, right: 15),
                         size: .zero)
        
        startTimeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    
    @objc private func holded(sender : UIGestureRecognizer) {
        print("holding...")
        if sender.state == .began {
            delegate?.viewIsHolded?(view: self)
            print("SENDING delegate msg")
        }
        
    }
}

@objc protocol EditorViewDelegate {
    @objc optional func viewIsHolded(view: UIView)
}