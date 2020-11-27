//
//  ShareSheetView.swift
//  iRingTunes Pro
//
//  Created by danxnu on 27/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import SwiftUI

struct ShareSheetView: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
