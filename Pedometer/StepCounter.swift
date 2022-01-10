//
//  StepCounter.swift
//  Pedometer
//
//  Created by Frederik Mrozek on 10.01.22.
//

import Foundation
import CoreMotion

/* This protocol is to send the new number of steps to the  */
/* ContentView, when the value changed.                     */
protocol StepDelegate {
    func updateStepsValue(newStepsValue: Int)
}

class StepCounter {
    
    /* The stepDelegate is the ContentView */
    var stepDelegate: StepDelegate!
    
    var steps: Int = 0
    var stepThreshold: Double = 0.05
    private let accelerometerUpdateInterval: Double = 0.025
    private var lastSampleValue: Double = 0.0
    private var signIndicator: Bool = false
    private var exceedingCounter: Int = 0
  
    private var motionManager = CMMotionManager()
    private var filter: FIRLowPassFilter = FIRLowPassFilter()
    
    init() {
        /* This sets the rate in which the CMMotionManager sends accelerometer data */
        self.motionManager.accelerometerUpdateInterval = self.accelerometerUpdateInterval
    }
    
    private func increaseSteps() {
        self.steps += 1
        stepDelegate.updateStepsValue(newStepsValue: steps)
    }
    
    func resetSteps() {
        self.steps = 0
        stepDelegate.updateStepsValue(newStepsValue: steps)
    }
    
    func startCountingSteps() {
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData, error) in
            if accelerometerData != nil {
                /* This gets executed every time the motionManager provides a new sample */
                self.processNewAccelerometerSample(accelerometerData: accelerometerData!)
            }
        }
    }
    
    func stopCountingSteps() {
        self.motionManager.stopAccelerometerUpdates()
    }
  
    private func processNewAccelerometerSample(accelerometerData: CMAccelerometerData) {
        let accelerationAmountValue: Double = self.accelerationVectorAmount(accelerometerData: accelerometerData)
        
        /* Working with delta values, makes the motion relative and not absolute */
        var deltaSample: Double = accelerationAmountValue - self.lastSampleValue
        self.lastSampleValue = accelerationAmountValue
        deltaSample = self.filter.filterSample(inputSample: deltaSample)
        
        /* If the sample is exceeding the threshold, a new state in the process of a step is triggered. */
        /* When the sample exceeds the threshold in one direction, a step is started. When the sample   */
        /* then exceeds the threshold in the other direction, the step is comleted and the step counter */
        /* gets increased, as well as the state gets resetted.                                          */
        if self.isExceedingThreshold(deltaSample: deltaSample) {
            self.signIndicator.toggle()
            self.exceedingCounter += 1
            if self.exceedingCounter == 2 {
                self.exceedingCounter = 0
                self.increaseSteps()
            }
        }
    }
  
    private func accelerationVectorAmount(accelerometerData: CMAccelerometerData) -> Double {
        return sqrt(pow(accelerometerData.acceleration.x, 2) + pow(accelerometerData.acceleration.y, 2) + pow(accelerometerData.acceleration.z, 2))
    }
  
    private func isExceedingThreshold(deltaSample: Double) -> Bool {
        return self.signIndicator ? deltaSample < -self.stepThreshold : deltaSample > self.stepThreshold
    }
}
