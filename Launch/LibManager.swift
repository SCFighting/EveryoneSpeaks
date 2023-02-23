//
//  LibManager.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/21.
//

import Foundation


/// 三方库管理
class LibManager: NSObject {
    static let shared = LibManager()
    /// 初始化第三方库
    /// - Parameter window: window
    func initThirdPardLibrary(window: UIWindow?)
    {
        /// 初始化微信SDK
        WXApi.registerApp(AuthorConstConfig.wxAppid, universalLink: AuthorConstConfig.wxUniversalLink)
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
        print("微信回调消息=\(resp)")
        if let authResp = resp as? SendAuthResp
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "SendAuthResp"), object: authResp.code)
        }
    }
    
    func onReq(_ req: BaseReq) {
        print("接收到微信消息=\(req)")
    }
    
    func onNeedGrantReadPasteBoardPermission(with openURL: URL, completion: @escaping WXGrantReadPasteBoardPermissionCompletion) {
        
    }
}
