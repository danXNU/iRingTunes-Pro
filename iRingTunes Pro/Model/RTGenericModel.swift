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
    
    
    public func getPath(fromName name: String) -> String {
        let offset = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        if name == "$DOC$" {
            return offset
        } else {
            return offset.appending("/\(name)")
        }
        
    }
    
    public func removeItem(atPath path: String, completion: (() -> Void)? = nil, errorHandler: ((String) -> Void)? = nil) {
        let fl = FileManager.default
        do {
            try fl.removeItem(atPath: path)
            completion?()
        } catch {
            print("Error: \(error.localizedDescription)")
            errorHandler?(error.localizedDescription)
        }
    }
    
    public func rename(file : String, with name: String, completion: (()->Void)? = nil, errorHandler : ((String) -> Void)? = nil) {
        //CHECK IF EQUALS
        var temp1 = file
        var temp2 = name
        if temp2.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return
        }
        
        if temp1.hasSuffix(".m4r") {
            temp1.removeLast(4)
        }
        if temp2.hasSuffix(".m4r") {
            temp2.removeLast(4)
        }
        if temp1 == temp2 {
            return
        }
        //END OF CHECK
        
        
        var destinationName = name
        
        if !destinationName.hasSuffix(".m4r") {
            destinationName.append(".m4r")
        }
        
        
        let originPath = getPath(fromName: file)
        let destionatioPath = createUnicFileName(fromName: destinationName)
        
        let fl = FileManager.default
        do {
            try fl.copyItem(atPath: originPath, toPath: destionatioPath)
            try fl.removeItem(atPath: originPath)
            completion?()
        } catch {
            print("ERROR: \(error.localizedDescription)")
            errorHandler?(error.localizedDescription)
        }
        
        
    }
    
    private func createUnicFileName(fromName name: String) -> String {
        let fl = FileManager.default
        let documentDir = getPath(fromName: "$DOC$")
        var newPath = getPath(fromName: name)
        
        var i = 1
        while fl.fileExists(atPath: newPath) {
            newPath = documentDir.appending("/\(name)\(i).m4r")
            i += 1
        }
        return newPath
    }
    
}
