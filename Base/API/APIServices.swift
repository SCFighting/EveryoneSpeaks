//
//  APIServices.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/14.
//

import Foundation

enum Service {
    //MARK: -- 登录相关API
    /// 微信平台获取access_token
    case wechatAccessToken(appid: String, secret: String, code: String, grant_type: String)
    /// 微信平台获取用户信息
    case wechatUserInfo(accessToken: String, openid: String)
    /// 三方平台授权登录
    case authLogin(app: String, nickname: String?, uuid: String?, openid: String?, accessToken: String?)
    
    //MARK: -- 系统开关配置
    /// 开关查询
    case systemSwitchConfig(include: String)
    
    //MARK: -- 首页相关api
    /// 频道分类
    case channelClassification
    /// 频道下推荐的课程
    case recommentActivityForChannel(channel_id: Int, parameters: [String:Any]?)
    
}

extension Service: TargetType
{
    var baseURL: URL {
        switch self
        {
        case .wechatAccessToken(_, _, _, _), .wechatUserInfo(accessToken: _ , openid: _ ):
            return URL(string: "https://api.weixin.qq.com")!
        default:
            return URL(string: "https://api.renrenjiang.cn")!
            break
        }
    }
    
    var path: String {
        switch self
        {
        case .wechatAccessToken(_, _, _, _):
            return "/sns/oauth2/access_token"
        case .wechatUserInfo(accessToken: _ , openid: _ ):
            return "/sns/userinfo"
        case .authLogin(app: _, nickname: _, uuid: _, openid: _, accessToken: _ ):
            return "/api/v3/account/apple/auth"
            
        case .systemSwitchConfig(include: _):
            return "/api/v3/system/switch"
            
        case .channelClassification:
            return "/api/v3/channels/list"
        case let .recommentActivityForChannel(channel_id, _):
            return "/api/v3/channels/\(channel_id)/activities"
        }
    }
    
    var method: Moya.Method {
        switch self
        {
        case .wechatAccessToken(_, _ , _ , _),
            .wechatUserInfo(accessToken: _ , openid: _ ),
            .systemSwitchConfig(include: _),
            .channelClassification,
            .recommentActivityForChannel(channel_id: _, parameters: _):
            return .get
        case .authLogin(app: _, nickname: _, uuid: _, openid: _, accessToken: _):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self
        {
        case .wechatAccessToken(let appid, let secret, let code, let grant_type):
            return .requestParameters(parameters: ["appid":appid,"secret":secret,"code":code,"grant_type":grant_type], encoding: URLEncoding.queryString)
            
        case .wechatUserInfo(let accessToken , let openid):
            return .requestParameters(parameters: ["access_token":accessToken, "openid":openid], encoding: URLEncoding.queryString)
            
        case let .authLogin(app, nickname, uuid, openid, accessToken):
            var parameters = [String:Any]()
            parameters["app"] = app
            if let nickname,!nickname.isEmpty
            {
                parameters["nickname"] = nickname
            }
            if let uuid
            {
                parameters["uuid"] = uuid
            }
            if let openid
            {
                parameters["openid"] = openid
            }
            if let accessToken
            {
                parameters["access_token"] = accessToken
            }
            parameters["version"] = "4.2.50"
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case let .systemSwitchConfig(include):
            return .requestParameters(parameters: ["include":include,"user_id":UserInfoConstantConfig.currentUserID], encoding: URLEncoding.queryString)
            
        case .channelClassification:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case let .recommentActivityForChannel(_, parameters):
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}

private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        Data(self.utf8)
    }
}
