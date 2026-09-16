//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cauan de Jesus Nascimento de Morais on 15/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Germany", "Ireland", "Nigeria", "US","UK", "Italy","Spain", "Monaco", "Poland"]
    @State private var correctAnswer = Int.random(in: 0...3)
    @State private var score = 0
    @State private var actualTry = 1
    @State private var showingResetGameAlert = false
    private let buttons: Range<Int> = 0..<4
    private let maxTry = 5
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(.blue), location: 0.5),
                    .init(color: Color(.gray), location: 0.4),
                ], center: .topLeading, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(alignment: .trailing) {
                        Text("Round \(actualTry)/\(maxTry)")
                    }
                    Text("Guess the flag of: ")
                    
                    Image(countries[correctAnswer])
                        .scaledToFit()
                    
                    ForEach(0..<4) { number in
                        Button(countries[number]) {
                            if actualTry < maxTry {
                                actualTry += 1
                            } else {
                                showingResetGameAlert = true
                            }
                            guessTheFlag(number)
                        }
                    }
                    .buttonStyle(.glassProminent)
                    .buttonSizing(.flexible)
                    .padding(.horizontal, 20)
                    
                    VStack {
                        Text("Your actual score is \(score)")
                    }
                    
                }
                .alert("Congratulations, you finished the game!", isPresented: $showingResetGameAlert){
                    Button("Reset the game", action: resetGame)
                } message: {
                    Text("Your finished with a score of: \(score)")
                }
                .navigationTitle("Guess the flag")
                .font(.title.bold())
            }
        }
    }
    
    func guessTheFlag(_ number: Int) {
        if number == correctAnswer {
            score += 1
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...3)
    }
    
    func resetGame() {
        score = 0
        actualTry = 0
    }
}

#Preview {
    ContentView()
}
