//
//  LibraryFile.swift
//  iRingTunes Pro
//
//  Created by danxnu on 21/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import Foundation

struct LibraryFile {
    var title: String
    var assetURL: URL
}

struct LibraryObject {
    var url: URL
    var modificationDate: Date
    
    var name: String {
        url.lastPathComponent
    }
}
