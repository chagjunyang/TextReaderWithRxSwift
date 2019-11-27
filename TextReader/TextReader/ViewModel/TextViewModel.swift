//
//  TextViewModel.swift
//  TextReader
//
//  Created by cjyang on 27/11/2019.
//  Copyright © 2019 NHN PAYCO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation


class TextViewModel {
    // MARK: Public
    let output: Output
    
    let start = PublishRelay<Void>()
    let pause = PublishRelay<Void>()
    let end = PublishRelay<Void>()
    
    // MARK: Private
    private let speachViewModel = SpeachViewModel()
    private let dataStore = DataStore()
    private var currentReadTextSubject = PublishRelay<NSRange>()
    private var disposeBag = DisposeBag()
    
    init() {
        output = Output(text: dataStore.output.text, currentReadText: currentReadTextSubject.asDriver(onErrorJustReturn: NSRange(location: 0, length: 0)))
        
        start.subscribe(onNext: doStart).disposed(by: disposeBag)
        pause.subscribe(onNext: doPpause).disposed(by: disposeBag)
        end.subscribe(onNext: doEnd).disposed(by: disposeBag)
        
        speachViewModel.output.didFinish.drive(onNext: didFinishUtterance).disposed(by: disposeBag)
        speachViewModel.output.wilSpeakRange.drive(onNext: wilSpeakRange).disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}


// MARK: Input Output


extension TextViewModel {
    struct Output {
        var text: Driver<String>
        var currentReadText: Driver<NSRange>
    }
    
    func doStart() {
        speachViewModel.input.speachText.accept(dataStore.currentText())
    }
    
    func doPpause() {
        speachViewModel.pause()
    }
    
    func doEnd() {
        speachViewModel.end()
    }
    
    func didFinishUtterance(_ utterance: AVSpeechUtterance) {
        dataStore.loadNextText()
        
        doStart()
    }
    
    func wilSpeakRange(_ data:(NSRange, AVSpeechUtterance)) {
        currentReadTextSubject.accept(data.0)
    }
}
