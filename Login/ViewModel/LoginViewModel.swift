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
    /// 微信授权model
    static var accessModel = WechatAccessModel()
    static let disposebag = DisposeBag()
    /// 实现ViewModelType协议
    struct Input {
        /// 微信登录
        let wechatLogin: AnyObserver<Void>
    }
    struct Output {
        /// 微信登录结果
        let wechatLoginResult:Observable<Result<AppLoginInfoModel?,CustomError>>
    }
    /// 输入
    var input: Input
    /// 输出
    var output: Output
    
    
    /// 私有属性用于内部初始化
    private let wechatLoginSubject = PublishSubject<Void>()
    
    init(provider:MoyaProvider<Service>) {
        self.input = Input(wechatLogin: wechatLoginSubject.asObserver())
        let wechatLoginResultOut = wechatLoginSubject.asObservable().map({//发起微信授权请求
            DDLogDebug("发起微信授权请求")
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "renrenjiang.cn"
            WXApi.send(req)
        }).flatMapLatest({ _ ->Observable<Result<String,CustomError>> in  //监听微信授权回调通知
            let notificationResult = Observable.create { observer in
                DDLogDebug("监听微信授权回调通知")
                NotificationCenter.default.rx.notification(Notification.Name("SendAuthResp")).subscribe { notification in
                    if let error = notification.object as? CustomError
                    {
                        observer.onNext(Result<String,CustomError>.failure(error))
                    }
                    else
                    {
                        observer.onNext(Result<String,CustomError>.success(notification.object as! String))
                    }
                }.disposed(by: Self.disposebag)
                return Disposables.create()
            }
            return notificationResult
        }).flatMapLatest({result ->Observable<Result<String,CustomError>> in //获取access_token
            return Observable.create { observer in
                DDLogDebug("获取access_token")
                switch result
                {
                case .success(let code):
                    provider.rx.request(.wechatAccessToken(appid: AuthorConstConfig.wxAppid, secret: AuthorConstConfig.wxsecret, code: code, grant_type: "authorization_code")).subscribe(onSuccess: {response in
                        Self.accessModel.kj_m.convert(from: response.data)
                        if Self.accessModel.access_token.isEmpty == false
                        {
                            observer.onNext(Result<String,CustomError>.success(Self.accessModel.access_token))
                        }
                        else
                        {
                            observer.onNext(Result<String,CustomError>.failure(CustomError.baseError(errorCode: nil, errorMessage: "access_token获取失败")))
                        }
                    },onFailure: {error in
                        observer.onNext(Result<String,CustomError>.failure(CustomError.baseError(errorCode: nil, errorMessage: "access_token获取请求失败")))
                    }).disposed(by: Self.disposebag)
                    break
                case .failure(_):
                    observer.onNext(result)
                    break
                }
                return Disposables.create()
            }
        }).flatMapLatest({result ->Observable<Result<WechatAccessModel?,CustomError>> in //获取用户信息
            DDLogDebug("获取用户信息")
            return Observable.create { observer in
                switch result
                {
                case .success(let access_token):
                    provider.rx.request(.wechatUserInfo(accessToken: access_token, openid: Self.accessModel.openid)).subscribe(onSuccess: {response in
                        Self.accessModel.kj_m.convert(from: response.data)
                        if Self.accessModel.headimgurl.isEmpty == false
                        {
                            observer.onNext(Result<WechatAccessModel?,CustomError>.success(Self.accessModel))
                        }
                        else
                        {
                            observer.onNext(Result<WechatAccessModel?,CustomError>.failure(CustomError.baseError(errorCode: nil, errorMessage: "微信获取用户信息失败")))
                        }
                    },onFailure: {error in
                        observer.onNext(Result<WechatAccessModel?,CustomError>.failure(CustomError.baseError(errorCode: nil, errorMessage: "微信获取用户信息请求失败")))
                    }).disposed(by: Self.disposebag)
                    return Disposables.create()
                case .failure(let error):
                    observer.onNext(Result<WechatAccessModel?,CustomError>.failure(error))
                }
                return Disposables.create()
            }
        }).flatMapLatest({result -> Observable<Result<AppLoginInfoModel?,CustomError>> in // 登录人人讲服务器
            DDLogDebug("登录人人讲服务器")
            return Observable.create { observer in
                switch result
                {
                case .success(let model):
                    provider.rx.request(.authLogin(app: "wechat", nickname: model?.nickname, uuid: model?.unionid, openid: model?.openid, accessToken: model?.access_token)).subscribe(onSuccess: {response in
                        if let json = try? response.mapJSON() as? Dictionary<String,Any>,let appInfo = try? response.mapObject(AppLoginInfoModel.self)
                        {
                            if appInfo.result == "ok"
                            {
                                observer.onNext(Result<AppLoginInfoModel?,CustomError>.success(appInfo))
                            }
                            else
                            {
                                observer.onNext(Result<AppLoginInfoModel?,CustomError>.failure(CustomError.baseError(errorCode: nil, errorMessage: json["message"] as? String)))
                            }
                        }
                        else
                        {
                            observer.onNext(Result<AppLoginInfoModel?,CustomError>.failure(CustomError.baseError(errorCode: nil, errorMessage: "获取人人讲用户请求成功\(String(describing: try? response.mapString()) )")))
                        }
                    },onFailure: {error in
                        observer.onNext(Result<AppLoginInfoModel?,CustomError>.failure(CustomError.baseError(errorCode: nil, errorMessage: "获取人人讲用户请求失败")))
                    }).disposed(by: Self.disposebag)
                    break
                case .failure(let error):
                    observer.onNext(Result<AppLoginInfoModel?,CustomError>.failure(error))
                    break
                }
                return Disposables.create()
            }
        })
        self.output = Output(wechatLoginResult: wechatLoginResultOut)
    }
}
