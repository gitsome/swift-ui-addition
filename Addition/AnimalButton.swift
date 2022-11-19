//
//  AnimalView.swift
//  Addition
//
//  Created by john martin on 9/25/22.
//

import SwiftUI

func getColorForThreshold (_ threshold: Int) -> Color {
    
    let percentProgress = Float(threshold) / Float(MAX_ADDITION_QUESTIONS)
    
    if percentProgress < 0.01 {
        return Color(UIColor.systemGray6)
    } else if percentProgress < 1.0 {
        return Color.blue.opacity(Double(percentProgress) * 0.85 + 0.15)
    } else {
        return Color.gray
    }
}

struct AnimalButton: View {
 
    var number: Int
    var animalImage: String
    var progress: Int
    var isSelected: Bool
    var showEmitter: Bool
    var onSelected: () -> Void
        
    var body: some View {

        return ZStack {
            
            Circle()
                .fill(isSelected ? Color(red: 0.3, green: 0.3, blue: 0.3): Color(red: 0.3, green: 0.3, blue: 0.3).opacity(0))
                .scaleEffect(isSelected ? 1 : 0)
                .frame(maxWidth: 35)
                .offset(CGSize(width: 0, height: -19))
                .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: isSelected)
                
            Gauge(value: Float(progress), in: 0...Float(MAX_ADDITION_QUESTIONS)) {
                Image(animalImage)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.7)
                    .rotationEffect(isSelected ? Angle.degrees(360.0) : Angle.degrees(0), anchor: .center)
                    .animation(isSelected ? .interpolatingSpring(stiffness: 200, damping: 20) : nil, value: isSelected)
                    .offset(CGSize(width: 0, height: 13))
                    
            }
            currentValueLabel: {
                Text("\(number)")
                    .foregroundColor(isSelected ? Color.white : Color.gray)
                    .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: isSelected)
            }
            .gaugeStyle(.accessoryCircular)
            .tint(getColorForThreshold(progress))
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 38, trailing: 12))
            .onTapGesture {
                onSelected()
            }
        }
        .overlay() {
            if showEmitter {
                EmitterView(colors: [UIColor.systemOrange, UIColor.systemPink, UIColor.systemRed, UIColor.systemPurple, UIColor.systemGreen])
                    .offset(y: -20)
            }
        }.zIndex(100)
    }
}

struct AnimalButton_Previews: PreviewProvider {
    static var previews: some View {
        AnimalButton(number: 1, animalImage: ANIMALS.cow.rawValue, progress: 25, isSelected: false, showEmitter: false) {}
    }
}
