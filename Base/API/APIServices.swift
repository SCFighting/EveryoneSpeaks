//
//  APIServices.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/14.
//

import Foundation
import Moya

enum Service {
    case login
}

extension Service: TargetType
{
    var sampleData: Data {
        return Data()
    }
    
    var baseURL: URL {
        URL(string: "https://renrenjiang.cn")!
    }
    
    var path: String {
        switch self
        {
        case .login:
            return "/api/v3/system/promotion/banner"
        }
    }
    
    var method: Moya.Method {
        switch self
        {
        case .login:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self
        {
        case .login:
            return .requestPlain
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
