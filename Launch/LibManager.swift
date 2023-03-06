//
//  LibManager.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/21.
//

import Foundation
import CoreTelephony

/// 三方库管理
class LibManager: NSObject {
    /// 单例对象
    static let shared = LibManager()
    /// 当前活跃窗口
    var activityWindow: UIWindow?
    /// 默认未初始化第三方库
    var initCommenLibraryFinish = false
    /// 自动管理
    let disposbag = DisposeBag()
    
    
    
    //MARK: -- public func
    
    /// 初始化libmanager
    /// - Parameter window: window
    func setupFor(window: UIWindow?){
        activityWindow = window
        
        //初始化日志,并启用日志系统
        initDDLog()
        
        // 订阅网络状态
        NetworkMonitor.shared.networkStatus.subscribe(onNext: { [self] status in
            switch status
            {
            case .unknown:
                activityWindow?.makeToast("网络状态未知")
                break
            case .notReachable:
                activityWindow?.makeToast("网络未连接")
                break
            case .reachable(netType: let str):
                activityWindow?.makeToast("已连接到\(str)")
                setupPrivacyAndSDK()
            }
        }).disposed(by: disposbag)
        
        //监听网络
        NetworkMonitor.shared.starNetWorkMonitor()
        
    }
        
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DispatchQueue.main.async {
            WXApi.handleOpen(url, delegate: LibManager.shared)
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        DispatchQueue.main.async {
            WXApi.handleOpenUniversalLink(userActivity, delegate: self)
        }
        return true
    }
    
    deinit {
        print("ssssssssssssss")
    }
    
    //MARK: -- private func
    
    /// 初始化DDLog
    private func initDDLog()
    {
        DDOSLogger.sharedInstance.logFormatter = CustomLogFormatter()
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.logFormatter = CustomLogFormatter()
        fileLogger.rollingFrequency = 7 * 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    private func setupPrivacyAndSDK()
    {
        if initCommenLibraryFinish == false
        {
            initCommenLibrary()
        }
        if UserInfoConstantConfig.showPrivacy == false,let activityWindow
        {
            let privacyView = PrivacyView()
            activityWindow.addSubview(privacyView)
            privacyView.snp.makeConstraints { make in
                make.edges.equalTo(activityWindow)
            }
        }
    }
    
    
    /// 初始化第三方库
    /// - Parameter window: window
    private func initCommenLibrary()
    {
        DispatchQueue.main.async { [self] in
            /// 初始化微信SDK
            initWechatSDK()
        }
    }
    
    /// 初始化微信SDK
    private func initWechatSDK()
    {
//        WXApi.startLog(by: .detail) { str in
//            DDLogDebug("微信SDKLog: = \(str)")
//        }
        
        /// 初始化微信SDK
        let result = WXApi.registerApp(AuthorConstConfig.wxAppid, universalLink: AuthorConstConfig.wxUniversalLink)
        if result == false
        {
            DDLogError("微信SDK初始化失败")
        }
        
//        WXApi.checkUniversalLinkReady { step , result in
//            DDLogDebug("step = \(step), result = \(result)")
//        }
    }
    
    
    
    private override init() {}
    override func copy() -> Any {
        return self // SingletonClass.shared
    }
    
    override func mutableCopy() -> Any {
        return self // SingletonClass.shared
    }
}

@available (iOS 13,*)
extension LibManager
{
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
}

extension LibManager: WXApiDelegate
{
    
    func onResp(_ resp: BaseResp) {
        DDLogDebug("微信回调消息=\(resp)")
        if let authResp = resp as? SendAuthResp
        {
            if authResp.errCode == 0
            {
                if let code = authResp.code
                {
                    DDLogDebug("用户同意微信授权,code = \(code)")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "SendAuthResp"), object: code)
                }
                else
                {
                    DDLogError("用户同意微信授权,但未获取到code")
                    let error = CustomError.baseError(errorCode: nil, errorMessage: "用户同意微信授权,但未获取到code")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "SendAuthResp"), object: error)
                }
            }
            else if authResp.errCode == -4 //用户拒绝授权
            {
                DDLogError("用户拒绝微信授权")
                let error = CustomError.baseError(errorCode: -4, errorMessage: "用户拒绝授权")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SendAuthResp"), object: error)
            }
            else if authResp.errCode == -2 //用户取消
            {
                DDLogError("用户取消微信授权")
                let error = CustomError.baseError(errorCode: -2, errorMessage: "用户取消授权")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SendAuthResp"), object: error)
            }
            else if authResp.errCode == -1 //没有网络
            {
                DDLogError("当前用户网络不可达")
                let error = CustomError.baseError(errorCode: -1, errorMessage: "当前用户网络不可达")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "SendAuthResp"), object: error)
            }
        }
    }
    
    func onReq(_ req: BaseReq) {
        print("接收到微信消息=\(req)")
    }
}
