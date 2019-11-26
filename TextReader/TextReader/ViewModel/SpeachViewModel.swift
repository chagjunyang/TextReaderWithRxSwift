//
//  SpeachViewModel.swift
//  TextReader
//
//  Created by cjyang on 2019/11/14.
//  Copyright © 2019 NHN PAYCO. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

class SpeachViewModel {
    let synthesizer = AVSpeechSynthesizer()
    var rate: Float = 0.5
    
    func play(_ string: String?) {
        if synthesizer.isSpeaking {
            synthesizer.continueSpeaking()
        }
        
        if let _string = string {
            let utterance = AVSpeechUtterance(string: _string)
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
            utterance.rate = rate
            
            synthesizer.speak(utterance)
        }
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    func end() {
        synthesizer.stopSpeaking(at: .word)
    }
}

