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
    struct Input {
        let speachText: AnyObserver<String>
    }
    
    struct Output {
        let didFinish: Driver<AVSpeechUtterance>
        let wilSpeakRange: Driver<(NSRange, AVSpeechUtterance)>
    }
    
    lazy var input: Input = {
        return Input(speachText: inputSubject.asObserver())
    }()
    
    lazy var output: Output = {
        let didFinishDriver = didFinishSubject.asDriver(onErrorJustReturn: AVSpeechUtterance(string: ""))
        let willSpeakDriver = willSpeakRangeSubject.asDriver(onErrorJustReturn: (NSRange(location: 0, length: 0), AVSpeechUtterance(string: "")))
        
        return Output(didFinish: didFinishDriver, wilSpeakRange: willSpeakDriver)
    }()
    
    private let inputSubject = PublishSubject<String>()
    private let didFinishSubject = PublishSubject<AVSpeechUtterance>()
    private let willSpeakRangeSubject = PublishSubject<(NSRange, AVSpeechUtterance)>()
    private var disposeBag = DisposeBag()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var rate: Float = 0.5 //TODO:yang - change public
    
    override init() {
        super.init()
        
        inputSubject.subscribe(onNext: inputSubscribe).disposed(by: disposeBag)
        
        synthesizer.delegate = self
    }
    
    func inputSubscribe(string: String) {
        self.play(string)
    }
    
    deinit {
        disposeBag = DisposeBag()
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
    }
    
    func pause() {
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    func end() {
        synthesizer.stopSpeaking(at: .word)
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        willSpeakRangeSubject.onNext((characterRange, utterance))
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        didFinishSubject.onNext(utterance)
    }
}

