//
//  LibraryFileViewer.swift
//  iRingTunes Pro
//
//  Created by danxnu on 26/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import SwiftUI

struct LibraryFileViewer: View {
    
    @StateObject var viewModel: LibraryFileViewerModel
    
    init(file: LibraryObject) {
        self._viewModel =  StateObject(wrappedValue: LibraryFileViewerModel(file: file))
    }
    
    var body: some View {
        ScrollView {
            GroupBox(label: Label("Player", systemImage: "music.note")) {
                VStack {
                    Text(viewModel.file.name).lineLimit(1)
                    
                    VStack {
                        Slider(value: currentTimeBinding, in: playerRange)
                        HStack {
                            Text("00:00")
                            Spacer()
                            Text(viewModel.durationString)
                        }
                    }
                    
                    
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "gobackward.10")
                        }
                        
                        Button(action: { viewModel.isPlaying.toggle() }) {
                            Image(systemName: viewModel.isPlaying ? "pause" : "play")
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "goforward.10")
                        }
                    }
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    
                    Text(viewModel.currentTimeString)
                }
                .padding(.top)
            }
            .padding()
        }
        .onDisappear {
            viewModel.stop()
        }
    }
    
}

extension LibraryFileViewer {
    var playerRange: ClosedRange<TimeInterval> {
        0...viewModel.duration
    }
    
    var currentTimeBinding: Binding<TimeInterval> {
        Binding {
            viewModel.currentTime
        } set: {
            viewModel.setPlayerTime($0)
        }
    }
}
