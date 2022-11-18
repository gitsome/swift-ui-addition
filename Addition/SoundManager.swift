//
//  SoundManager.swift
//  Addition
//
//  Created by john martin on 11/17/22.
//

import Foundation
import AVFoundation

class SoundManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    internal var errorDescription: String? = nil
    
    private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private var utteranceMap: [AVSpeechUtterance: ()->Void] = [:]
    
    @Published var isSpeaking: Bool = false
    @Published var isShowingSpeakingErrorAlert: Bool = false

    override init() {
        super.init()
        self.synthesizer.delegate = self
    }

    internal func play(_ text: String, _ callback: (() -> Void)? = nil) {

        let utterance = AVSpeechUtterance(string: text)
        
        self.stop()
        self.synthesizer.speak(utterance)
        
        if let unwrappedCallback = callback {
            utteranceMap[utterance] = unwrappedCallback
        }
    }
    
    internal func stop() {
        self.synthesizer.stopSpeaking(at: .immediate)
    }
    
    func runCallbackForUtterance(_ utterance: AVSpeechUtterance) {
        
        if let callback = utteranceMap[utterance] {
            callback()
            utteranceMap[utterance] = nil
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.isSpeaking = true
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.isSpeaking = false
        runCallbackForUtterance(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.isSpeaking = false
        runCallbackForUtterance(utterance)
    }
}
