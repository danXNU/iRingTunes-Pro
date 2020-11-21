//
//  ContentView.swift
//  iRingTunes Pro
//
//  Created by danxnu on 20/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View, DropDelegate {
    
    @State var sheetSelected : SheetType?
//    @StateObject var viewManager = HomeViewManager()
    
    var body: some View {
        VStack {
            Text("iRingTunes")
                .font(.largeTitle)
//                .foregroundColor(.orange)
                .bold()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red)
                        .shadow(color: .red, radius: 10, x: 0, y: 0)
                )
            
            Spacer()
            
            VStack(spacing: 30) {
                Image("Icon")
                    .resizable()
                    .frame(width: 128, height: 128)
                    .foregroundColor(.red)
            
                
                Menu {
                    Button("From Music library") { sheetSelected = .musicLibrary }
                    Button("From Files") { sheetSelected = .fileImporter }
                } label: {
                    Text("Crea suoneria")
                        .font(.headline)
                        .osLabelStyle()
                        .frame(maxWidth: 200)
                }
                
            }
            
            Spacer()
            
            Button("Le tue sonerie") {
                
            }
        }
        .padding()
        .onDrop(of: [UTType.fileURL, UTType.audio], delegate: self)
        .fullScreenCover(item: $sheetSelected) { type in
            switch type {
            case .musicLibrary:
                MusicLibraryView(files: libraryFilesBinding)
            case .fileImporter:
                DocumentImporter(allowedTypes: [UTType.audio], selectedURLs: urlsBinding)
            case .editor(let manager):
                NavigationView {
                    EditorView(manager: manager)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        
    }
    
    func performDrop(info: DropInfo) -> Bool {
        let providers = info.itemProviders(for: [UTType.fileURL, .audio])
        providers.first?.loadObject(ofClass: NSURL.self, completionHandler: { (url, error) in
            if error != nil {
                print("\(error!)")
                return
            }
            guard let realURL = url as? NSURL else { return }
            DispatchQueue.main.async {
                self.selectFile(url: realURL as URL)
            }
        })
        return true
    }
    
    func selectFile(name: String? = nil, url: URL) {
        let title = name ?? url.lastPathComponent
        print("SelectedName: \(title)")
        print("Selected file: \(url)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let manager = try? AudioManager(url: url) {
                self.sheetSelected = .editor(manager)
            }
        }
    }
    
}

extension ContentView {
    var libraryFilesBinding: Binding<[LibraryFile]> {
        Binding {
            []
        } set: {
            if let file = $0.first {
                selectFile(name: file.title, url: file.assetURL)
            }
        }
    }
    
    var urlsBinding: Binding<[URL]> {
        Binding {
            []
        } set: {
            if let url = $0.first {
                selectFile(url: url)
            }
        }
    }
}

extension ContentView {
    enum SheetType: Identifiable {
        case fileImporter
        case musicLibrary
        case editor(AudioManager)
        
        var id: String {
            String(describing: self)
        }
    }
}
