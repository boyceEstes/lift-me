//
//  ExerciseDetailInfoView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI

struct ExerciseDetailInfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("This is my description of the exercise there are a lot like it but this one is mine")
            HStack(spacing: 20) {
                RoutineCellView4(title: "Created", dateString: "12/29/23", timeString: "11:59 PM")
                RoutineCellView4(title: "Records", dateString: "1", timeString: "")
                RoutineCellView4(title: "ORM", dateString: "305 lbs", timeString: "")
    //            RoutineCellView5(routineName: "My description make it longer and longer until it won't go any longer please and thank you that would mean the world to me")
            }
        }
        .padding(.horizontal)

    }
}

struct ExerciseDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailInfoView()
    }
}


struct RoutineCellView5: View {
    
    let cellHeight: CGFloat = 100
    let routineName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(routineName)")
                .font(.callout)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
                .padding()
        }
        .foregroundColor(Color(uiColor: .label))
        .frame(maxWidth: .infinity)
        .frame(height: cellHeight)
        .background(Color(uiColor: .tertiarySystemBackground))
        
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding(.vertical)
    }
}
