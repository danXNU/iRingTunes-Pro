//
//  ViewsManager.swift
//  TunesWaveTest
//
//  Created by danxnu on 12/11/20.
//

import Foundation
import StoreKit

class ViewsManager: ObservableObject {
    
    @Published public var viewType: ViewType = .home
    
    private var editorManager: AudioManager?
    private var exportManager: ExportManager?
    
    private var inputFileURL: URL?
    
    func setInput(url: URL) {
        self.inputFileURL = url
        
        editorManager = try? AudioManager(url: url)
        
        guard editorManager != nil else { return }
        self.viewType = .editor(editorManager!)
    }
    
    func export(inputFileURL: URL, outputFileURL: URL, fadeIn: Bool, fadeOut: Bool, startTime: TimeInterval, endTime: TimeInterval) {
        let settings = ExportSettings(inputFileURL: inputFileURL,
                                      outputFileURL: outputFileURL,
                                      fadeIn: fadeIn,
                                      fadeOut: fadeOut,
                                      timeRange: (start: startTime, end: endTime))
        
        editorManager?.stop()
        editorManager = nil
        
        exportManager = ExportManager(settings: settings)
        self.viewType = .exporting(exportManager!)        
    }
    
    func finishedExporting(askReview: Bool = false) {
        self.viewType = .home
        exportManager = nil
        
        if askReview && alreadyAskedForReview == false {
            #if os(macOS)
            SKStoreReviewController.requestReview()
            #else
            if let windowScene = UIApplication.shared.windows.first?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
            #endif
            
            alreadyAskedForReview = true
        }
    }
    
    func reset() {
        editorManager?.stop()
        editorManager = nil
        
        finishedExporting()
    }
    
    enum ViewType {
        case home
        case editor(AudioManager)
        case exporting(ExportManager)
    }
}
