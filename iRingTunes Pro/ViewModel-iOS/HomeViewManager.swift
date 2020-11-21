//
//  ViewsManager.swift
//  iRingTunes Pro
//
//  Created by danxnu on 21/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import Foundation

class HomeViewManager: ObservableObject {
    
    @Published var currentState: State?
    
    private var inputFile: LibraryFile?
    
    func selectInput(file: LibraryFile) {
        inputFile = file
        currentState = .editor(inputFile!)
    }
    
    enum State: Identifiable {
        case home
        case editor(LibraryFile)
        case ringtonesLibrary
        
        var id: String {
            String(describing: self)
        }
    }
}
