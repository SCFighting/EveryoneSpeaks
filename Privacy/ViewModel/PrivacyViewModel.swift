//
//  PrivacyViewModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import Foundation

enum PrivacyType {
    ///用户协议
    case userPrivacy
    /// 隐私政策
    case privacyPolicy
    /// 儿童隐私
    case childPrivacy
}

class PrivacyViewModel: ViewModelType {
    struct Input {
        /// 隐私协议点击
        let privacy: AnyObserver<PrivacyType>
        /// 同意点击
        let confirm: AnyObserver<Void>
        ///  拒绝点击
        let refuse: AnyObserver<Void>
    }
    struct Output {
        /// 协议点击输出
        let privacy: Observable<PrivacyType>
        /// 同意点击输出
        let confirm: Observable<Void>
        /// 拒绝点击输出
        let refuse: Observable<Void>
    }
    var input: Input
    var output:Output
    
    private let privacySubject = PublishSubject<PrivacyType>()
    private let confirmSubject = PublishSubject<Void>()
    private let refuseSubject = PublishSubject<Void>()
    init() {
        self.input = Input(privacy: privacySubject.asObserver(), confirm: confirmSubject.asObserver(), refuse: refuseSubject.asObserver())
        self.output = Output(privacy: privacySubject.asObservable(), confirm: confirmSubject.asObserver(), refuse: refuseSubject.asObservable())
    }
}
