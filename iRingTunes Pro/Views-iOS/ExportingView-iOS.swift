//
//  ExportingView-iOS.swift
//  iRingTunes Pro
//
//  Created by danxnu on 21/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import SwiftUI

struct ExportingView: View {
    @ObservedObject var exportManager: ExportManager
    @Binding var presentationMode: PresentationMode
    
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        VStack(spacing: 15) {
            
            switch viewType {
            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundColor(.green)
                
                Button("Done") {
                    audioManager.stop()
                    presentationMode.dismiss()
                }
                .buttonStyle(OSSetupButtonStyle())
                .frame(maxWidth: 200)
            case .exporting:
                ProgressView("Exporting...", value: exportManager.progress)
                    .frame(maxWidth: 300)
            case .error:
                VStack {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(maxWidth: 100, maxHeight: 100)
                        .foregroundColor(.red)
                    
                    Text(exportManager.errorMsg)
                }
                
                
                Button("Done") {

                }
            }
        }
        .onAppear {
            exportManager.export()
        }
        .navigationBarHidden(true)
        
    }
    
    var viewType: ViewType {
        if exportManager.isError {
            return .error
        }
        if exportManager.isFinished {
            return .success
        } else {
            return .exporting
        }
    }
    
    enum ViewType {
        case exporting
        case error
        case success
    }
    
}
