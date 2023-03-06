//
//  PrivacyViewModel.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import Foundation
import ActiveLabel

enum PrivacyType {
    ///用户协议
    case userPrivacy
    /// 隐私政策
    case privacyPolicy
    /// 儿童隐私
    case childPrivacy
}

class PrivacyViewModel: ViewModelNomalType {
    func transform(input: Input) -> Output {
        let title = Observable.create { [self] observer in
            observer.onNext("个人信息保护提示")
            titleObserver = observer
            return Disposables.create()
        }
        let protocolText = Observable.create {[self] observer in
            protocolObserver = observer
            observer.onNext("""
                            欢迎来到人人讲!
                            我们将通过《人人讲用户协议》和《人人讲隐私政策》,帮助您了解我们为您提供的服务,我们如何处理个人信息以及您享有的权利.我们会严格按照相关法律法规要求,
                            采取各种安全措施来保护您的个人信息.我们重视青少年 儿童的个人信息保护,若您是未满18周岁的未成年人,请在监护人的指导下阅读并同意以上协议以及《儿童|青少年个人信息保护法规》.
                            点击"同意"按钮,表示您已知情以上协议和以下约定
                            1. 为了保障软件的安全运行和账户安全,我们会申请收集您的设备信息,IP地址,MAC地址
                            2. 上传或拍摄图片,视频,需要使用您的存储,相机麦克风权限
                            3. 我们可能会申请位置权限,用于为您推荐您可能感兴趣的内容
                            4. 为了帮助你发现更多朋友,我们会申请通讯录权限
                            5. 我们尊重您的选择,你可以访问,修改,删除您的个人信息并管理您的授权,我们也为您提供注销,投诉渠道
                            """)
            return Disposables.create()
        }
        let userPrivacy = input.userPrivacy.map({_ in "用户协议链接"})
        let privacyPolicy = input.privacyPolicy.map({_ in "隐私协议连接"})
        let childPrivacy = input.childPrivacy.map({_ in "儿童协议链接"})
        let refuse = input.refuse.map { [self] _ in
            if refuseClicked
            {
                exit(0)
            }
            else
            {
                titleObserver.onNext("温馨提示")
                protocolObserver.onNext("""
                                            如果您不同意《人人讲用户协议》和《人人讲隐私政策》以及《儿童 青少年个人信息保护法规》,很遗憾我们将无法为您提供服务,你需要同意以上协议后,才能使用人人讲
                                            我们将严格按照相关法律法规要求,坚决保障您的个人隐私和信息安全
                                            """)
                refuseClicked = true
            }
        }
        return Output(title: title, protocolText: protocolText, userPrivacy: userPrivacy, privacyPolicy: privacyPolicy, childPrivacy: childPrivacy, confirm: input.confirm.asObservable(), refuse: refuse)
    }
    
    struct Input {
        /// 隐私协议点击
        let userPrivacy: Observable<String>
        /// 隐私政策点击
        let privacyPolicy: Observable<String>
        /// 儿童协议点击
        let childPrivacy: Observable<String>
        /// 同意点击
        let confirm: ControlEvent<Void>
        ///  拒绝点击
        let refuse: ControlEvent<Void>
    }
    struct Output {
        /// 标题
        let title: Observable<String>
        /// 协议内容
        let protocolText: Observable<String>
        /// 隐私协议点击
        let userPrivacy: Observable<String>
        /// 隐私政策点击
        let privacyPolicy: Observable<String>
        /// 儿童协议点击
        let childPrivacy: Observable<String>
        /// 同意点击输出
        let confirm: Observable<Void>
        /// 拒绝点击输出
        let refuse: Observable<Void>
    }
    var titleObserver: AnyObserver<String>!
    var protocolObserver: AnyObserver<String>!
    var refuseClicked = false
}
