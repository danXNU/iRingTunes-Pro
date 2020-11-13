//
//  HomeView.swift
//  TunesWaveTest
//
//  Created by danxnu on 13/11/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View, DropDelegate {
    @EnvironmentObject var viewsManager: ViewsManager
    
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
            
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Image("Icon")
                        .resizable()
                        .frame(width: 52, height: 52)
                        .foregroundColor(.red)
                    
                    Text("Drag a song here")
//                        .bold()
                        .font(.largeTitle)
                }
                
                Text("or")
                    .foregroundColor(.secondary)
                
                
                Button("Select file") {
                    chooseFile()
                }
                
            }
            Spacer()
        }
        .padding()
        .onDrop(of: [UTType.fileURL, UTType.audio], delegate: self)
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
                viewsManager.setInput(url: realURL as URL)
            }            
        })
        return true
    }
    
    func chooseFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = [UTType.audio.identifier]
        panel.beginSheetModal(for: NSApp.keyWindow!) { (response) in
            if response == .OK {
                guard let url = panel.url else { return }
                
                viewsManager.setInput(url: url)
            }
        }
    }
    
}
