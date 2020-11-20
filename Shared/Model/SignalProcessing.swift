//
//  SignalProcessing.swift
//  TunesWaveTest
//
//  Created by Dani Tox on 06/11/2020.
//

import Foundation
import Accelerate

class SignalProcessing {
    public static func rms(data: UnsafeMutablePointer<Float>, frameLenght: UInt) -> Float {
        var val: Float = 0
        vDSP_measqv(data, 1, &val, frameLenght)
        
        var db = 10 * log10f(val)
        db = 160 + db
        
        db = db - 120
        
        let min : Float = 0.3
//        let max : Float = 0.6
        
        let dividor = Float(5/min)
        let adjustedVal = min + db/dividor
        
        return adjustedVal
    }
    
    public static func interpolate(current: Float, previous: Float) -> [Float] {
        var vals = [Float](repeating: 0, count: 11)
        vals[10] = current
        vals[5] = (current + previous) / 2
        vals[2] = (vals[5] + previous)/2
        vals[1] = (vals[2] + previous)/2
        vals[8] = (vals[5] + current)/2
        vals[9] = (vals[10] + current)/2
        vals[7] = (vals[5] + vals[9])/2
        vals[6] = (vals[5] + vals[7])/2
        vals[3] = (vals[1] + vals[5])/2
        vals[4] = (vals[3] + vals[5])/2
        vals[0] = (previous + vals[1])/2
        
        return vals
    }
}
