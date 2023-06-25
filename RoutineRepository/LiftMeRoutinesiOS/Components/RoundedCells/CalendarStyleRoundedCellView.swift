//
//  CalendarStyleDateTimeView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 6/25/23.
//

import SwiftUI

struct CalendarStyleRoundedCellView: View {
    
    let cellHeight: CGFloat = 100
    
    let title: String
    let contentTitle: String
    let contentSubtitle: String
    
    
    init(title: String, contentTitle: String, contentSubtitle: String = "") {
        
        self.title = title
        self.contentTitle = contentTitle
        self.contentSubtitle = contentSubtitle
    }
    
    
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
                Text("\(contentTitle)")
                    
                    .font(.headline)
                Text("\(contentSubtitle)")
            }
            .frame(maxWidth: .infinity, maxHeight: cellHeight / 3 * 2)
        }
            .roundedCell(cellHeight: cellHeight)
    }
}

struct CalendarStyleDateTimeView_Previews: PreviewProvider {
    
    static var previews: some View {
        CalendarStyleRoundedCellView(title: "Start", contentTitle: "12/25/96", contentSubtitle: "6:08 AM")
        
    }
}
