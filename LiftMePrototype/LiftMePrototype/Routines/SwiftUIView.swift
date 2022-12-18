//
//  SwiftUIView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 12/14/22.
//

import SwiftUI
struct Contact: Identifiable {
    let id = UUID()
    let name: String
}

struct SwiftUIView: View {
    // 1


        let contacts = [
            Contact(name: "John"),
            Contact(name: "Alice"),
            Contact(name: "Bob")
        ]
        // 2
        @State private var multiSelection = Set<UUID>()
            
        var body: some View {
            NavigationView {
                VStack {
                    // 3
                    List(contacts, selection: $multiSelection) { contact in
                        Text(contact.name)
                    }
                    Text("\(multiSelection.count) selections")
                }
                .navigationTitle("Contacts")
                .toolbar {
                    // 4
                    EditButton()
                }
            }
        }
    
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
