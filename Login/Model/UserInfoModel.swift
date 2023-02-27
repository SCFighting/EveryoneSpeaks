//
//  UserInfoModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/27.
//

import UIKit

class Token: BaseModel
{
    var id = 0
    var exp = 0
    var userId = 0
}

class Config: BaseModel {
    var auditPassed = false
    
}

class UserInfoModel: BaseModel {
    
    var user_id = 0
}

class AppLoginInfoModel: BaseModel {
    var refresh_token: Token?
    var token: Token?
    var config: Config!
    var user: UserInfoModel!
}
