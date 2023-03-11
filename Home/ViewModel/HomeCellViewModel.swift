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
        output = Output(posterImage: posterParameter, title: titleParameter, reservation: reservationParameter, avatar: avatarParameter, nickName: nickNameParameter)
    }
    
}
