//
//  LibManager.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/21.
//

import Foundation
import Toast_Swift
import CocoaLumberjack

/// 三方库管理
class LibManager: NSObject {
    static let shared = LibManager()
    /// 初始化第三方库
    /// - Parameter window: window
    func initThirdPardLibrary(window: UIWindow?)
    {
        /// 初始化日志
        DDOSLogger.sharedInstance.logFormatter = CustomLogFormatter()
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.logFormatter = CustomLogFormatter()
        fileLogger.rollingFrequency = 7 * 60 * 60 * 24 
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        /// 初始化微信SDK
        let result = WXApi.registerApp(AuthorConstConfig.wxAppid, universalLink: AuthorConstConfig.wxUniversalLink)
        if result == false
        {
            DDLogError("微信SDK初始化失败")
        }
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: LibManager.shared)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
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
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "SendAuthResp"), object: "123")
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
        }
    }
    
    func onReq(_ req: BaseReq) {
        print("接收到微信消息=\(req)")
    }
    
    func onNeedGrantReadPasteBoardPermission(with openURL: URL, completion: @escaping WXGrantReadPasteBoardPermissionCompletion) {
        
    }
}
