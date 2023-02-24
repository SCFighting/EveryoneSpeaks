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
import CocoaLumberjack
final class LoginViewModel: ViewModelType
{
    /// 实现ViewModelType协议
    struct Input {
        /// 微信登录
        let wechatLogin: AnyObserver<Void>
    }
    struct Output {
        /// 微信登录结果
        let wechatLoginResult:Observable<Bool>
    }
    /// 输入
    var input: Input
    /// 输出
    var output: Output
    
    
    /// 私有属性用于内部初始化
    private let wechatLoginSubject = PublishSubject<Void>()
    /// 网络请求
//    let provider = MoyaProvider<Service>();
    /// 微信平台获取到的access_token
    var access_token:String?
    
    init(provider:MoyaProvider<Service>) {
        self.input = Input(wechatLogin: wechatLoginSubject.asObserver())
        let wechatLoginResultOut = wechatLoginSubject.asObservable().map({
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "renrenjiang.cn"
            WXApi.send(req)
        }).flatMapLatest({
            NotificationCenter.default.rx.notification(Notification.Name("SendAuthResp"))
        }).map({notification -> Notification in
            if let error = notification.object as? CustomError
            {
                throw(error)
            }
            else
            {
                return notification
            }
        }).flatMapLatest({notification -> Single<Response> in
            return provider.rx.request(.wechatAccessToken(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: notification.object as! String, grant_type: "authorization_code"))
        }).map({response -> WechatAccessModel in
            if let model = response.data.kj.model(WechatAccessModel.self),model.expires_in > 0
            {
                return model
            }
            throw(CustomError.baseError(errorCode: nil, errorMessage: "微信授权获取access_token失败"))
        }).flatMapLatest({ accessModel -> Single<Response> in
            return provider.rx.request(.wechatUserInfo(accessToken: accessModel.access_token, openid: accessModel.openid))
        }).map({_ -> Bool in
            return true
        })
        self.output = Output(wechatLoginResult: wechatLoginResultOut)
    }
}
