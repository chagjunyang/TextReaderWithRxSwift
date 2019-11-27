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
    func loadNextText() {
        textSubject.accept("이건 두번째 텍스트")
    }
    
    // MARK: Output
    struct Output {
        var text: Driver<String>
    }
    
    // MARK: Public
    var output: Output
    
    func currentText() -> String {
        return textSubject.value
    }
    
    // MARK: Private
    private let textSubject = BehaviorRelay<String>(value: "안녕하세요. 만나서반갑습니다. 이건 긴 문장입니다. 정말로 길어요.")
    
    init() {
        self.output = Output(text: textSubject.asDriver(onErrorJustReturn: ""))
    }
}
