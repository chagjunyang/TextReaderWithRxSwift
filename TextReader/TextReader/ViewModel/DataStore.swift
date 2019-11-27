//
//  DataStore.swift
//  TextReader
//
//  Created by cjyang on 27/11/2019.
//  Copyright © 2019 NHN PAYCO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DataStore {
    // MARK: Input
    struct Input {
        let loadNextText = PublishRelay<Void>()
        let nextText = BehaviorRelay<String>(value: "초기 텍스트.초기 텍스트.초기 텍스트.")
    }
    
    // MARK: Output
    struct Output {
        let text: Driver<String>
    }
    
    let input = Input()
    let output: Output
    var disposeBag = DisposeBag()
    
    init() {
        output = Output(text: input.nextText.asDriver(onErrorJustReturn: ""))
        
        input.loadNextText.subscribe(onNext: loadNextText).disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    func loadNextText() {
        input.nextText.accept("두 번쨰 텍스트.두 번쨰 텍스트.두 번쨰 텍스트.")
    }
}
