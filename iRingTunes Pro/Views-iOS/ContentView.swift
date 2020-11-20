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
            
                
                Button(action: {}) {
                    Text("Crea suonerie")
                        .font(.headline)
                }
                .buttonStyle(OSSetupButtonStyle())
                .frame(maxWidth: 200)
            }
            
            Spacer()
            
            Button("Le tue sonerie") {
                
            }
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
//                viewsManager.setInput(url: realURL as URL)
            }
        })
        return true
    }
    
    func chooseFile() {
        
    }
    
}
