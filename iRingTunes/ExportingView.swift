//
//  ExportingView.swift
//  TunesWaveTest
//
//  Created by danxnu on 13/11/20.
//

import SwiftUI

struct ExportingView: View {
    @EnvironmentObject var viewsManager: ViewsManager
    @ObservedObject var exportManager: ExportManager
    
    var body: some View {
        VStack(spacing: 15) {
            
            switch viewType {
            case .success:
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .foregroundColor(.green)
                
                Button("Done") {
                    viewsManager.finishedExporting(askReview: true)
                }
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
                    viewsManager.reset()
                }
            }
        }
        .onAppear {
            exportManager.export()
        }
        
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
