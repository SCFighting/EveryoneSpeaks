//
//  LoginViewModel.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/8.
//
import RxSwift
import RxCocoa
final class LoginViewModel: ViewModelType
{
    struct Input {
        let wechatLogin: AnyObserver<Void>
        
    }
    struct Output {
        let wechatLoginResult: Driver<String>
    }
    
    let input: Input
    let output: Output
    private let wechatLoginSubject = PublishSubject<Void>()

    init()
    {
        
        let result = wechatLoginSubject.map { () in
            return "ss"
        }.asDriver(onErrorJustReturn: "error")
        self.output = Output(wechatLoginResult: result)
        self.input = Input(wechatLogin: wechatLoginSubject.asObserver())
    }
    
}

