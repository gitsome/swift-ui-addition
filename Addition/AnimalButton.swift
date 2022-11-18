//
//  AnimalView.swift
//  Addition
//
//  Created by john martin on 9/25/22.
//

import SwiftUI

struct AnimalButton: View {
 
    var number: Int
    var animalImage: String
    var progress: Int
    var isSelected: Bool
    var onSelected: () -> Void
        
    var body: some View {

        return ZStack {
            
            Circle()
                .fill(isSelected ? Color(red: 0.3, green: 0.3, blue: 0.3): Color(red: 0.3, green: 0.3, blue: 0.3).opacity(0))
                .scaleEffect(isSelected ? 1 : 0)
                .frame(maxWidth: 35)
                .offset(CGSize(width: 0, height: -20))
                .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: isSelected)
                
            Gauge(value: Float(progress) / 100.0, in: 0...100) {
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
            .tint(Color(UIColor.systemGray6))
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 38, trailing: 12))
            .onTapGesture {
                onSelected()
            }
        }
    }
}

struct AnimalButton_Previews: PreviewProvider {
    static var previews: some View {
        AnimalButton(number: 1, animalImage: ANIMALS.cow.rawValue, progress: 25, isSelected: false) {}
    }
}
