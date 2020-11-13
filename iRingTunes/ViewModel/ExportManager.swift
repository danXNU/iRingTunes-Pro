//
//  ExportManager.swift
//  TunesWaveTest
//
//  Created by danxnu on 13/11/20.
//

import Foundation

class ExportManager: ObservableObject {
    
    private var settings: ExportSettings
    private var agent: ExportAgent
    
    @Published public var progress: Float = 0
    @Published public var isFinished: Bool = false
    @Published public var isError: Bool = false
    public var errorMsg: String = ""
    
    init(settings: ExportSettings) {
        self.settings = settings
        self.agent = ExportAgent(settings: settings)
        
        print("ExportManager init: \(String(describing: self))")
    }
    
    deinit {
        print("ExportManager deinit: \(String(describing: self))")
    }
    
    func export() {
        self.agent.updateProgressHandler = { [weak self] newValue in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.progress = newValue
            }
        }
        
        self.agent.export { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self.isFinished = true
                case .failure(let error):
                    switch error {
                    case .internalError(let err):
                        self.errorMsg = err.localizedDescription
                    case .unknown:
                        self.errorMsg = "Unknown error"
                    }
                    
                    self.isError = true
                }
            }
        }
    }
}
