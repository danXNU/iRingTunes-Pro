//
//  RTExporter.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 21/01/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation
import MediaPlayer

protocol ExporterDelegate {
    func exportDidFinish(withCode code: Int, andMsg msg: String?)
}

class RTExporter {
    
    var delegate : ExporterDelegate?
    
    var initialSong : URL
    var fadeIn : Bool
    var songAttributes : SongAttributes
    var exportPath : URL?
    
    var exporter : AVAssetExportSession?
    private var exporterPrepared : Bool = false
    
    init(initialSong: URL, fadeIn: Bool, songAttributes : SongAttributes) {
        self.initialSong = initialSong
        self.fadeIn = fadeIn
        self.songAttributes = songAttributes
    }
    
    func prepare() {
        let asset = AVAsset(url: initialSong)
        exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exporter?.outputFileType = .m4a
        
        //GET
        let nameSong = songAttributes.songName
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            else { return }
        exportPath = URL(fileURLWithPath: path.appending("/\(nameSong).m4r"))
        deleteFile(atPath: exportPath!)
        exporter?.outputURL = exportPath
        
        if (songAttributes.timeRange != nil) { exporter?.timeRange = songAttributes.timeRange! }
        if fadeIn { eneableFadeIn(asset: asset) }
        self.exporterPrepared = true
    }
    
    func export() {
        if self.exporterPrepared == false { return }
        exporter?.exportAsynchronously(completionHandler: {
            guard let status = self.exporter?.status else { return }
            switch status {
            case .completed:
                print (status.rawValue)
                self.delegate?.exportDidFinish(withCode: 0, andMsg: nil)
            default:
                self.delegate?.exportDidFinish(withCode: 1, andMsg: nil)
            }
            
            
        })
    }
    
    
    
    
    private func eneableFadeIn(asset: AVAsset) {
        let audioMix = AVMutableAudioMix()
        let track = asset.tracks(withMediaType: .audio).first
        
        //GET
        guard let TEMPdurationFade = songAttributes.durationFade else { return }
        guard let TEMPstartFade = songAttributes.startFade else { return }
        
        let durationFade = CMTime(seconds: Double(TEMPdurationFade), preferredTimescale: 1)
        let startFade = CMTime(seconds: Double(TEMPstartFade), preferredTimescale: 1)
        
        let params = AVMutableAudioMixInputParameters(track: track)
        let fadeTimeRange = CMTimeRange(start: startFade, duration: durationFade)
        params.setVolumeRamp(fromStartVolume: 0.0, toEndVolume: 1.0, timeRange: fadeTimeRange)
        audioMix.inputParameters = [params]
        
        exporter?.audioMix = audioMix
        
    }
    
    private func deleteFile(atPath path: URL) {
        let fileManager = FileManager()
        print("Check path: \(path.absoluteString)")
        if fileManager.fileExists(atPath: path.absoluteString) {
            try? fileManager.removeItem(at: path)
        }
    }
    
}

struct SongAttributes {
    var songName : String
    var timeRange : CMTimeRange?
    var startFade: Int?
    var durationFade : Int?
}


