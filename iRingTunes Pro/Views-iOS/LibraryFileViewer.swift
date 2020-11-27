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
    @State var selectedSheet: SheetType?
    
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
                            Text(viewModel.currentTimeString)
                            Spacer()
                            Text(viewModel.durationString)
                        }
                    }
                    
                    
                    HStack(spacing: 20) {
                        Button(action: { viewModel.backward10() }) {
                            Image(systemName: "gobackward.10")
                        }
                        
                        Button(action: { viewModel.isPlaying.toggle() }) {
                            Image(systemName: viewModel.isPlaying ? "pause" : "play")
                        }
                        
                        Button(action: { viewModel.forward10() }) {
                            Image(systemName: "goforward.10")
                        }
                    }
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                
                }
                .padding(.top)
            }
            .padding()
        }
        .onDisappear {
            viewModel.stop()
        }
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button(action: self.share ) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .sheet(item: $selectedSheet) { type in
            switch type {
            case .share(let items):
                ShareSheetView(items: items)
            }
        }
    }
    
    
    private func share() {
        viewModel.isPlaying = false
        self.selectedSheet = .share([viewModel.file.url])
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

extension LibraryFileViewer {
    enum SheetType: Identifiable {
        case share([Any])
        
        var id: String {
            String(describing: self)
        }
    }
}
