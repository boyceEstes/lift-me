//
//  DateTimeView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI

struct DateTimeView: View {
    var body: some View {
        HStack(spacing: 20) {
            RoutineCellView4(title: "Start", dateString: "12/25/23", timeString: "9:05 PM")
            RoutineCellView4(title: "End", dateString: "12/31/23", timeString: "11:59 PM")
        }
    }
}



struct RoutineCellView4: View {
    
    let cellHeight: CGFloat = 100
    let title: String
    let dateString: String
    let timeString: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Text(title)
                    .fontWeight(.bold)
                Spacer()
            }
            .font(.callout)
            .foregroundColor(Color(uiColor: .label))
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: cellHeight / 3, alignment: .leading)
            .background(Color.universeRed)
            
            VStack(spacing: 0) {
                Text("\(dateString)")
                    
                    .font(.headline)
                Text("\(timeString)")
            }
            .frame(maxWidth: .infinity, maxHeight: cellHeight / 3 * 2)
        }
        .foregroundColor(Color(uiColor: .label))
        .frame(width: cellHeight, height: cellHeight)
        .background(Color(uiColor: .tertiarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 4)
        .padding(.vertical)
    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeView()
    }
}

