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
        
        self.view.addSubview(view)
        
        return view
    }()
    
    lazy var buttonsView: ButtonsView = {
        let buttonsView = ButtonsView()
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonsView)
        
        return buttonsView
    }()
    
    var textViewModel = TextViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        buildUpConstraints()
        bindUI()
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

// MARK: Bind

extension ViewController {
    func bindUI() {
        textViewModel.output.text.drive(textView.rx.text).disposed(by: disposeBag)
        buttonsView.playButton.rx.tap.bind(to: textViewModel.input.start).disposed(by: disposeBag)
        buttonsView.pauseButton.rx.tap.bind(to: textViewModel.input.pause).disposed(by: disposeBag)
        buttonsView.endButton.rx.tap.bind(to: textViewModel.input.end).disposed(by: disposeBag)

        textViewModel.output.currentReadText.drive(onNext: {range in
            print(range)
        }).disposed(by: disposeBag)
    }
}
