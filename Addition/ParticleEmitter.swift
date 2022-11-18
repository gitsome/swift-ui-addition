//
//  CardView.swift
//  Matching
//
//  Created by john martin on 9/5/22.
//

import UIKit

class ParticleEmitter: UIView {
    
    var emitterLayer: CAEmitterLayer!
    var colors: [UIColor] = []
    
    init(colors: [UIColor]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.colors = colors
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init coder not setup")
    }
        
    func setupView() {
        
        emitterLayer = CAEmitterLayer()
        
        emitterLayer.beginTime = CACurrentMediaTime();
                
        let cells: [CAEmitterCell] = colors.compactMap {
            
            the_color in
            
            let cell = CAEmitterCell()
            cell.lifetime = 2
            cell.duration = 1
            cell.birthRate = 30
            cell.beginTime = 0.01
            cell.velocity = 300
            cell.contents = UIImage(named:"confetti")!.cgImage
            cell.color = the_color.cgColor
            cell.emissionRange = .pi * 2
            cell.yAcceleration = 1000
            cell.spin = CGFloat(Int.random(in: 0 ..< 30)) - 15.0
            
            return cell
        }
        
        emitterLayer.emitterCells = cells
        
        self.layer.addSublayer(emitterLayer)
    }
    
    override func layoutSubviews() {
        
        emitterLayer.scale = 0.15
        emitterLayer.emitterPosition = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        emitterLayer.emitterSize = CGSize(width: frame.width, height: frame.height)
        
        super.layoutSubviews()
    }
}
