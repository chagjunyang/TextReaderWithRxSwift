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
import RxCocoa


class SpeachViewModel: NSObject {
    // MARK: Public
    lazy var input: Input = {
        return Input(speachText: inputSubject)
    }()
    
    lazy var output: Output = {
        let didFinishDriver = didFinishSubject.asDriver(onErrorJustReturn: AVSpeechUtterance(string: ""))
        let willSpeakDriver = willSpeakRangeSubject.asDriver(onErrorJustReturn: (NSRange(location: 0, length: 0), AVSpeechUtterance(string: "")))
        
        return Output(didFinish: didFinishDriver, wilSpeakRange: willSpeakDriver)
    }()
    
    // MARK: Private
    private let inputSubject = PublishRelay<String>()
    private let didFinishSubject = PublishRelay<AVSpeechUtterance>()
    private let willSpeakRangeSubject = PublishRelay<(NSRange, AVSpeechUtterance)>()
    private var disposeBag = DisposeBag()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var rate: Float = 0.5 //TODO:yang - change public
    
    override init() {
        super.init()
        
        inputSubject.subscribe(onNext: {text in
            self.play(text)
        }).disposed(by: disposeBag)
        
        synthesizer.delegate = self
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}


// MARK: Input Output Define


extension SpeachViewModel {
    struct Input {
        let speachText: PublishRelay<String>
    }
    
    struct Output {
        let didFinish: Driver<AVSpeechUtterance>
        let wilSpeakRange: Driver<(NSRange, AVSpeechUtterance)>
    }
}


// MARK: Play


extension SpeachViewModel: AVSpeechSynthesizerDelegate {
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
        
        let test: AnyObserver<String>
        let test2: PublishSubject<String>
        
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    func end() {
        synthesizer.stopSpeaking(at: .word)
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        willSpeakRangeSubject.accept((characterRange, utterance))
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        didFinishSubject.accept(utterance)
    }
}

