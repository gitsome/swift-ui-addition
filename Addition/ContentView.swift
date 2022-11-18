//
//  ContentView.swift
//  Addition
//
//  Created by john martin on 9/22/22.
//

import SwiftUI

let QUESTION_AMOUNTS = [5, 10, 20]


struct ContentView: View {
    
    
    
    @State private var playingGame = false
    @State private var additionNumber = 1
    @State private var numberOfQuestions = 5
        
    @State private var showGameView = false
    
    @StateObject private var userProgress = UserProgress()
    @StateObject var soundManager: SoundManager = SoundManager()
    
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
                                        isSelected: (additionNumber == thisNumber)
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
                    GameView(number: additionNumber, numberOfQuestions: numberOfQuestions, userProgress: userProgress)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Addition")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
