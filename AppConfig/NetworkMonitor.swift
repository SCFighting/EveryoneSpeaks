//
//  NetworkMonitor.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/3.
//

import Foundation
import CoreTelephony
import Alamofire

enum NetWorkStatus {
    case unknown //未知网络状态
    case notReachable//未连通
    case reachable(netType: String) //WiFi|4G 连通 关联类型
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    let networkManage = NetworkReachabilityManager()
    var networkStatus = PublishSubject<NetWorkStatus>()
    /// 网络是否可用
    var networkEnable = false
    
    private init(){}
    
    
    func starNetWorkMonitor(){
        
        /// 监听网络状态改变
        self.networkManage?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { [self] status in
            switch status
            {
            case .unknown:
                DDLogError("网络状态未知")
                networkEnable = false
                networkStatus.onNext(NetWorkStatus.unknown)
                break
            case .notReachable:
                DDLogError("网络状态不可达")
                networkEnable = false
                networkStatus.onNext(NetWorkStatus.notReachable)
                break
            case .reachable(let type):
                DDLogDebug("网络已联通")
                networkEnable = true
                switch type
                {
                case .cellular:
                    networkStatus.onNext(NetWorkStatus.reachable(netType: "移动网络"))
                    break
                case .ethernetOrWiFi:
                    networkStatus.onNext(NetWorkStatus.reachable(netType: "WIFI网络"))
                    break
                }
                break
            }
        })
    }
    
    func becameActivite(){
        switch networkManage?.status {
        case .unknown:
            DDLogError("网络状态未知")
            networkEnable = false
            networkStatus.onNext(NetWorkStatus.unknown)
            break
        case .notReachable:
            DDLogError("网络状态不可达")
            networkEnable = false
            networkStatus.onNext(NetWorkStatus.notReachable)
            break
        case .reachable(let type):
            DDLogDebug("网络已联通")
            networkEnable = true
            switch type
            {
            case .cellular:
                networkStatus.onNext(NetWorkStatus.reachable(netType: "移动网络"))
                break
            case .ethernetOrWiFi:
                networkStatus.onNext(NetWorkStatus.reachable(netType: "WIFI网络"))
                break
            }
            break
        default :
            break
        }
    }
}
