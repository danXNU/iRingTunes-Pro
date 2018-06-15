//
//  RTGenericModel.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 15/06/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation

class RTGenericModel {
    
    public func getFiles(from path: String, withFilter filter: ((String) -> Bool)? = nil, errorHandler: ((Int) -> Void)? = nil) -> [String] {
        let fl = FileManager.default
        
        guard var files = try? fl.contentsOfDirectory(atPath: path) else { print("ERROR: getFiles"); errorHandler?(1); return [] }
        for (index, file) in files.enumerated() {
            if filter?(file) == false {
                files.remove(at: index)
            }
        }
        
        return files
    }
    
    
}
