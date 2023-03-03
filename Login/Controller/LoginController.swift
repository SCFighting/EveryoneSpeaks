//
//  LoginController.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/7.
//

import UIKit
class LoginController: BaseController {
    static let provider = MoyaProvider<Service>()
    let vm = LoginViewModel(provider: provider)
    let dispos = DisposeBag()
    override func loadView() {
        super.loadView()
        self.view = mainLoginView
        bindModel()
    }
    
    private func bindModel()
    {
        vm.output.wechatLoginResult.subscribe(onNext: {result in
            switch result
            {
            case .success(let appinfoModel):
                Navigator.shared.changeRootViewController()
                DDLogDebug("登陆成功\(appinfoModel?.user.user_id ?? 0)")
                Navigator.shared.changeRootViewController()
                break
            case .failure(let error):
                switch error
                {
                case .baseError(_,let errorMessage):
                    if let errorMessage
                    {
                        DDLogError(errorMessage)
                        self.view.makeToast(errorMessage)
                    }
                    break
                }
                break
            }
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
        mainLoginView.wechatLogin.rx.tap.bind(to: vm.input.wechatLogin).disposed(by: dispos)
    }
    
    //MARK: --getter
    lazy var mainLoginView: MainLoginView = {
        let view = MainLoginView()
        return view
    }()
}
