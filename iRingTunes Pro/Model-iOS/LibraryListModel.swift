//
//  LibraryListModel.swift
//  iRingTunes Pro
//
//  Created by danxnu on 26/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import Foundation

enum LibraryModelError: Error {
    case internalError(Error)
    case documentDirFindError
}

struct LibraryListModel {
        
    public func fetchItems() -> Result<[LibraryObject], LibraryModelError> {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return .failure(.documentDirFindError)
        }
        let properties : [URLResourceKey] = [
            .contentModificationDateKey
        ]
        
        let enumerator = FileManager.default.enumerator(at: documentDirectory,
                                                        includingPropertiesForKeys: properties,
                                                        options: .skipsHiddenFiles,
                                                        errorHandler: nil)!
        enumerator.skipDescendents()
        
        
        var files : [LibraryObject] = []
        for item in enumerator {
            guard let fileURL = item as? URL else { continue }
            guard let resources = try? fileURL.resourceValues(forKeys: Set(properties)) else { continue }
            
            let firstModificationDate = resources.contentModificationDate ?? Date()
            
            let file = LibraryObject(url: fileURL, modificationDate: firstModificationDate)
            files.append(file)
        }
        
        return .success(files.sorted { $0.modificationDate > $1.modificationDate })
    }
    
    func remove(file: LibraryObject) {
        let url = file.url
        try? FileManager.default.removeItem(at: url)
        
    }
    
}
