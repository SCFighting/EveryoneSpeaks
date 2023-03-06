//
//  ViewModelProtocol.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/8.
//

protocol ViewModelProjectType{
    associatedtype Input      // 输入， 遵守时需要定义
    associatedtype Output     // 输出， 遵守时需要定义
    
    var input: Input{get}
    var output: Output{get}
}

protocol ViewModelNomalType {
    associatedtype Input      // 输入， 遵守时需要定义
    associatedtype Output     // 输出， 遵守时需要定义
    func transform(input: Input) -> Output         // 转换， 通过输入转化（绑定与逻辑）到输出
}
