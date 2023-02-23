//
//  APIServices.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/14.
//

import Foundation
import Moya

enum Service {
    //MARK: -- 登录相关API
    /// 微信平台获取access_token
    case wechatAccessToken(appid: String,secret: String,code: String,grant_type: String)
    /// 微信平台获取用户信息
    case wechatUserInfo(accessToken: String, openid: String)
    /// 三方平台授权登录
    case authLogin(app: String, nickname: String?, uuid: String?, openid: String?, accessToken: String?)
}

extension Service: TargetType
{
    var baseURL: URL {
        switch self
        {
        case .wechatAccessToken(_, _, _, _),.wechatUserInfo(accessToken: _ , openid: _ ):
            return URL(string: "https://api.weixin.qq.com")!
        case .authLogin(_, nickname: _, uuid: _, openid: _, accessToken: _):
            return URL(string: "https://api.renrenjiang.cn")!
        }
    }
    
    var path: String {
        switch self
        {
        case .wechatAccessToken(_, _, _, _),.wechatUserInfo(accessToken: _ , openid: _ ):
            return "/sns/oauth2/access_token"
        case .authLogin(app: _, nickname: _, uuid: _, openid: _, accessToken: _):
            return "/api/v3/account/apple/auth"
        }
    }
    
    var method: Moya.Method {
        switch self
        {
        case .wechatAccessToken(_, _ , _ , _),.wechatUserInfo(accessToken: _ , openid: _ ):
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
            return .requestParameters(parameters: ["access_token":accessToken, "openid":openid], encoding: JSONEncoding.default)
            
        case let .authLogin(app, nickname, uuid, openid, accessToken):
            var parameters = [String:Any]()
            parameters["app"] = app
            if let nickname
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
                parameters["accessToken"] = accessToken
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
