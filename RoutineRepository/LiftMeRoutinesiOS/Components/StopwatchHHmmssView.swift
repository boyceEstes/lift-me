//
//  StopwatchHHmmssView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 7/18/23.
//

import SwiftUI

struct StopwatchHHmmssView: View {
    
    let startDate: Date
    @State private var timeElapsed = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        Label("\(String.hourMinuteSecondDuration(from: timeElapsed))", systemImage: "stopwatch")
            .onReceive(timer) { latestDate in
                timeElapsed = Int(latestDate.timeIntervalSince(startDate))
            }
            .accessibilityIdentifier("time_duration_label")
    }
    
}

struct StopwatchHHmmssView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchHHmmssView(startDate: Date())
    }
}
