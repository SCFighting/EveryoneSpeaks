//
//  HomeSubViewModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/10.
//

import Foundation

final class HomeSubViewModel:ViewModelProjectType
{
    static let disposbag = DisposeBag()
    static let provider = MoyaProvider<Service>()
    struct Input {
        let viewDidload: AnyObserver<Int>
    }
    struct Output {
        let dataSource: Observable<[ActivityModel]>
    }
    
    var input: Input
    var output: Output
    
    private let viewDidloadSubject = PublishSubject<Int>()
    
    init() {
        self.input = Input(viewDidload: viewDidloadSubject.asObserver())
        let result = viewDidloadSubject.asObservable().flatMapLatest({channel_id ->Observable<[ActivityModel]> in
            return Self.provider.rx.request(.recommentActivityForChannel(channel_id: channel_id, parameters: ["type":"all","pageSize":10000])).map({response -> Response in
                if let json = try? response.mapJSON() as? Dictionary<String,Any>,json.keys.contains("activities"),
                   let data = try? JSONSerialization.data(withJSONObject: json["activities"]!)
                {
                    return Response(statusCode: response.statusCode, data: data)
                }
                return response
            }).mapArray(ActivityModel.self).asObservable()
        })
        
        self.output = Output(dataSource: result)
    }
    
}
