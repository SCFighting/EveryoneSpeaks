//
//  LoginController.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/7.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import CocoaLumberjack
import Toast_Swift
class LoginController: BaseController {
    static let provider = MoyaProvider<Service>()
    let vm = LoginViewModel(provider: provider)
    let dispos = DisposeBag()
    let btn = UIButton(frame: .init(x: 0, y: 0, width: LayoutConstantConfig.screenWidth, height: LayoutConstantConfig.screenHeight))
    override func loadView() {
        super.loadView()
        view.addSubview(btn)
        bindModel()
    }
    
    private func bindModel()
    {
        vm.output.wechatLoginResult.subscribe(onNext: {result in
            DDLogDebug("result=\(result)")
        },onError: {error in
            DDLogError("error=\(error)")
            switch error
            {
            case CustomError.baseError( _, let errorMessage):
                self.view.makeToast(errorMessage,position: .center)
                break
            default:
                break
            }
        },onCompleted: {
            DDLogDebug("dd")
        }).disposed(by: dispos)
        btn.rx.tap.bind(to: vm.input.wechatLogin).disposed(by: dispos)
    }
}
