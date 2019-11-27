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
        let didFinishDriver = didFinishRelay.asDriver(onErrorJustReturn: AVSpeechUtterance(string: ""))
        let willSpeakDriver = willSpeakRangeRelay.asDriver(onErrorJustReturn: (NSRange(location: 0, length: 0), AVSpeechUtterance(string: "")))
        
        return Output(didFinish: didFinishDriver, wilSpeakRange: willSpeakDriver)
    }()
    
    // MARK: Private
    private let inputSubject = PublishRelay<String>()
    private let didFinishRelay = PublishRelay<AVSpeechUtterance>()
    private let willSpeakRangeRelay = PublishRelay<(NSRange, AVSpeechUtterance)>()
    private var disposeBag = DisposeBag()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var rate: Float = 0.5 //TODO:yang - change public
    
    // MARK: LifeCycle
    override init() {
        super.init()

        synthesizer.delegate = self
        
        inputSubject.subscribe(onNext: play).disposed(by: disposeBag)
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
    func play(_ string: String) {
        if synthesizer.isSpeaking {
            synthesizer.continueSpeaking()
        }
        
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = rate
        
        synthesizer.speak(utterance)
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    func end() {
        synthesizer.stopSpeaking(at: .word)
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        willSpeakRangeRelay.accept((characterRange, utterance))
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        didFinishRelay.accept(utterance)
    }
}

