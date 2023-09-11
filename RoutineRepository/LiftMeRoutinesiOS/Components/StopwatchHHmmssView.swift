//
//  StopwatchHHmmssView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 7/18/23.
//

import SwiftUI
import Combine


struct StopwatchHHmmssView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let startDate: Date
    
    @State private var timeElapsed = 0
    
    var body: some View {
            
        HStack(spacing: 6) {
            Image(systemName: "stopwatch")
                .imageScale(.small)
            Text("\(String.hourMinuteSecondDuration(from: timeElapsed))")
                .accessibilityIdentifier("time_duration_label")
        }
        .font(.subheadline)
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
