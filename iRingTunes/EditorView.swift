//
//  EditorView.swift
//  TunesWaveTest
//
//  Created by danxnu on 12/11/20.
//

import SwiftUI

struct EditorView: View {
    @ObservedObject var manager : AudioManager
    @EnvironmentObject var viewsManager: ViewsManager
    
    @State var popoverSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 15) {
//            Button("Decode") {
//                start()
//            }
            VStack {
                Text("\(manager.fileURL.deletingPathExtension().lastPathComponent)")
                    .font(.headline)
                
                ZStack {
                    RingtoneWave(wave: manager.wave,
                                 currentLineIndex: manager.currentLineIndex,
                                 ringtoneEndLineIndex: manager.ringtoneEndIndex,
                                 ringtoneStartLineIndex: ringStartLine,
                                 selectedPlayerTimeLineIndex: playerTimeLine)
                    
                    ZoomButton
                    
                    VStack {
                        HStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 10, height: 10)
                            Text("Ringtone range")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        Spacer()
                        
                        if manager.warningOnlyRingtoneRangePlayingActive {
                            Text("You've set to only play the ringtone range. Deselect it in the player section below to play the full track")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(height: 200)
                
                Group {
                    Text("Click").bold().underline() + Text(" on a line to set the player current time.")
                    Text("Right click").bold().underline() + Text(" a line to set it as a starting point for the ringtone")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                
                VStack {
                    GroupBox(label: Label("Player", systemImage: "play.circle")) {
                        VStack {
                            HStack(spacing: 20) {
                                Button(action: { manager.goBackward() }) {
                                    Image(systemName: "gobackward.15")
                                        .font(.largeTitle)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!manager.isReady)
                                
                                Button(action: { manager.isPlaying.toggle() }) {
                                    Image(systemName: manager.isPlaying ? "pause" : "play")
                                        .font(.largeTitle)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!manager.isReady)
                                
                                Button(action: { manager.goForward() }) {
                                    Image(systemName: "goforward.15")
                                        .font(.largeTitle)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!manager.isReady)
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            
                            Toggle("Play only the ringtone range", isOn: $manager.playsOnlyRingtoneRange)
                        }
                    }
                    
                    
                    
                    GroupBox(label: Label("Ringtone", systemImage: "music.note")) {
                        VStack(spacing: 10) {
                            ringtoneDurationView
                            
                            Divider()
                            
                            ringtoneStartTimeView
                            
                            Divider()
                            
                            HStack {
                                Toggle("Activate Fade-In", isOn: $manager.isFadeInActive)
                                Spacer()
                                Toggle("Activate Fade-Out", isOn: $manager.isFadeOutActive)
                            }//.padding(.vertical)
                            
                        }
                        .padding()
                    }
                    
                    
                }
                .padding()
            }
            
            Button("Export") {
                export()
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            start()
        }
        
    }

    func start() {
        manager.prepare(zoomLevel: Int(manager.zoomLevel)) {
            manager.start()
        }
    }
    
    func export() {
        let fileName = manager.fileURL.deletingPathExtension().lastPathComponent
        
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "\(fileName).m4r"
        panel.beginSheetModal(for: NSApp.mainWindow!) { (response) in
            if response == .OK {
                guard let url = panel.url else { return }
                
                viewsManager.export(inputFileURL: manager.fileURL,
                                    outputFileURL: url,
                                    fadeIn: manager.isFadeInActive,
                                    fadeOut: manager.isFadeOutActive,
                                    startTime: manager.ringtoneStartTime,
                                    endTime: min(manager.playerDuration, (manager.ringtoneStartTime + manager.ringtoneDuration)))
            }
        }
        
    }
}

extension EditorView {
    func getTime(from seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: seconds) ?? "0:00"
    }
    
    var minFadeInDuration: Double {
        min(manager.playerDuration, 0.3)
    }
    
    var ringtoneStartTimeView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Start time: \(getTime(from: manager.ringtoneStartTime))")
                
                Slider(value: $manager.ringtoneStartTime, in: 0...manager.playerDuration, minimumValueLabel: Text("0:00"), maximumValueLabel: Text("\(getTime(from: manager.playerDuration))")) {
                    Text("")
                }
                .labelsHidden()
            }
            Spacer()
        }
    }
    
    var ringtoneDurationView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Duration: \(Int(manager.ringtoneDuration))")
                
                Slider(value: $manager.ringtoneDuration, in: 10...40, minimumValueLabel: Text("10s"), maximumValueLabel: Text("40s")) {
                    Text("")
                }
                .labelsHidden()
            }
            Spacer()
        }
    }
    
    
    var zoomLevelString: String {
        let min = Float(MIN_ZOOM)
        let max = Float(MAX_ZOOM)
        let difference : Float = max - min
        
        let zoom = abs((manager.zoomLevel - min) - difference)
        
        let actualZoom = zoom
        let result = Int((difference - actualZoom) / difference * 100)
        
        return "\(result)%"
    }
    
    var ringStartLine: Binding<Int> {
        Binding {
            manager.ringtoneStartIndex
        } set: {
            manager.setStartRingtoneTime(lineIndex: $0)
        }
    }
    
    var playerTimeLine: Binding<Int> {
        Binding {
            manager.currentLineIndex
        } set: {
            manager.setPlayerTime(lineIndex: $0)
        }
    }
}

extension EditorView {
    private var ZoomButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { popoverSelected = true }) {
                    Image(systemName: "plus.magnifyingglass")
                }
                .font(.largeTitle)
                .buttonStyle(PlainButtonStyle())
                .popover(isPresented: $popoverSelected) {
                    VStack {
                        HStack {
                            Text("Zoom: ")
                            Spacer()
                            Text(zoomLevelString)
                        }
                        Slider(value: $manager.zoomLevel, in: 50...Float(MAX_ZOOM))
                    }
                    .padding()
                    .frame(minWidth: 250)
                }
            }
            Spacer()
        }
        .padding()
    }
}
