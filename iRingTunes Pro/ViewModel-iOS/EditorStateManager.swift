//
//  EditorStateManager.swift
//  iRingTunes Pro
//
//  Created by danxnu on 22/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import Foundation

class EditorStateManager: ObservableObject {
    @Published var exportName: String = ""
    @Published var isExporting: Bool = false
//    @Published var exportState: ExportState?
    
    var exportManager: ExportManager = ExportManager()
    
    
//    enum ExportState: Identifiable {
//        case exporting(ExportManager)
//
//        var id: String {
//            String(describing: self)
//        }
//    }
}
