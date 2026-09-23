//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cauan de Jesus Nascimento de Morais on 15/09/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Germany", "Ireland", "Nigeria", "US", "UK", "Italy", "Spain", "Monaco", "Poland", "Ukraine", "France", "Estonia"]
    @State private var correctAnswer = Int.random(in: 0...3)
    @State private var score = 0
    @State private var currentRound = 1
    @State private var showingResetGameAlert = false
    
    private let maxRounds = 5
    
    
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
                        Text("Round \(currentRound)/\(maxRounds)")
                    }
                    
                    Text("Guess the flag of: ")
                    
                    flagImage(for: countries[correctAnswer])
                    
                    ForEach(0..<4) { number in
                        Button(countries[number]) {
                            handleFlagTap(number)
                        }
                    }
                    .buttonStyle(.glass)
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
    
    private func handleFlagTap(_ number: Int) {
        if number == correctAnswer {
            score += 1
        }
        
        if currentRound < maxRounds {
            currentRound += 1
            askNextQuestion()
        } else {
            showingResetGameAlert = true
        }
    }
    
    func askNextQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...3)
    }
    
    func resetGame() {
        score = 0
        currentRound = 1
        askNextQuestion()
    }
    
    var images: some View {
        Image(countries[currentRound])
            .frame(maxWidth: .infinity)
    }
}

extension View {
    func flagImage(for imageName: String) -> some View {
        Image(imageName)
            .scaledToFit()
    }
}

#Preview {
    ContentView()
}
