//
//  EmitterView.swift
//  Addition
//
//  Created by john martin on 11/18/22.
//

import Foundation

import SwiftUI
import UIKit

struct EmitterView: UIViewRepresentable {
    
    var colors: [UIColor]
    
    func makeUIView(context: Context) -> UIView {
        
        let host = ParticleEmitter(colors: colors)
        
        return host
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    typealias UIViewType = UIView
}
