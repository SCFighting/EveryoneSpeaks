//
//  APIServices.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/14.
//

import Foundation
import Moya

enum Service {
    case wechatLogin(appid: String,secret: String,code: String,grant_type: String)
}

extension Service: TargetType
{
    var baseURL: URL {
        switch self
        {
        case .wechatLogin(_, _, _, _):
            return URL(string: "https://api.weixin.qq.com")!
        }
    }
    
    var path: String {
        switch self
        {
        case .wechatLogin(_, _, _, _):
            return "/sns/oauth2/access_token"
        }
    }
    
    var method: Moya.Method {
        switch self
        {
        case .wechatLogin(_, _ , _ , _):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self
        {
        case .wechatLogin(let appid, let secret, let code, let grant_type):
            return .requestParameters(parameters: ["appid":appid,"secret":secret,"code":code,"grant_type":grant_type], encoding: URLEncoding.queryString)
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
