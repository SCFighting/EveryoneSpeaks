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
    var input: Input
    let provider = MoyaProvider<Service>()
    var output: Output
    let dispos = DisposeBag()
    
    struct Input {
    }
    struct Output {
    }
    
    init(input: Input, output: Output) {
        self.input = input
        self.output = output
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "SendAuthResp")).flatMapLatest({ [self]notification ->Single<Response> in
//            let provider = MoyaProvider<Service>()
            let result = provider.rx.request(.wechatAccessToken(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: notification.object as? String ?? "error" , grant_type: "authorization_code"))
            return result
        }).subscribe(onNext: {response in
            let model = response.data.kj.model(WechatAccessModel.self)
            print("model.access_token=\(String(describing: model?.access_token))")
        }).disposed(by: dispos)
//        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "SendAuthResp")).flatMapLatest { [self] notice in
//            provider.rx.request(.wechatAccessToken(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: notice.object as? String ?? "error", grant_type: "authorization_code"))
//        }.subscribe(onNext: {respon in
//            print("r=\(respon)")
//        }).disposed(by: dispos)
    }

    
    /// 发送微信授权登录
    func sendWxAuthRequest()
    {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "renrenjiang.cn"
        WXApi.send(req)
    }
    
//    func queryWechatAccessToken(code: String)
//    {
//        let provider = MoyaProvider<Service>()
//        provider.rx.request(.wechatAccessToken(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: code, grant_type: "authorization_code")).subscribe(onSuccess: {response in
//            if let accessModel = response.data.kj.model(WechatAccessModel.self)
//            {
//
//            }
//
//        },onFailure: {error in
//            print("error = \(error)")
//        }).disposed(by: disposbag)
//    }
    
}

