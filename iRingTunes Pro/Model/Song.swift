//
//  Song.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 13/02/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation
import CoreMedia

struct SongAttributes {
    var songName : String
    var timeRange : CMTimeRange?
    var startFade: Int?
    var durationFade : Int?
}

class Song {
    var title : String
    var url : URL
    
    init(title: String, url : URL) {
        self.title = title
        self.url = url
    }
}


enum SongState {
    case paused
    case playing
    case stopped
}
