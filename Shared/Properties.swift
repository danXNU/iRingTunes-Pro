//
//  Properties.swift
//  TunesWaveTest
//
//  Created by danxnu on 13/11/20.
//

import Foundation

var alreadyAskedForReview: Bool {
    get {
        UserDefaults.standard.bool(forKey: "alreadyAskedForReview")
    } set {
        UserDefaults.standard.set(newValue, forKey: "alreadyAskedForReview")
    }
}
