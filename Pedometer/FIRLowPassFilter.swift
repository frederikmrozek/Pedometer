//
//  FIRLowPassFilter.swift
//  Pedometer
//
//  Created by Frederik Mrozek on 10.01.22.
//

import Foundation

class FIRLowPassFilter {
    
    let bufferLength: Int = 25
    var buffer: [Double] = Array()
    
    /* Filter 1 is for better performance           */
    /* Properties:      Type:   Lowpass             */
    /*              0 - 4 Hz:     0dB               */
    /*             5 - 10 Hz:   -40dB               */
    /*let taps: [Double] = [-0.011519934400207703,
                            -0.05247128852982145,
                            -0.07962395397691215,
                            -0.034552380709255974,
                             0.11237735216618981,
                             0.2887385047710414,
                             0.3688184073507271,
                             0.2887385047710414,
                             0.11237735216618981,
                            -0.034552380709255974,
                            -0.07962395397691215,
                            -0.05247128852982145,
                            -0.011519934400207703]
    */
    
    /* Filter 2 is for better quality               */
    /* Properties:      Type:   Lowpass             */
    /*              0 - 4 Hz:     0dB               */
    /*             6 - 20 Hz:   -40dB               */
    let taps: [Double] = [ 0.008343267095683641,
                           0.007149583224306389,
                           0.0014492517668354074,
                          -0.013310605694094289,
                          -0.03450422491286543,
                          -0.05367579867194659,
                          -0.058668616471107396,
                          -0.038574347326520715,
                           0.010331418196167608,
                           0.08087666209830409,
                           0.15569629640166385,
                           0.21287259655532492,
                           0.23427451265344573,
                           0.21287259655532492,
                           0.15569629640166385,
                           0.08087666209830409,
                           0.010331418196167608,
                          -0.038574347326520715,
                          -0.058668616471107396,
                          -0.05367579867194659,
                          -0.03450422491286543,
                          -0.013310605694094289,
                           0.0014492517668354074,
                           0.007149583224306389,
                           0.008343267095683641]
    
    init() {
        buffer = Array(repeating: 0.0, count: self.bufferLength)
    }
    
    /* This function takes a new sample, adds it to the buffer, */
    /* then filters its high frequencies out in the context of  */
    /* the last samples and returns the filtered sample.        */
    func filterSample(inputSample: Double) -> Double {
        var outputSample: Double = 0.0
        buffer.append(inputSample)
        buffer.remove(at: 0)
        for i in 0...24 {
            outputSample += buffer[i] * taps[i]
        }
        return outputSample
    }
}
