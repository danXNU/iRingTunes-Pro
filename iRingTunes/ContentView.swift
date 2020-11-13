//
//  ContentView.swift
//  TunesWaveTest
//
//  Created by Dani Tox on 06/11/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject var viewsManager: ViewsManager = ViewsManager()
    
    var body: some View {
        Group {
            switch viewsManager.viewType {
            case .home:
                HomeView()
                    .environmentObject(viewsManager)
                    .frame(minWidth: 300, minHeight: 300)
                    .frame(height: 300)
            case .editor(let manager):
                EditorView(manager: manager)
                    .environmentObject(viewsManager)
                    .frame(minWidth: 500, minHeight: 700)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .exporting(let exportManager):
                ExportingView(exportManager: exportManager)
                    .environmentObject(viewsManager)
                    .frame(minWidth: 500, minHeight: 700)
            }
        }
        
    }
    
    
}
