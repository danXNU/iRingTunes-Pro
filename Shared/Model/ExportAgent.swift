//
//  ExportAgent.swift
//  TunesWaveTest
//
//  Created by danxnu on 13/11/20.
//

import Foundation
import MediaPlayer
import Combine

struct ExportSettings {
    var inputFileURL: URL
    var outputFileURL: URL
    var fadeIn: Bool
    var fadeOut: Bool
    var timeRange: (start: Double, end: Double)
}

class ExportAgent {
    
    private var exportSession: AVAssetExportSession!
    private var settings: ExportSettings

    public var updateProgressHandler: ((Float) -> Void)?
    private var timerProgress: Timer?
    
    init(settings: ExportSettings, progressUpdate: ((Float) -> Void)? = nil) {
        self.settings = settings
        
        let asset = AVAsset(url: settings.inputFileURL)
        self.exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        self.exportSession?.outputFileType = .m4a
        self.exportSession?.timeRange = CMTimeRange(start: CMTime(seconds: settings.timeRange.start, preferredTimescale: 1),
                                                    end: CMTime(seconds: settings.timeRange.end, preferredTimescale: 1))
        self.exportSession?.outputURL = settings.outputFileURL
        
        //enable Fade-In and/or Fade-Out
        if settings.fadeIn || settings.fadeOut {
            let audioMix = AVMutableAudioMix()
            if let track = asset.tracks(withMediaType: .audio).first {
                let params = AVMutableAudioMixInputParameters(track: track)
                
                if settings.fadeIn {
                    let fadeInRange = CMTimeRange(start: CMTime(seconds: settings.timeRange.start, preferredTimescale: 1),
                                                  end: CMTime(seconds: settings.timeRange.start + 3, preferredTimescale: 1))
                    params.setVolumeRamp(fromStartVolume: 0.0, toEndVolume: 1.0, timeRange: fadeInRange)
                }
                
                if settings.fadeOut {
                    let fadeOutRange = CMTimeRange(start: CMTime(seconds: settings.timeRange.end - 3, preferredTimescale: 1),
                                                   end: CMTime(seconds: settings.timeRange.end, preferredTimescale: 1))
                    params.setVolumeRamp(fromStartVolume: 1.0, toEndVolume: 0.0, timeRange: fadeOutRange)
                }
                
                                
                audioMix.inputParameters = [params]
            }
            exportSession?.audioMix = audioMix
        }
                
    }
    
    func export(completion: @escaping (Result<Int, ExportError>) -> Void) {
        do {
            if FileManager.default.fileExists(atPath: settings.outputFileURL.path) {
                try FileManager.default.removeItem(at: settings.outputFileURL)
            }
            exportSession.exportAsynchronously { [weak self] in
                guard let self = self else { completion(.failure(.unknown)); return }
                guard let status = self.exportSession?.status else { return }
                
                switch status {
                case .completed:
                    completion(.success(0))
                case .failed:
                    if let error = self.exportSession?.error {
                        completion(.failure(.internalError(error)))
                    } else {
                        completion(.failure(.unknown))
                    }
                default:
                    completion(.failure(.unknown))
                }
            }
            createTimer()
        } catch {
            completion(.failure(.internalError(error)))
        }
        
    }
    
    private func createTimer() {
        timerProgress = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { timer.invalidate(); return }
            
            self.updateProgressHandler?(self.exportSession.progress)
            if self.exportSession.progress > 0.99 {
                timer.invalidate()
            }
        })
    }
}
