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
    private let maxRounds = 5
    
    @State private var showingResetGameAlert = false
    @State private var isPlayerAnswerRight = false // Starts as false cause the player hasn't answered yet
    
    @State private var flagAngle = 0.0
    @State private var selectedButton: Int? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(stops: [
                    .init(color: Color(.blue), location: 0.5),
                    .init(color: Color(.gray), location: 0.4),
                ], center: .topLeading, startRadius: 170, endRadius: 400)
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(alignment: .trailing) {
                        Text("Round \(currentRound)/\(maxRounds)")
                    }
                    
                    Text("Guess the flag of: ")
                    
                    flagImage(for: countries[correctAnswer])
                        .rotation3DEffect(Angle(degrees: flagAngle), axis: (x: 0, y: -1, z: 0))
                        .animation(.bouncy(duration: 1.5), value: flagAngle)
                    
                    ForEach(0..<4) { number in
                        Button(countries[number]) {
                            handleFlagTap(number)
                        }
                        .buttonStyle(.glass)
                        .buttonSizing(.flexible)
                        .background(
                            backgroundColor(for: number),
                            in: .capsule
                        )
                        .animation(.easeInOut(duration: 0.75) , value: selectedButton)
                        .padding(.horizontal, 20)
                    }
                    
                    VStack {
                        Text("Current score: \(score)")
                    }
                    
                }
                .alert("Congratulations, you finished the game!", isPresented: $showingResetGameAlert){
                    Button("Reset the game", action: resetGame)
                } message: {
                    Text("You finished with a score of: \(score)")
                }
                .navigationTitle("Guess the flag")
                .font(.title.bold())
            }
        }
    }
    
    
    private func handleFlagTap(_ number: Int) {
        selectedButton = number
        
        if number == correctAnswer {
            score += 1
            isPlayerAnswerRight = true
        } else {
            isPlayerAnswerRight = false
        }
        
        // brief delay so the user can see if their selection turned Green or Red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.60) {
            if currentRound < maxRounds {
                currentRound += 1
                askNextQuestion()
            } else {
                showingResetGameAlert = true
            }
        }
    }
    
    
    private func askNextQuestion() {
        selectedButton = nil // reset selection for new round
        animateImageFlag()
        countries.shuffle()
        correctAnswer = Int.random(in: 0...3)
    }
    
    
    private func resetGame() {
        selectedButton = nil
        isPlayerAnswerRight = false
        score = 0
        currentRound = 1
        askNextQuestion()
    }
    
    
    private func animateImageFlag() {
        flagAngle += 360
    }
    
    
    private func backgroundColor(for number: Int) -> Color {
        guard selectedButton == number else {
            return .secondary // default color for untapped buttons
        }
        
        return isPlayerAnswerRight ? .green : .red
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



