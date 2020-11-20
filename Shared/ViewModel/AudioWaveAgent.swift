//
//  AudioWaveAgent.swift
//  TunesWaveTest
//
//  Created by Dani Tox on 06/11/2020.
//

import Foundation

class AudioWaveAgent: ObservableObject {

    @Published public var wave: [Float] = []

    private let model : AudioLoader
    
    init() {
        let url = Bundle.main.url(forResource: "audio", withExtension: "wav")!
        
        self.model = AudioLoader(fileURL: url)
    }
    
    
    public func decode() {
        self.model.decodeFile { (result) in
            switch result {
            case .success(let wave):
                print("Success!")
                DispatchQueue.main.async {
                    self.wave = wave
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
