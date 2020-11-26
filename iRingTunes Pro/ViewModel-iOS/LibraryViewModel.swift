//
//  LibraryViewModel.swift
//  iRingTunes Pro
//
//  Created by danxnu on 26/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import Foundation

class LibraryViewModel: ObservableObject {
 
    @Published var items: [LibraryObject] = []
    
    public func fetch() {
        let agent = LibraryListModel()
        let result = agent.fetchItems()
        
        switch result {
        case .failure(let error):
            fatalError(error.localizedDescription)
        case .success(let files):
            self.items = files
        }
    }
    
    func remove(file: LibraryObject) {
        let agent = LibraryListModel()
        agent.remove(file: file)
        self.fetch()
    }
    
}
