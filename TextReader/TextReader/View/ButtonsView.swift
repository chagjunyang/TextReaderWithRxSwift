//
//  ButtonsView.swift
//  TextReader
//
//  Created by cjyang on 2019/11/14.
//  Copyright © 2019 NHN PAYCO. All rights reserved.
//

import UIKit

class ButtonsView: UIView {
    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30
        
        self.addSubview(stackView)
        
        return stackView
    }()
    
    lazy var playButton: UIButton = {
        return self.defaultButton(title: "재생")
    }()
    
    lazy var pauseButton: UIButton = {
        return self.defaultButton(title: "정지")
    }()
    
    lazy var endButton: UIButton = {
        return self.defaultButton(title: "종료")
    }()
    
    fileprivate func defaultButton(title: String) -> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = .black
        button.clipsToBounds = true
        
        self.stackView.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 80)
            ])
        
        return button
    }
    
    func buildUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.buildUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
