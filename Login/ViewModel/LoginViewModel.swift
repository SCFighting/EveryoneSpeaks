//
//  LoginViewModel.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/8.
//
import RxSwift
import RxCocoa
import Moya
import RxKakaJSON
final class LoginViewModel: ViewModelType
{
    
    struct Input {
        /// 微信授权token
        let wechatAccessToken: AnyObserver<WechatAccessModel>
        let login: AnyObserver<MoyaProvider<Service>>
    }
    struct Output {
        let loginResult: Observable<String>
    }
    
    private let wechatAccessTokenSubject = PublishSubject<WechatAccessModel>()
    private let wechatAuthCodeSubject = PublishSubject<String>()
    private let loginSubject = ReplaySubject<MoyaProvider<Service>>.create(bufferSize: 1)
    let disposbag = DisposeBag()
    let input: Input
    let output: Output
  
    init() {
//        loginSubject.ma
        let str = loginSubject.map { provider in
            var message = "Couldn't access API"
//            provider.request(.login) { result in
//                
//                if case let .success(response) = result
//                {
//                    let jsonString = try? response.mapString()
//                    message = jsonString ?? message
//                }
//                
//            }
            return message
        }
       let ss =  wechatAccessTokenSubject.asObservable().map({wechatAccessModel -> String in
            return wechatAccessModel.access_token
       })
        
        self.output = Output(loginResult: str)
        self.input = Input(wechatAccessToken: wechatAccessTokenSubject.asObserver(), login: loginSubject.asObserver())
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "SendAuthResp")).subscribe(onNext: {notification in
            if let sendAuthResp = notification.object as? SendAuthResp
            {
                let provider = MoyaProvider<Service>()
                let ss = provider.rx.request(.wechatLogin(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: sendAuthResp.code!, grant_type: "authorization_code")).flatMap { response in
                    let model = response.data.kj.model(WechatAccessModel.self)
                    {
                        return Single<WechatAccessModel>.create { single in
                            single(.success(model!))
                            return Disposables.create()
                        }
                    }
                }.subscribe { <#_#> in
                    <#code#>
                }
                
                
            
            }
        }).disposed(by: disposbag)
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "SendAuthResp")).map({notification -> String in
            if let sendAuthResp = notification.object as? SendAuthResp
            {
                let provider = MoyaProvider<Service>()
                let ss = provider.rx.request(.wechatLogin(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: sendAuthResp.code!, grant_type: "authorization_code"))
                
            
            }
            else
            {
                return ""
            }
        }).flatMap{({str  in
            return str+"ddd"
        })}
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "SendAuthResp")).subscribe(onNext: { [weak self]notification in
            print("notification = \(notification)")
            if let sendAuthResp = notification.object as? SendAuthResp
            {
                /// 用户同意微信授权
                if sendAuthResp.errCode == 0,let code = sendAuthResp.code
                {
                    self?.queryWechatAccessToken(code: code)
                }
                /// 用户拒绝微信授权
                else if sendAuthResp.errCode == -4
                {
                    
                }
                /// 用户取消微信授权
                else if sendAuthResp.errCode == -2
                {
                    
                }
            }
        }).disposed(by: disposbag)
    }
    
    /// 发送微信授权登录
    func sendWxAuthRequest()
    {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "renrenjiang.cn"
        WXApi.send(req)
    }
    
    func queryWechatAccessToken(code: String)
    {
        let provider = MoyaProvider<Service>()
        provider.rx.request(.wechatLogin(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: code, grant_type: "authorization_code")).subscribe(onSuccess: {response in
            if let accessModel = response.data.kj.model(WechatAccessModel.self)
            {
                
            }
            
        },onFailure: {error in
            print("error = \(error)")
        }).disposed(by: disposbag)
    }
    
}

