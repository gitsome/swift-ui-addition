//
//  ContentView.swift
//  Addition
//
//  Created by john martin on 9/22/22.
//

import SwiftUI

// Suggestion, though this might just be based on personal preference. If these are constants and not referenced else where other than in this file or in content view and it's view model perhaps moving it into that scope would be good place to live. I'm not a huge fan personally of global variables even if they are constants in mobile developement. I never want any class to accidentally access something that they shouldn't. Another solution is to use an enum to help with namespace. Perhaps a `SharedConstants` enum would be a great place to put static functions and variables this way the when referenced it is intentional.
let QUESTION_AMOUNTS = [5, 10, 15]

let MAX_ADDITION_QUESTIONS: Int = 50

// I love this view and all the fun animation with it.
// My one suggestion is to make this a sheet that is presented at the beginning of the app and when the game is finished. This way the user must finish the questions once they start the game. Right now as it is the game allows the player to exit and come back to these initial settings at any time during the play. Just a Suggestion. Another suggestion is to create tabs, although I'm not as much of a fan of this either because sharing data between tabs is extremely hard and Tabs are not ideal for this kind of data sharing. So a sheet would be prefereable. The sheet would then pop up again when the user completes the game or restarts the app.

// I'm having trouble running the application in the simulator. When I go to click submit after entering the number the application freezes... I'm not sure what is happening it could just be that the simulator doesn't work well with the fun animations and particles you are using. I haven't tried this out on a physical device yet but will update when I get the chance.
struct ContentView: View {
    
    // A lot of these state objects could fit into a ViewModel if you wish to follow and MVVM patter. Along with any functions that either manipulate or reference these variables. This would help bring a little more order and structure to your View and reduce it to just UIView Logic
    @State private var playingGame = false
    @State private var additionNumber = 1
    @State private var numberOfQuestions = QUESTION_AMOUNTS[0]
    @State private var showEmitterForNumber: Int? = nil
    @State private var showCompletionForNumber: Int? = nil
        
    @State private var showGameView = false
    
    @StateObject private var userProgress = UserProgress()
    // I find it interesting that you have the sound manager defined in this and in the Game view both as StateObjects, to me it would seem that these two objects should have one source of truth instead of two?
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
        
        NavigationStack { // This is new to me I know it was a new View that was introduced to replace NavigationView. I'm interested to work with it in the future.

            VStack {
                
                Spacer()
                
                // This looks like a potentially great place to create a new view... if desired.
                // GeometryReaders can be tricky fellows and they tend to take up more space than anticipated and also behave strangely at times. Much testing on many devices of difference sizes is recommended to ensure the Reader does not behave oddly
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
                
                // If you were to change this view to be a sheet presented at the end of a set of questions or when the app first launches this would change to a Button with an action to dismiss the modal.
                NavigationLink(value: "GameView") {
                    Text("Go")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
            }
            // This is a new modifier for me I am not familiar with... It would be great to learn more about it!
            .navigationDestination(for: String.self) { dest in
                
                // Perhaps using an enum with destinations would be a safe way to ensure there are not mispellings. For a small app like this not such a big deal but something to keep in mind if you were to ever build a larger app.
                if dest == "GameView" {
                    // There are a lot of parameters going into this view. Have you though about creating an initializer that reduces the preleading argument titles? Or better yet what if you used Environment objects to share data between views... EnvironmentObject might get tricky to use however if you decide to use a sheet. Something to experiment with in a small test application perhaps.
                    GameView(number: additionNumber, numberOfQuestions: numberOfQuestions, userProgress: userProgress) {
                        gameStatus, number, completed in
                        
                        // `DispatchQueue` is a nice way to do things on the main thread but it is becoming a little out dated. Try looking up `Task` and using it in this cast to replace `DispatchQueue` `sleep()` may also be a handy function. In fact I think you will be able to manage this entire call back function provided to this first `DispatchQueue` with two sleeps and all the same code. thus preventing you from having to call dispatch twice. and instead only use task once. OperationQueue may be a task you are interested in using as well during your task... Of course @MainActor is an important property wrapper to look into and ensure that your task since it changed the UI is always running on the main thread.
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
        // Over lays are awesome! Using these can be trick but very useful.
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
