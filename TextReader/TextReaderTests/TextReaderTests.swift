//
//  TextReaderTests.swift
//  TextReaderTests
//
//  Created by cjyang on 2019/11/13.
//  Copyright © 2019 NHN PAYCO. All rights reserved.
//

import XCTest
import RxSwift
@testable import TextReader

class TextReaderTests: XCTestCase {
    var disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSpeach() {
        let speachString = "Hellow"
        let expectation = XCTestExpectation(description: "testSpeach")
        let speachViewModel = SpeachViewModel()
        
        speachViewModel.output.wilSpeakRange.drive(onNext: { (item) in
            expectation.fulfill()
            
            XCTAssertEqual(item.1.speechString, speachString)
            
        }).disposed(by: disposeBag)
        
        speachViewModel.input.speachText.accept(speachString)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testDataStore() {
        let expectation = XCTestExpectation(description: "testDataStore")
        let dataStore = DataStore()
        
        dataStore.output.text.drive(onNext: { item in
            expectation.fulfill()
            
            XCTAssertTrue(item.count > 0)
        }).disposed(by: disposeBag)
        
        dataStore.input.loadNextText.accept(())
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testTextViewModel() {
        //output으로 텍스트 잘 나오는지만 테스트
    }
}
