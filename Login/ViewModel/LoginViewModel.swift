//
//  LoginViewModel.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/8.
//
import RxSwift
import RxCocoa
import Moya
final class LoginViewModel: ViewModelType
{
    struct Input {
        let login: AnyObserver<MoyaProvider<Service>>
    }
    struct Output {
        let loginResult: Observable<String>
    }
    
    private let loginSubject = ReplaySubject<MoyaProvider<Service>>.create(bufferSize: 1)
    
    let input: Input
    let output: Output
  
    init() {
//        loginSubject.ma
        let str = loginSubject.map { provider in
            var message = "Couldn't access API"
            provider.request(.login) { result in
                
                if case let .success(response) = result
                {
                    let jsonString = try? response.mapString()
                    message = jsonString ?? message
                }
                
            }
            return message
        }
        self.output = Output(loginResult: str)
        self.input = Input(login: loginSubject.asObserver())
    }
    
}

