//
//  SetRecordView.swift
//  LiftMeRoutinesiOS
//
//  Created by Boyce Estes on 8/25/23.
//

import SwiftUI

public struct SetRecordView: View {
    
    private enum Field: Int, CaseIterable {
        case repCountValue
        case weightValue
    }
    
    @Binding var setRecordViewModel: SetRecordViewModel
    @FocusState private var focusedField: Field?
    
    let rowNumber: Int
    
    public var body: some View {
        
        HStack {
            Text("Set \(rowNumber)")
            
            Spacer()
            
            HStack {
                TextField("100", text: $setRecordViewModel.weight)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(maxWidth: 50)
                    .focused($focusedField, equals: .weightValue)
                Text("x")
                TextField("10", text: $setRecordViewModel.repCount)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(maxWidth: 50)
                    .focused($focusedField, equals: .repCountValue)
                WowToggleView(isTurnedOn: $setRecordViewModel.isCompleted)
            }
        }
    }
}


struct SetRecordView_Previews: PreviewProvider {
    
    @State static var setRecord = SetRecordViewModel(weight: "", repCount: "")
    
    static var previews: some View {
        SetRecordView(setRecordViewModel: $setRecord, rowNumber: 1)
    }
}
