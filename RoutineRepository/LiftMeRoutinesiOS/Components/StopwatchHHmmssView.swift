//
//  StopwatchHHmmssView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 7/18/23.
//

import SwiftUI
import Combine


struct StopwatchHHmmssView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common)
    let startDate: Date
    
    @State private var timeElapsed = 0
    
    var body: some View {
        HStack {
            Image(systemName: "stopwatch")
            Text("\(String.hourMinuteSecondDuration(from: timeElapsed))")
                .accessibilityIdentifier("time_duration_label")
        }
        .onReceive(timer) { latestDate in
            timeElapsed = Int(latestDate.timeIntervalSince(startDate))
        }
    }
}

struct StopwatchHHmmssView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchHHmmssView(startDate: Date())
    }
}
