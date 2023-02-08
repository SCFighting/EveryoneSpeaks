//
//  ViewModelProtocol.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/8.
//

protocol ViewModelType{
    associatedtype Input
    associatedtype Output
    
    var input: Input{get}
    var output: Output{get}
}
