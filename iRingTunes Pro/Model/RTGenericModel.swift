//
//  RTGenericModel.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation
import AVFoundation

class RTGenericModel {
    
    public func getFiles(from path: String, withFilter filter: ((String) -> Bool)? = nil, errorHandler: ((Int) -> Void)? = nil) -> [String] {
        let fl = FileManager.default
        guard let files = try? fl.contentsOfDirectory(atPath: path) else { print("ERROR: getFiles"); errorHandler?(1); return [] }
    
        if let filterCode = filter {
            return files.filter({ filterCode($0) })
        }
        return files
    }
    
    
    public func getSong(fromName name: String) -> RTPlayerSong {
        let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = offset.appending("/\(name)")
        let url = URL(fileURLWithPath: path)
        
        let asset = AVAsset(url: url)
        let duration = asset.duration.seconds
        
        let song = RTPlayerSong(duration: duration, title: name)
        return song
    }
    
}
