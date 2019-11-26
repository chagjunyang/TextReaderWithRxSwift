//
//  ViewController.swift
//  TextReader
//
//  Created by cjyang on 2019/11/13.
//  Copyright © 2019 NHN PAYCO. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    lazy var textView: UITextView = {
        let view = UITextView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "안녕하세요. 만나서 반갑습니다."
        
        self.view.addSubview(view)
        
        return view
    }()
    
    lazy var buttonsView: ButtonsView = {
        let buttonsView = ButtonsView()
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonsView)
        
        buttonsView.playButton.rx.tap.bind(onNext: {
            self.speachViewModel.input.speachText.onNext(self.textView.text)
        }).disposed(by: disposeBag)
        
        buttonsView.pauseButton.rx.tap.bind(onNext: speachViewModel.pause).disposed(by: disposeBag)
        buttonsView.endButton.rx.tap.bind(onNext: speachViewModel.end).disposed(by: disposeBag)
        
        return buttonsView
    }()
    
    var speachViewModel = SpeachViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.buildUpConstraints()
        
        speachViewModel.output.didFinish.drive(onNext: { (utterance) in
            print("didfinish \(utterance)")
        }).disposed(by: disposeBag)
        
        speachViewModel.output.wilSpeakRange.drive(onNext: { item in
            print("wilSpeakRange \(item)")
        }).disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    func buildUpConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 30),
            textView.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 50),
            ])
        
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            buttonsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            buttonsView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -25),
            ])
    }
}
