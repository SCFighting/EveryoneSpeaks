//
//  HomeCellViewModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/11.
//

import Foundation
final class HomeCellViewModel: ViewModelProjectType
{
    struct Input {
        let activity: AnyObserver<ActivityModel>
    }
    struct Output {
        let posterImage: Observable<UIImage>
        let title: Observable<String>
        let reservation: Observable<String>
        let avatar: Observable<UIImage>
        let nickName: Observable<String>
        let price: Observable<String>
    }
    let input: Input
    let output: Output
    private let activitySubject = PublishSubject<ActivityModel>()
    init()
    {
        input = Input(activity: activitySubject.asObserver())
        
        let posterParameter = activitySubject.asObservable().flatMap({activity ->Observable<UIImage> in
            Observable.create { observer in
                SDWebImageDownloader.shared.downloadImage(with: URL(string: activity.background)) { image, _ , _ , _ in
                    if let image
                    {
                        observer.onNext(image)
                    }
                }
                return Disposables.create()
            }
        })
        
        let titleParameter = activitySubject.asObservable().map { activity in
            activity.title
        }
        
        let reservationParameter = activitySubject.asObservable().map { activity in
            "\(activity.reservation_count)人订阅"
        }
        
        let avatarParameter = activitySubject.asObservable().flatMap({activity ->Observable<UIImage> in
            Observable.create { observer in
                SDWebImageDownloader.shared.downloadImage(with: URL(string: activity.creator.avatar)) { image, _ , _ , _ in
                    if let image
                    {
                        observer.onNext(image)
                    }
                }
                return Disposables.create()
            }
        })
        
        let nickNameParameter = activitySubject.asObservable().map { activity in
            activity.creator.nickname
        }
        
        let priceParameter = activitySubject.asObservable().map { activity in
            var price = ""
            if activity.price == 0
            {
                price.append("免费")
            }
            else
            {
                if fmodf(activity.price, 1) == 0
                {
                    return String(format: "%.0f", activity.price)
                }
                else if fmodf(activity.price * 10, 1) == 0
                {
                    return String(format: "%.1f", activity.price)
                }
                else
                {
                    return String(format: "%.2f", activity.price)
                }
            }
            return price
        }
        
        output = Output(posterImage: posterParameter, title: titleParameter, reservation: reservationParameter, avatar: avatarParameter, nickName: nickNameParameter,price: priceParameter)
    }
    
}
