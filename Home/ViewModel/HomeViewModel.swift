//
//  HomeViewModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/8.
//

import Foundation
final class HomeViewModel: ViewModelProjectType
{
    let provider = MoyaProvider<Service>()
    static let disposbag = DisposeBag()
    
    struct Input {
        let channelModelArray: AnyObserver<[ChannelClassificationModel]>
    }
    
    struct Output
    {
        let channelNameArray: Observable<[String]>
    }
    
    var input: Input
    var output: Output
    
    private let channelModelArraySubject = PublishSubject<[ChannelClassificationModel]>()
    
    ///频道列表
    var channelListArray:[ChannelClassificationModel]?
    
    
    init()
    {
        input = Input(channelModelArray: channelModelArraySubject.asObserver())
        let out = channelModelArraySubject.asObservable().map({channelModelArray ->[String] in
            return channelModelArray.map { model in
                model.shortname
            }
        })
        output = Output(channelNameArray: out)
    }
    
    func queryChannelClassification() -> Single<[ChannelClassificationModel]> {
        provider.rx.request(.channelClassification).mapArray(ChannelClassificationModel.self)
    }
}
