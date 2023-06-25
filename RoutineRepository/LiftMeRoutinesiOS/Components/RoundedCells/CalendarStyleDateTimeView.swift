//
//  CalendarStyleDateTimeView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI

struct CalendarStyleDateTimeView: View {
    
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
            .roundedCell(cellHeight: cellHeight)
    }
}

struct CalendarStyleDateTimeView_Previews: PreviewProvider {
    
    static var previews: some View {
        CalendarStyleDateTimeView(title: "Start", dateString: "12/25/96", timeString: "6:08 AM")
    }
}
