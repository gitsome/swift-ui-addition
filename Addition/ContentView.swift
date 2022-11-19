//
//  ContentView.swift
//  Addition
//
//  Created by john martin on 9/22/22.
//

import SwiftUI

let QUESTION_AMOUNTS = [2, 5, 10, 15]

let MAX_ADDITION_QUESTIONS: Int = 2

struct ContentView: View {
    
    @State private var playingGame = false
    @State private var additionNumber = 1
    @State private var numberOfQuestions = QUESTION_AMOUNTS[0]
    @State private var showEmitterForNumber: Int? = nil
    @State private var showCompletionForNumber: Int? = nil
        
    @State private var showGameView = false
    
    @StateObject private var userProgress = UserProgress()
    @StateObject var soundManager: SoundManager = SoundManager()
    
    func playCompletionCelebration(_ number: Int) {
        showCompletionForNumber = number
        soundManager.playEffect("celebrate", "wav")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.soundManager.play("Way to go! You completed number \(number)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showCompletionForNumber = nil
        }
    }
    
    var body: some View {
        
        NavigationStack {

            VStack {
                
                Spacer()
                
                GeometryReader { geo in
                    
                    let buttonsPerRow = geo.size.width > geo.size.height ? 6 : 3
                    let chunkedAnimals = ANIMALS.allCases.splitBy(buttonsPerRow)
                    
                    VStack {
                        
                        ForEach(0..<chunkedAnimals.count, id: \.self) { i in
                            
                            HStack {
                                ForEach(0..<chunkedAnimals[i].count, id: \.self) { j in
                                    
                                    let itemIndex = i * buttonsPerRow + j
                                    let thisNumber = itemIndex + 1
                                    
                                    AnimalButton(
                                        number: thisNumber,
                                        animalImage: chunkedAnimals[i][j].rawValue,
                                        progress: userProgress.numberProgress[thisNumber - 1],
                                        isSelected: (additionNumber == thisNumber),
                                        showEmitter: showEmitterForNumber == thisNumber
                                    ) {
                                        additionNumber = thisNumber
                                        self.soundManager.play("\(thisNumber)")
                                    }
                                }
                            }
                        }
                    }
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    
                }
                .frame(maxHeight: 425)
                
                Spacer()
                Spacer()
                
                                    
                HStack {

                    Text("Questions")

                    Picker("", selection: $numberOfQuestions) {
                        ForEach(QUESTION_AMOUNTS, id: \.self) {
                            Text("\($0)")
                        }
                    }.pickerStyle(.segmented)
                    
                }
                
                Spacer()
                
                NavigationLink(value: "GameView") {
                    Text("Go")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
            }
            .navigationDestination(for: String.self) { dest in
                
                if dest == "GameView" {
                    GameView(number: additionNumber, numberOfQuestions: numberOfQuestions, userProgress: userProgress) {
                        gameStatus, number, completed in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            
                            showEmitterForNumber = number
                                                        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                
                                showEmitterForNumber = nil
                                
                                let wasNotComplete = userProgress.numberProgress[number - 1] < MAX_ADDITION_QUESTIONS
                                let isCompleteNow = userProgress.numberProgress[number - 1] + completed >= MAX_ADDITION_QUESTIONS
                                let wasJustCompleted = wasNotComplete && isCompleteNow
                                
                                withAnimation() {
                                    userProgress.numberProgress[number - 1] = userProgress.numberProgress[number - 1] + completed
                                    
                                    if wasJustCompleted {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                            playCompletionCelebration(number)
                                        }
                                    }
                                }
                            }
                            
                            soundManager.playEffect("collection", "wav")
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Addition")
        }
        .overlay(alignment: .top) {
            if showCompletionForNumber != nil {
                CelebrationEmitterView(colors: [UIColor.systemOrange, UIColor.systemPink, UIColor.systemRed, UIColor.systemPurple, UIColor.systemGreen])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
