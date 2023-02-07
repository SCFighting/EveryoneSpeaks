//
//  Navigator.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/7.
//

import UIKit
import RTRootNavigationController

class Navigator: NSObject {
    static let shared = Navigator()
    var avtivityWindow: UIWindow?
    
    /// 为window初始化根控制器
    /// - Parameter window: window
    func initRootController(for window: UIWindow?){
        guard let window else {
            return
        }
        avtivityWindow = window
        // 已登录
        if let token = UserDefaults.standard.object(forKey: UserInfoConstantConfig.token) as? String, !token.isEmpty, UserDefaults.standard.integer(forKey: UserInfoConstantConfig.tokenDeadLine) > Int(NSDate().timeIntervalSince1970)
        {
            
        }
        //未登录
        else
        {
            let nai = RTRootNavigationController(rootViewControllerNoWrapping: LoginController())
            avtivityWindow?.rootViewController = nai
            avtivityWindow?.makeKeyAndVisible()
        }
    }
    
    private override init() {
    }
    override class func copy() -> Any {
        return self
    }
    override class func mutableCopy() -> Any {
        return self
    }
}
