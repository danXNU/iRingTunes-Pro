//
//  AudioReader.swift
//  TunesWaveTest
//
//  Created by Dani Tox on 06/11/2020.
//

import Foundation
import AVFoundation
import Accelerate

typealias AudioWave = [Float]
typealias AudioWaveCompletion = ((Result<AudioWave, AudioReaderError>) -> Void)

let MAX_ZOOM = 1000
let MIN_ZOOM = 50

class AudioLoader {
    var fileURL: URL
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func decodeFile(zoomLevel: Int = 100, completion: @escaping AudioWaveCompletion) {
        let file = try! AVAudioFile(forReading: fileURL)
        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: file.fileFormat.channelCount, interleaved: false)!
        
        let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: UInt32(file.length))!
        do {
            try file.read(into: buf)
            
            let fullData = UnsafeBufferPointer(start: buf.floatChannelData![0], count: Int(buf.frameLength))
            
            
            var processingBuffer: [Float] = Array(repeating: 0, count: fullData.count)
            let sampleCount = vDSP_Length(fullData.count)
            
            vDSP_vabs(fullData.baseAddress!, 1, &processingBuffer, 1, sampleCount)
            
            let multiplier = max(1, abs((zoomLevel - MIN_ZOOM) - MAX_ZOOM))
            
            let samplesPerPixel = Int(150 * multiplier)
            let filter : [Float] = Array(repeating: 1.0 / Float(samplesPerPixel),
                                         count: samplesPerPixel)
            
            let downsampleLength = fullData.count / samplesPerPixel
            var downsampleData : [Float] = Array(repeating: 0.0,
                                                 count: downsampleLength)
            
            vDSP_desamp(processingBuffer, vDSP_Stride(samplesPerPixel), filter, &downsampleData, vDSP_Length(downsampleLength), vDSP_Length(samplesPerPixel))
            
            completion(.success(downsampleData))
            
        } catch {
            print("Error: \(error)")
            completion(.failure(.internalError(error)))
        }
        
    }
    
   
    
}
