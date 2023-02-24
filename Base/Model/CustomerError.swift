//
//  CustomerError.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/24.
//

import Foundation

enum CustomError: Error
{
    /// 通用的基础错误
    case baseError(errorCode:Int?, errorMessage:String?)
}
