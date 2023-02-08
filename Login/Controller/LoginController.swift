//
//  LoginController.swift
//  EveryoneSpeaks
//
//  Created by 孙超 on 2023/2/7.
//

import UIKit
import RxSwift
import RxCocoa
class LoginController: BaseController {

    let vm = LoginViewModel()
    let dispos = DisposeBag()
    let btn = UIButton(frame: .init(x: 0, y: 0, width: LayoutConstantConfig.screenWidth, height: LayoutConstantConfig.screenHeight))
    override func loadView() {
        super.loadView()
        btn.backgroundColor = .red
        view.addSubview(btn)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        btn.rx.tap.subscribe(onNext: {print("dddddddddd")}).disposed(by: dispos)
        btn.rx.tap.bind(to: vm.input.wechatLogin).disposed(by: dispos)
        vm.output.wechatLoginResult.drive(onNext: {sss in
            print("wwwwwwwwwwww=\(sss)")
        },onDisposed: {}).disposed(by: dispos)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
