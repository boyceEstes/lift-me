//
//  ContentView.swift
//  LiftMePrototype
//
//  Created by Boyce Estes on 6/30/22.
//

import SwiftUI


struct ContentView: View {
    
    let allExercises = Exercise.mocks
    @State private var searchText = ""
    var searchedExercises: [Exercise] {
        if searchText.wordTokens.isEmpty {
            return allExercises
        } else {
            return tokenSearch(for: searchText, in: allExercises)
        }
    }

    var body: some View {
            
        NavigationView {
            List(searchedExercises) { exercise in
                NavigationLink {
                    ExerciseDetailView(exercise: exercise)
                } label: {
                    ExerciseRow(exercise: exercise)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Exercise List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddExerciseView()) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                print("Exercise list appeared")
            }
        }
    }
    
    func tokenSearch(for searchString: String, in terms: [Exercise] ) -> [Exercise] {
        let searchTokens = searchString.wordTokens

        let results = terms.map{$0.name.wordTokens.map({$0.checkAll(searchTokens)})}
            .map{
                array in array.filter{!$0.isEmpty}
                    .flatMap{$0}
            }

        let termsMatched = results.map{Set($0).count == searchTokens.count}

        let matches = zip(terms, termsMatched).filter{$1}.map{$0.0}
        return matches
    }
}


extension String {
    var wordTokens: [String] {
        var partialToken: String?
        var tokens = [String]()
        
        let characterSet = CharacterSet.whitespaces.union(CharacterSet.punctuationCharacters)
        
        func parse(_ character: Character) {
            
            if var name = partialToken {
                
                guard character.isLetter else {
                    // token is complete at a nonletter symbol
                    if !name.isEmpty {
                        tokens.append(name)
                    }
                    
                    partialToken = nil
                    // parse character again since it might be a separator
                    return parse(character)
                }
                
                name.append(character.lowercased())
                partialToken = name
            } else if character.isLetter {
                // current partial token is nil but character is a letter
                partialToken = String(character.lowercased())
            } else if characterSet.contains(character.unicodeScalars.first!) {
                // current partial token is nil but character is some unicode symbol
                // set partialToken to empty to signal that its time to parse a token
                partialToken = ""
            }
        }
        
        forEach(parse)
        
        // capture the token that was previously found.
        if let lastToken = partialToken, !lastToken.isEmpty {
            tokens.append(lastToken)
        }
        
        return tokens
    }
    
    
    func checkAll(_ searchTokens: [String]) -> [String] {
        var found = [String]()
        for searchToken in searchTokens {
            if (self.range(of: "^\(searchToken.lowercased())", options: .regularExpression) != nil) {
                found.append(searchToken.lowercased())
            }
        }
        
        return Array(Set(found))
    }
}


struct ExerciseRow: View {
    
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
            Text(exercise.lastDoneDateString)
                .font(.caption)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
