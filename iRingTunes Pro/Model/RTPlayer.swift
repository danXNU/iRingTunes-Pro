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
    
    private var audioSession : AVAudioSession?
    
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
    }
    
    public func pause() {
        audioPlayer?.pause()
        destructTimer()
    }
    
    public func resume() {
        audioPlayer?.play()
        createTimer()
    }
    
    private func createTimer() {
        audioPlayerTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] (timer) in
            self?.actionToRepeat?(self?.audioPlayer?.currentTime)
            if self?.actionToRepeat == nil {
                print("RTPlayer.createTimer(): Nessuna azione impostata.")
            }
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
    
    
}





