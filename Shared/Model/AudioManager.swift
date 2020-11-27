//
//  AudioManager.swift
//  TunesWaveTest
//
//  Created by danxnu on 08/11/20.
//

import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {
    
    private var player: AVAudioPlayer
    private var audioLoader: AudioLoader
    
    public let fileURL : URL
    private var timer: Timer?
    
    private var linesPerSecond: Double = 0
    
    @Published public var isLoadingWave: Bool = false
    @Published public var zoomLevel: Float = 550
    
    @Published public var isReady = false
    @Published public var wave: [Float] = []
    @Published public var currentLineIndex: Int = 0
    
    @Published public var ringtoneDuration: Double = 40.0
    @Published public var ringtoneStartTime: Double = 0.0
    
    @Published public var isPlaying: Bool = false
    @Published public var playsOnlyRingtoneRange: Bool = false
    @Published public var isFadeInActive: Bool = true
    @Published public var isFadeOutActive: Bool = false
    @Published public var fadeInDuration: Double = 0.3
    
    @Published public var warningOnlyRingtoneRangePlayingActive: Bool = false
    
    /// Return the line index where the ringtone finishes
    public var ringtoneEndIndex: Int {
        Int((ringtoneStartTime + ringtoneDuration) * self.linesPerSecond)
    }
    
    /// Return the line index where the ringtone starts
    public var ringtoneStartIndex: Int {
        Int(self.ringtoneStartTime * self.linesPerSecond)
    }
    
    public var playerDuration: Double {
        self.player.duration
    }
    
    private var observers: [AnyCancellable] = []
    
    init(url: URL) throws {
        fileURL = url
        audioLoader = AudioLoader(fileURL: url)
        player = try AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        
        let zoomSubscriber = $zoomLevel
            .dropFirst()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { (newValue) in
                self.prepare(zoomLevel: Int(newValue))
            }

        let playingObserver = $isPlaying.sink { (newValue) in
            if newValue { self.player.play() }
            else { self.player.pause() }
        }
            
        observers.append(playingObserver)
        observers.append(zoomSubscriber)
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        print("AudioManager init: \(String(describing: self))")
    }
    
    func stop() {
        removeTimer()
        player.stop()
        observers.removeAll()
        
//        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    deinit {
        stop()
        print("AudioManager deinit: \(String(describing: self))")
    }
    
    func prepare(zoomLevel: Int, completion: (() -> Void)? = nil) {
        isLoadingWave = true
        audioLoader.decodeFile(zoomLevel: zoomLevel) { (result) in
            switch result {
            case .failure(let err):
                print("Error: \(err)")
            case .success(let wave):
                self.wave = wave
                self.isReady = true
                self.linesPerSecond = Double(wave.count) / self.player.duration
                completion?()
            }
            self.isLoadingWave = false
        }
    }
    
    func setPlayerTime(lineIndex: Int) {
        if timer == nil { createTimer() }
        
        let seconds = Double(lineIndex) / linesPerSecond
        player.currentTime = TimeInterval(seconds)
        
        if playsOnlyRingtoneRange {
            if seconds < ringtoneStartTime || seconds > (ringtoneStartTime + ringtoneDuration) {
                self.warningOnlyRingtoneRangePlayingActive = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    self.warningOnlyRingtoneRangePlayingActive = false
                }
            }
        }
    }
    
    func start() {
        guard isReady == true else { return }
        isPlaying = true
        createTimer()
        player.play()
    }
    
    func resume() {
        isPlaying = true
        player.play()
        createTimer()
    }
    
    func pause() {
        isPlaying = false
        player.pause()
        removeTimer()
    }
    
    func goForward() {
        let currentTime = self.player.currentTime
        self.player.currentTime = min(player.duration, currentTime + 15)
    }
    
    func goBackward() {
        let currentTime = self.player.currentTime
        self.player.currentTime = max(0, currentTime - 15)
    }
    
    func setStartRingtoneTime(lineIndex: Int) {
        let seconds = Double(lineIndex) / linesPerSecond
        self.ringtoneStartTime = seconds
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func createTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] (_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let newIndex = Int(self.player.currentTime * self.linesPerSecond)
                if self.currentLineIndex != newIndex {
                    self.currentLineIndex = newIndex
                }                
            }
            if self.playsOnlyRingtoneRange {
                let ringtonteEndTime = min(self.ringtoneStartTime + self.ringtoneDuration, self.player.duration)
                if self.player.currentTime > ringtonteEndTime {
                    self.player.currentTime = self.ringtoneStartTime
                }
                if self.player.currentTime < self.ringtoneStartTime {
                    self.player.currentTime = self.ringtoneStartTime
                }
            }
            
        })
    }
}
