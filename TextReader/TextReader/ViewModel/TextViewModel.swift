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
    let input = Input()
    let output: Output
    
    // MARK: Private
    private let speachViewModel = SpeachViewModel()
    private let dataStore = DataStore()
    private var currentReadTextSubject = PublishRelay<NSAttributedString>()
    private var disposeBag = DisposeBag()
    
    init() {
        output = Output(text: dataStore.output.text, currentReadText: currentReadTextSubject.asDriver(onErrorJustReturn: NSAttributedString(string: "")))
        
        input.start.subscribe(onNext: doStart).disposed(by: disposeBag)
        input.pause.subscribe(onNext: doPpause).disposed(by: disposeBag)
        input.end.subscribe(onNext: doEnd).disposed(by: disposeBag)
        
        speachViewModel.output.didFinish.drive(onNext: didFinishUtterance).disposed(by: disposeBag)
        speachViewModel.output.wilSpeakRange.map { (data: (NSRange, AVSpeechUtterance)) -> NSAttributedString in
            return self.rageAttributedString(data.1.speechString, range: data.0)
        }.drive(onNext: wilSpeakRange).disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}


// MARK: Input Output


extension TextViewModel {
    struct Input {
        let start = PublishRelay<Void>()
        let pause = PublishRelay<Void>()
        let end = PublishRelay<Void>()
    }
    
    struct Output {
        var text: Driver<String>
        var currentReadText: Driver<NSAttributedString>
    }
    
    func doStart() {
        speachViewModel.input.speachText.accept(dataStore.input.nextText.value)
    }
    
    func doPpause() {
        speachViewModel.pause()
    }
    
    func doEnd() {
        speachViewModel.end()
    }
    
    func didFinishUtterance(_ utterance: AVSpeechUtterance) {
        dataStore.loadNextText()
    }
    
    func wilSpeakRange(_ attrText: NSAttributedString) {
        currentReadTextSubject.accept(attrText)
    }
    
    func rageAttributedString(_ text: String, range: NSRange) -> NSAttributedString {
        let backgroundAttr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.backgroundColor : UIColor.green]
        let result = NSMutableAttributedString(string: text)
        
        result.addAttributes(backgroundAttr, range: range)

        return result
    }
}
