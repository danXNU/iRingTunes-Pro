//
//  App.swift
//  iRingTunes
//
//  Created by Daniel Bazzani on 04/12/21.
//  Copyright © 2021 Dani Tox. All rights reserved.
//

import SwiftUI

struct NotificationKeys {
    static let zoomIn = Notification.Name(rawValue: "zoomIn")
    static let zoomOut = Notification.Name(rawValue: "zoomOut")
    static let nextBar = Notification.Name(rawValue: "nextbar")
    static let prevBar = Notification.Name(rawValue: "prevBar")
}

class SharedStorage: ObservableObject {
    @Published var isZoomInDisabled: Bool = true
    @Published var isZoomOutDisabled: Bool = true
    
    @Published var isPrevBarDisabled: Bool = true
    @Published var isNextBarDisabled: Bool = true
}

@main
struct MainApp: App {
    @StateObject var sharedStorage: SharedStorage = SharedStorage()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sharedStorage)
        }
        .commands {
            CommandGroup(replacing: .textEditing) {
                Button("Next") {
                    NotificationCenter.default.post(name: NotificationKeys.nextBar, object: nil)
                }
                .disabled(sharedStorage.isNextBarDisabled)
                .keyboardShortcut(.rightArrow, modifiers: [])
                
                Button("Previous") {
                    NotificationCenter.default.post(name: NotificationKeys.prevBar, object: nil)
                }
                .disabled(sharedStorage.isPrevBarDisabled)
                .keyboardShortcut(.leftArrow, modifiers: [])
                
                Divider()
                
                Button("Zoom in") {
                    NotificationCenter.default.post(name: NotificationKeys.zoomIn, object: nil)
                }
                .disabled(sharedStorage.isZoomInDisabled)
                .keyboardShortcut(.init("+"), modifiers: .command)
                
                Button("Zoom out") {
                    NotificationCenter.default.post(name: NotificationKeys.zoomOut, object: nil)
                }
                .disabled(sharedStorage.isZoomOutDisabled)
                .keyboardShortcut(.init("-"), modifiers: .command)
            }
        }
    }
}
