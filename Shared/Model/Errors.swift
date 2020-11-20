//
//  Errors.swift
//  TunesWaveTest
//
//  Created by Dani Tox on 06/11/2020.
//

import Foundation

enum AudioReaderError: Error {
    case internalError(Error)
    case noTrackFound
    case assetLoading
}

enum ExportError: Error {
    case internalError(Error)
    case unknown
}
