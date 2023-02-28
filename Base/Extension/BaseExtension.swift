//
//  BaseExtension.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/24.
//

import Foundation

class CustomLogFormatter:NSObject, DDLogFormatter
{
    func format(message logMessage: DDLogMessage) -> String? {
        var logInfo = ""
        switch logMessage.flag
        {
        case .error:
            logInfo = "[ERROR😡]--->"
            break
        case .warning:
            logInfo = "[WARN😅]--->"
        case .info:
            logInfo = "[INFO😀]--->"
            break
        case .debug:
            logInfo = "[DEBUG😄]--->"
            break
        case .verbose:
            logInfo = "[VERBOSE😇]--->"
            break
        default:
            break
        }
        
        //拼接日期
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        logInfo.append("[\(dateFormater.string(from: logMessage.timestamp))]--->")
        
        //拼接文件名称
        logInfo.append("[文件名称: \(logMessage.fileName)]--->")
        
        //拼接方法名称
        if let function = logMessage.function
        {
            logInfo.append("[方法名称: \(function)]--->")
        }
        
        //拼接代码行数
        logInfo.append("[代码行数: \(String(logMessage.line))]--->")
        
        //拼接具体日志
        logInfo.append(logMessage.message)
        //换行
        logInfo.append("\n")
        
        return logInfo
    }
    
    
}

