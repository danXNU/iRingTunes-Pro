//
//  DocumentImporterView.swift
//  iRingTunes Pro
//
//  Created by danxnu on 21/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers

struct DocumentImporter: UIViewControllerRepresentable {
    let allowedTypes : [UTType]
    @Binding var selectedURLs: [URL]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIDocumentPickerViewController(forOpeningContentTypes: allowedTypes)
        vc.allowsMultipleSelection = true
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedURLs: $selectedURLs)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        @Binding var urls: [URL]
        
        init(selectedURLs: Binding<[URL]>) {
            self._urls = selectedURLs
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.urls = urls
            print("DocumentImporter: \(urls)")
        }
    }
}
