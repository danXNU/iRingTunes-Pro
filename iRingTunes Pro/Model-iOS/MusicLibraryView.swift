//
//  MusicLibraryView.swift
//  iRingTunes Pro
//
//  Created by danxnu on 21/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct MusicLibraryView: UIViewControllerRepresentable {
    @Binding var files: [LibraryFile]
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> MPMediaPickerController {
        let vc = MPMediaPickerController(mediaTypes: .anyAudio)
        vc.delegate = context.coordinator
        vc.allowsPickingMultipleItems = false
        vc.showsCloudItems = false
        vc.showsItemsWithProtectedAssets = false
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MPMediaPickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(files: $files, completion: dismiss)
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    class Coordinator: NSObject, MPMediaPickerControllerDelegate {
        @Binding var files: [LibraryFile]
        var completion: () -> Void
        
        init(files: Binding<[LibraryFile]>, completion: @escaping () -> Void) {
            self._files = files
            self.completion = completion
        }
        
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            guard let file = mediaItemCollection.items.first else { completion(); return }
            guard let url = file.assetURL else { completion(); return }
            
            let songName = file.title ?? "Untitled"
            
            files = [LibraryFile(title: songName, assetURL: url)]
            
            completion()
        }
        
        func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
            files = []
            completion()
        }
    }
    
}
