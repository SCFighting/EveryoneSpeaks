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
    case restricted //未获取网络权限
    case notReachable//已授权未连通
    case reachable(netType: String) //WiFi 连通 关联类型
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    let cellular = CTCellularData()
    let networkManage = NetworkReachabilityManager()
    var networkStatus = PublishSubject<NetWorkStatus>()
    /// 网络是否可用
    var networkEnable = false
    
    private init(){}

    
    func starNetWorkMonitor(){
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
                if cellular.restrictedState == .restricted
                {
                    networkStatus.onNext(NetWorkStatus.restricted)
                }
                else if cellular.restrictedState == .restrictedStateUnknown
                {
                    networkStatus.onNext(NetWorkStatus.unknown)
                }
                else
                {
                    networkStatus.onNext(NetWorkStatus.notReachable)
                }
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
}
