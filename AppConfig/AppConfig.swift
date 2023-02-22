//
//  AppConfig.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/7.
//

import UIKit

/// 用于布局的常量
struct LayoutConstantConfig
{
    /// 屏幕宽度
    static let screenWidth = UIScreen.main.bounds.size.width
    /// 屏幕高度
    static let screenHeight = UIScreen.main.bounds.size.height
    /// 状态栏高度
    static var statusBarHeight: CGFloat{
        if #available(iOS 15.0, *)
        {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,let statusBarManager = scene.statusBarManager
            {
                return statusBarManager.statusBarFrame.size.height
            }
            else
            {
                return 0
            }
        }
        else if #available(iOS 13.0, *)
        {
            return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        }
        else
        {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    /// 导航栏高度
    static let navigationBarHeight = 44.0
    /// 导航栏+状态栏高度
    static var navigationFullHeight: CGFloat{
        navigationBarHeight+statusBarHeight
    }
    /// 底部安全区域高度
    static var safeDistanceBottomHeight: CGFloat{
        if #available(iOS 13.0, *)
        {
            return SceneDelegate.shared?.window?.safeAreaInsets.bottom ?? 0
        }
        else if #available(iOS 11.0, *)
        {
            return AppDelegate.shared?.window?.safeAreaInsets.bottom ?? 0
        }
        else
        {
            return 0
        }
    }
    /// 底部tabbar高度
    static let tabBarHeight = 49.0
    /// 底部tabbar高度+底部安全区域高度
    static var tabBarFullHeight: CGFloat{
        return tabBarHeight+safeDistanceBottomHeight
    }
}


/// 用户信息常量
struct UserInfoConstantConfig {
    /// token对应的key
    static let token = "token"
    /// deadLine对应的key
    static let tokenDeadLine = "deadLine"
}

/// 第三方库授权常量
struct AuthorConstConfig
{
    
    /// 微信平台appid
    static let wxAppid = "wxf2f15e0298ede2f9"
    static let wxsecret = "13d141773bab3ad7d74fc5fc5e764283"
    ///  微信开发者Universal Link
    static let wxUniversalLink = "https://apple.renrenjiang.cn/"
}
