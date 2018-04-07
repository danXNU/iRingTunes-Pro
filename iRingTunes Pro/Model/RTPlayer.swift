//
//  RTPlayer.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 02/04/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation
import AVFoundation

class RTPlayer {
    
    private var songURL : URL
    private var audioPlayer : AVAudioPlayer?
    private var prepared: Bool = false
    
    private var audioPlayerTimer : Timer?
    
    public var actionToRepeat : ((Double?) -> Void)?
    public var completionPause : (() -> Void)?
    public var completionStart : (() -> Void)?
    
    private var audioSession : AVAudioSession?
    
    public var startRingtone : Double?
    public var stopRingtone : Double?
    
    public var duration : Int?
    
    init(songURL: URL) {
        self.songURL = songURL
    }
    
    deinit {
        print("RTPlayer: deinitialized")
    }
    public func prepare(errorHandler : ((Int) -> Void)? ) {
        do {
            
            audioSession = AVAudioSession.sharedInstance()
            try audioSession?.setCategory(AVAudioSessionCategoryPlayback)
            
            try audioPlayer = AVAudioPlayer(contentsOf: songURL)
            self.prepared = true
            if audioPlayer?.prepareToPlay() == false {
                print("RTPlayer.prepare(): HO FAILATO A PREPARARMI PER FAR PARTIRE L'AUDIO")
                errorHandler?(-2)
            }
        } catch {
            print("RTPlayer.prepare(): HO FAILATO NEL CREARE IL PLAYER CON QUESTO URL. MESSAGGIO:\n\(error.localizedDescription)\nFINE MESSAGGIO di RTPlayer.prepare()")
            errorHandler?(-1)
        }
    }
    
    
    public func play(startingAt time: Double, errorHandler : ((Int) -> Void)?) {
        if self.prepared == false {
            print("RTPlayer.play(): NON SONO ANCORA STATO PREPARATO. DEVI CHIAMARE RTPlayer.prepare() prima di RTPlayer.play()")
            errorHandler?(-1)
            return
        }
        
        destructTimer()
        audioPlayer?.currentTime = time
        if audioPlayer?.play() == false {
            errorHandler?(-2)
        }
        createTimer()
        completionStart?()
    }
    
    public func pause() {
        audioPlayer?.pause()
        destructTimer()
        completionPause?()
    }
    
    public func resume() {
        audioPlayer?.play()
        createTimer()
        completionStart?() //DA TESTARE SE FUNZIONA IN RESUME()
    }
    
    private func resetPlayer() {
        if let startRingtone = self.startRingtone {
            prepare(errorHandler: nil)
            play(startingAt: startRingtone, errorHandler: nil)
        }
    }
    
    private func stopIfNeeded() {
        if let currentTime = audioPlayer?.currentTime, let songDuration = audioPlayer?.duration {
            if Int(currentTime) >= Int(songDuration) {
                resetPlayer()
            }
            
            if let stopTime = self.stopRingtone {
                if Int(currentTime) >= Int(stopTime) {
                    resetPlayer()
                }
            }
            
        }
    }
    
    private func createTimer() {
        audioPlayerTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] (timer) in
            
            print("CURRENT TIME: \(self?.audioPlayer!.currentTime.playerValue)\t\tMAX VALUE BEFORE BEING STOPPED: \(self?.stopRingtone?.playerValue)")
            
            self?.stopIfNeeded()

            self?.actionToRepeat?(self?.audioPlayer?.currentTime)
            
        })
        
    }
    
    private func destructTimer() {
        audioPlayerTimer?.invalidate()
        audioPlayerTimer = nil
    }
    
    
    public func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    
    public func getSongDuration() -> Double {
        return audioPlayer?.duration ?? 0
    }
    
    public func setCurrentTime(_ time : Double) {
        audioPlayer?.currentTime = time
    }
    
    public func setRingtoneTime(start : Double, duration : Int) {
        if self.prepared == false {
            print("RTPlayer.setRingtoneTime(): self.prepared == false. Questo vuol dire che non è stato ancora creato un player da cui prendere la durata della canzone intera")
        }
        
        self.startRingtone = start // default to 0
        self.duration = duration //default to 40s
        
        
        let stop = start + Double(duration)
        
        if let playerDuration = audioPlayer?.duration {
            if stop > playerDuration {
                self.stopRingtone = audioPlayer?.duration
            } else {
                print("RTPlayer.stopRingtone = \(stop.playerValue)")
                self.stopRingtone = stop
            }

        }
        
        
    }
    
}





