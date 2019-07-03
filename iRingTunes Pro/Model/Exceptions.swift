//
//  Exceptions.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 04/07/2019.
//  Copyright © 2019 Dani Tox. All rights reserved.
//

import Foundation

enum ToxException: Error {
    case devError(String)
    case runtimeError(String)
}
