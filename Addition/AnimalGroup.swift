//
//  AnimalView.swift
//  Addition
//
//  Created by john martin on 9/25/22.
//

import SwiftUI

let ANIMAL_IMAGE_SIZE = 24.0;

struct AnimalGroup: View {
 
    var total: Int
    var animalImage: String
    
    var body: some View {

        let totalRows = 5
        let totalColumns = Int(ceil(Float(total) / Float(totalRows)))
        
        Group {
            
            if total > 0 {
                
                HStack (spacing: 10) {
                    
                    ForEach(0..<totalColumns, id: \.self) { i in
                        
                        VStack (spacing: 2) {
                            ForEach(0..<totalRows, id: \.self) { j in
                                if (i * totalRows + j < total) {
                                    Image(animalImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: ANIMAL_IMAGE_SIZE, height: ANIMAL_IMAGE_SIZE)
                                } else {
                                    Text(" ")
                                        .frame(width: ANIMAL_IMAGE_SIZE, height: ANIMAL_IMAGE_SIZE)
                                }
                            }
                        }
                    }
                }
                
            } else {
                Text("0")
                    .font(Font.system(size: 34).monospaced())
            }
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
        
    }
}

struct AnimalGroup_Previews: PreviewProvider {
    static var previews: some View {
        AnimalGroup(total: 1, animalImage: ANIMALS.cow.rawValue)
    }
}
