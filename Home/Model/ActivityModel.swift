//
//  ActivityModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/9.
//

import UIKit

class ActivityModel: BaseModel {
    var background = ""
    var creator: UserInfoModel!
    var id = 0
    var title = ""
    /// 课程预订人数
    var reservation_count = 0
    var price: Float = 0.0
}
