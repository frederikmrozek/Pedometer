//
//  ContentView.swift
//  Pedometer
//
//  Created by Frederik Mrozek on 10.01.22.
//

import SwiftUI

struct ContentView: View {
    
    var stepCounter: StepCounter = StepCounter()
    @State var steps: Int = 0
    @State private var isCounting: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Steps: \(steps.description)")
                .font(.largeTitle)
            Button (action: {
                self.stepCounter.resetSteps()
                }) {
                    Text("Reset Steps")
                        .foregroundColor(Color.red)
                }.padding()
            Spacer()
            Button (action: {
                self.stepCounter.stepDelegate = self
                self.isCounting ? self.stepCounter.stopCountingSteps() : self.stepCounter.startCountingSteps()
                self.isCounting.toggle()
                }) {
                    Text("\(isCounting ? "Stop" : "Start") Counter")
                        .frame(width: 180.0)
                }.padding()
                .frame(width: 200.0, height: 50.0)
                .background(Color.init(.systemBlue))
                .foregroundColor(.white)
                .cornerRadius(16)
            Spacer()
        }
    }
}

extension ContentView: StepDelegate {
    func updateStepsValue(newStepsValue: Int) {
        steps = newStepsValue
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
