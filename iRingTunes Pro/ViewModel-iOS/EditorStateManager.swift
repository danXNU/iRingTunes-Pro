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
    
    var exportManager: ExportManager = ExportManager()
    
    var outputURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(exportName).m4r")
    }
    
    
}
