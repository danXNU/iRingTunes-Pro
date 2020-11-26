//
//  LibraryView.swift
//  iRingTunes Pro
//
//  Created by danxnu on 26/11/20.
//  Copyright © 2020 Dani Tox. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    
    @StateObject var libraryViewModel = LibraryViewModel()
    
    var body: some View {
        List {
            ForEach(libraryViewModel.items, id: \.url) { file in
                LibraryViewCell(file: file)
            }
            .onDelete(perform: self.removeFiles)
        }
        .navigationBarTitle(Text("Library"), displayMode: .inline)
        .navigationBarHidden(false)
        .onAppear {
            libraryViewModel.fetch()
        }
    }
    
    func removeFiles(at indexSet: IndexSet) {
        for index in indexSet {
            let item = libraryViewModel.items[index]
            self.libraryViewModel.remove(file: item)
        }
    }
}

struct LibraryViewCell: View {
    var file: LibraryObject
    
    var body: some View {
        VStack(alignment: .leading) {
            Label(file.url.lastPathComponent, systemImage: "music.note")
                .font(.body)
                .lineLimit(1)
            
            HStack {
                Spacer()
                Text(file.modificationDate, formatter: formatter)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxHeight: 100)
        .padding(3)
    }
    
    var formatter: Formatter {
        let f = DateFormatter()
        f.dateStyle = .short
        return f
    }
}
