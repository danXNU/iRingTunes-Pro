//
//  LibraryFileViewerModel.swift
//  iRingTunes Pro
//
//  Created by danxnu on 26/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

class LibraryFileViewerModel: ObservableObject {
    
    public var file: LibraryObject
    
    @Published var currentTime: TimeInterval = 0
    @Published var isPlaying: Bool = false
    
    private var player: AVAudioPlayer?
    private var observer: AnyCancellable?
    private var timer: Timer?
    
    init(file: LibraryObject) {
        self.file = file
        
        createPlayer()
        
        print("LibraryFileViewerModel init: \(Unmanaged.passUnretained(self).toOpaque())")
    }
    
    private func play() {
        self.player?.play()
        createTimer()
    }
    
    private func pause() {
        self.player?.pause()
        removeTimer()
    }
    
    public func stop() {
        observer = nil
        removeTimer()
        self.player?.stop()
    }
    
    public func forward10() {
        let currentTime = self.player?.currentTime ?? 0
        self.setPlayerTime(min(currentTime + 10, self.duration))
    }
    
    public func backward10() {
        let currentTime = self.player?.currentTime ?? 0
        self.setPlayerTime(max(currentTime - 10, 0))
    }
    
    private func createPlayer() {
        guard let player = try? AVAudioPlayer(contentsOf: file.url) else { return }
        self.player = player
        
        player.numberOfLoops = -1
        player.prepareToPlay()
        
        observer = $isPlaying.sink(receiveValue: { (newValue) in
            if newValue { self.play() }
            else { self.pause() }
        })
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func createTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            if let currentTime = self.player?.currentTime {
                if self.currentTime != currentTime {
                    DispatchQueue.main.async {
                        self.currentTime = currentTime                        
                    }
                }
            }
        })
    }
    
    public func setPlayerTime(_ seconds: TimeInterval) {
        if timer == nil { createTimer() }
        
        self.player?.currentTime = seconds
    }
    
    deinit {
        self.stop()
        print("LibraryFileViewerModel deinit: \(Unmanaged.passUnretained(self).toOpaque())")
    }
    
    var durationString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: self.player?.duration ?? 0) ?? "0:00"
    }
    
    var duration: TimeInterval {
        player?.duration ?? 0
    }
    
    var currentTimeString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: self.currentTime) ?? "0:00"
    }
}
