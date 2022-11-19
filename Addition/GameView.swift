//
//  GameView.swift
//  Addition
//
//  Created by john martin on 9/25/22.
//

import SwiftUI

enum CorrectPhrases: String, CaseIterable {
    case correct = "That's correct. Nice job!"
    case awesome = "Awesome Sauce!"
    case right = "That's right!"
    case excellent = "Excellent work!"
    case sweet = "Sweet, that's right!"
    case booyah = "Boo ya"
    case success = "Success!"
    case rock = "You rock!"
    case sick = "Sick bird!"
    case rad = "That's Radical bro!"
}

enum WrongPhrases: String, CaseIterable {
    case incorrect = "That is incorrect. Try again."
    case weak = "Weak Sauce! Try again."
    case sorry = "Sorry, try again."
    case whoops = "Whoops. Wrong."
}

enum PhraseType: CaseIterable {
    case SimpleAddition
    case Total
    case Sum
    case Combine
    case MoreThan
    case WhatDoYouGetUnits
    case HowManyUnits
}

struct AdditionQuestion {
    var number: Int
    var addend: Int
    var result: Int
    var units: String
}

func getRandomQuestions(number: Int, numberOfQuestions: Int) -> [AdditionQuestion] {
    
    var final_list: [AdditionQuestion] = []
    
    for _ in 0...numberOfQuestions - 1 {
        let random_addend = Int.random(in:0...12)
        let animal = ANIMALS.allCases[number - 1]
        final_list.append(AdditionQuestion(number: number, addend: random_addend, result: number + random_addend, units: animal.rawValue))
    }
                          
    return final_list
}

enum FocusField: Hashable {
    case textField
}

enum GAME_STATUS {
    case COMPLETE
    case INCOMPLETE
}

struct GameView: View {
    
    var number: Int
    var numberOfQuestions: Int
    var onComplete: (GAME_STATUS, Int, Int) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var soundManager: SoundManager = SoundManager()
    @ObservedObject var userProgress: UserProgress
    
    @State private var currentQuestion: Int = 0
    @State private var numberCorrect = 0
    @State private var allQuestions: [AdditionQuestion] = []
    @State private var guess = ""
    
    @State private var isSubmitting = false
    
    
    @FocusState private var focusedField: FocusField?
    
    
    init(number: Int, numberOfQuestions: Int, userProgress: UserProgress, onComplete: @escaping (GAME_STATUS, Int, Int) -> Void) {
        self.number = number
        self.numberOfQuestions = numberOfQuestions
        self.userProgress = userProgress
        self.onComplete = onComplete
        
        // QUESTION: Should do this in onAppear?
        _allQuestions = State(initialValue: getRandomQuestions(number: number, numberOfQuestions: numberOfQuestions))
    }
    
    func nextQuestion() {
        guess = ""
        isSubmitting = false
        
        if currentQuestion == numberOfQuestions - 1 {
            onComplete(GAME_STATUS.COMPLETE, number, numberOfQuestions)
            dismiss()
        } else {
            currentQuestion = currentQuestion + 1
            readCurrentQuestion()
        }
    }
    
    func getAdditionPhraseForQuestion(_ question: AdditionQuestion) -> String {
        
        let phraseType = PhraseType.allCases.randomElement()!
        let addendIsPlural = question.addend != 1
        let numberIsPlural = question.number != 1
        
        switch phraseType {
        case .SimpleAddition:
            return "What is \(question.number) plus \(question.addend)?"
        case .Total:
            return "How many total \(question.units)s are there?"
        case .Sum:
            return "What is the sum of \(question.number) and \(question.addend)?"
        case .Combine:
            return "How many \(question.units)s if you combine \(question.number) and \(question.addend) \(question.units)\(addendIsPlural ? "s" : "")?"
        case .MoreThan:
            return "What is \(question.addend) more than \(question.number)?"
        case .HowManyUnits:
            return "If you started with \(question.number) \(question.units)\(numberIsPlural ? "s" : "") and added \(question.addend) more, how many would you have?"
        case .WhatDoYouGetUnits:
            return "What do you get when you add \(question.number) \(question.units)\(numberIsPlural ? "s" : "") and \(question.addend) \(question.units)\(addendIsPlural ? "s" : "") together?"
        }
    }
    
    func readCurrentQuestion() {
        let thisQuestion = allQuestions[currentQuestion]
        self.soundManager.play(getAdditionPhraseForQuestion(thisQuestion))
    }
     
    func checkAnswer() {

        isSubmitting = true
        
        let question = allQuestions[currentQuestion]
        if Int(guess) == question.result {
            let correctStatement = CorrectPhrases.allCases.randomElement()!.rawValue
            self.soundManager.play("\(question.result)."){
                self.soundManager.play(correctStatement){
                    nextQuestion()
                }
            }
        } else {
            let wrongStatement = WrongPhrases.allCases.randomElement()!.rawValue
            self.soundManager.play(wrongStatement)
            guess = ""
            isSubmitting = false
        }
        focusedField = .textField
    }
    
    var body: some View {
                
        return Group {
            
            if currentQuestion > -1 {
                
                let question = allQuestions[currentQuestion]
                let animal = ANIMALS.allCases[number - 1]
                
                VStack {
                    Group {
                        ProgressView("\(self.currentQuestion + 1) of \(self.numberOfQuestions)", value: Float(currentQuestion + 1), total: Float(self.numberOfQuestions))
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    
     
                    HStack (spacing: 35) {
                        AnimalGroup(total: question.number, animalImage: animal.rawValue)
                        Text("+")
                            .font(Font.system(size: 34).monospaced())
                        AnimalGroup(total: question.addend, animalImage: animal.rawValue)
                    }
                }
                
                Spacer()
                Spacer()
                
                VStack (spacing: 3){
                    Text("\(question.number)".leftPadding(toLength: 4, withPad: " "))
                    Text("+" + "\(question.addend)".leftPadding(toLength: 3, withPad: " "))
                        .overlay(
                            Color(.black).frame(height: 3).offset(x: 0, y: 3)
                            , alignment: .bottom)
                    
                    ZStack {
                        TextField("", text: $guess)
                            .keyboardType(.numberPad)
                            .lineLimit(1)
                            .multilineTextAlignment(.trailing)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .focused($focusedField, equals: .textField)
                            .onSubmit(checkAnswer)
                    }
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 12, leading: 5, bottom: 5, trailing: 5))
                }
                .font(Font.system(size: 34).monospaced())
                .frame(maxWidth:116)
                
                Spacer()
                
                Group {
                    Button {
                        checkAnswer()
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isSubmitting)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
                
            }
            
        }
        .onAppear {
            readCurrentQuestion()
        }
        .navigationBarTitleDisplayMode(.inline)

    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(number:0, numberOfQuestions: 2, userProgress: UserProgress()) { gameStatus, number, completed in }
    }
}
