//
//  ViewModelType.swift
//  TextReader
//
//  Created by cjyang on 27/11/2019.
//  Copyright © 2019 NHN PAYCO. All rights reserved.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
