//
//  RingtoneWave.swift
//  TunesWaveTest
//
//  Created by danxnu on 09/11/20.
//

import SwiftUI

struct RingtoneWave: View {    
    var wave: [Float]
    var currentLineIndex: Int
    var ringtoneEndLineIndex: Int
    
    @Binding var ringtoneStartLineIndex: Int
    @Binding var selectedPlayerTimeLineIndex: Int
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                ScrollViewReader { reader in
                    LazyHStack(spacing: 5) {
                        ForEach(0..<wave.count, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 10, height: CGFloat(wave[index] * 1000))
                                .id(index)
                                .foregroundColor(currentLineIndex == index ? .blue : .primary)
                                .overlay(
                                    lineColor(index: index)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                )
                                .onTapGesture {
                                    selectedPlayerTimeLineIndex = index
                                }
                                .contextMenu {
                                    Button("Set as ringtone start time") {
                                        ringtoneStartLineIndex = index
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func lineColor(index: Int) -> Color {
        if index >= ringtoneStartLineIndex && index <= ringtoneEndLineIndex && currentLineIndex != index {
            return Color.orange
        } else {
            return Color.clear
        }
    }
    
}
