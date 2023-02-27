//
//  LibManager.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/21.
//

import Foundation
import Toast_Swift
import CocoaLumberjack
import CoreTelephony
import RxSwift
import Alamofire

/// 三方库管理
class LibManager: NSObject {
    /// 单例对象
    static let shared = LibManager()
    /// 网络权限监听
    let cellularData = CTCellularData()
    /// 当前活跃窗口
    var activityWindow: UIWindow?
    /// 默认为初始化第三方库
    var initCommenLibraryFinish = false
    /// 网络状态监听
    let networkManager = NetworkReachabilityManager()
    
    //MARK: -- public func
    
    /// 初始化基本元素(日志和网络监听)
    /// - Parameter window: window
    func setupBaseConfig(window: UIWindow?){
        activityWindow = window
        initDDLog()
        starNetworkMonitor()
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
    
    /// 启动网络监听
    private func starNetworkMonitor() {
        cellularData.cellularDataRestrictionDidUpdateNotifier = { [self]state in
            switch state
            {
            case .notRestricted:
                DDLogDebug("网络已授权")
                if initCommenLibraryFinish == false
                {
                    initCommenLibrary()
                }
                break
            case .restricted:
                DDLogError("请到设置中配置网络权限")
                activityWindow?.makeToast("请到设置中配置网络权限")
                break
            case .restrictedStateUnknown:
                DDLogError("网络权限未知")
                activityWindow?.makeToast("网络权限未知")
                break
            default:
                break
            }
        }
        
        
        networkManager?.startListening(onUpdatePerforming: { [self] status in
            switch status
            {
            case .unknown:
                DDLogError("网络状态未知")
                break
            case .notReachable:
                DDLogError("网络状态不可达")
                break
            case .reachable(_):
                DDLogDebug("网络已联通")
                if initCommenLibraryFinish == false
                {
                    initCommenLibrary()
                }
                break
            }
        })
        
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
        }
    }
    
    func onReq(_ req: BaseReq) {
        print("接收到微信消息=\(req)")
    }
    
    func onNeedGrantReadPasteBoardPermission(with openURL: URL, completion: @escaping WXGrantReadPasteBoardPermissionCompletion) {
        
    }
}
