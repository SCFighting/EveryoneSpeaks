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
    let networkManage = NetworkReachabilityManager()
    var networkStatus: Observable<NetWorkStatus> {
        let status = Observable.create { observer in
            NetworkMonitor.shared.networkManage?.startListening(onQueue: DispatchQueue.main, onUpdatePerforming: { status in
                switch status
                {
                case .unknown:
                    DDLogError("网络状态未知")
                    observer.onNext(NetWorkStatus.unknown)
                    break
                case .notReachable:
                    DDLogError("网络状态不可达")
                    let cellular = CTCellularData()
                    if cellular.restrictedState == .restricted
                    {
                        observer.onNext(NetWorkStatus.restricted)
                    }
                    else if cellular.restrictedState == .restrictedStateUnknown
                    {
                        observer.onNext(NetWorkStatus.unknown)
                    }
                    else
                    {
                        observer.onNext(NetWorkStatus.notReachable)
                    }
                    break
                case .reachable(let type):
                    DDLogDebug("网络已联通")
                    switch type
                    {
                    case .cellular:
                        observer.onNext(NetWorkStatus.reachable(netType: "移动网络"))
                        break
                    case .ethernetOrWiFi:
                        observer.onNext(NetWorkStatus.reachable(netType: "WIFI网络"))
                        break
                    }
                    break
                }
            })
            return Disposables.create()
        }
        return status
    }
}
