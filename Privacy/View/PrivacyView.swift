//
//  PrivacyView.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import UIKit
import ActiveLabel

class PrivacyView: BaseView {

    
    //MARK: -- Getter
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "个人信息保护提示"
        label.textColor = UIColor("#202020")
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    lazy var activityLabel: ActiveLabel = {
        let label = ActiveLabel()
        let customTypeOne = ActiveType.custom(pattern: "《人人讲用户协议》")
        let customTypeTwo = ActiveType.custom(pattern: "《人人讲隐私政策》")
        let customTypeThree = ActiveType.custom(pattern: "《儿童|青少年个人信息保护法规》")
        label.enabledTypes = [customTypeOne,customTypeTwo,customTypeThree]
        label.text = """
                     欢迎来到人人讲!\n
                     我们将通过《人人讲用户协议》和《人人讲隐私政策》,帮助您了解我们为您提供的服务,我们如何处理个人信息以及您享有的权利.我们会严格按照相关法律法规要求,
                     采取各种安全措施来保护您的个人信息.我们重视青少年|儿童的个人信息保护,若您是未满18周岁的未成年人,请在监护人的指导下阅读并同意以上协议以及《儿童|青少年个人信息保护法规》.
                     点击"同意"按钮,表示您已知情以上协议
                     """
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.customColor[customTypeOne] = UIColor("#F4350B")
        label.customColor[customTypeTwo] = UIColor("#F4350B")
        label.customColor[customTypeThree] = UIColor("#F4350B")
        label.textColor = UIColor("#CBCBCB")
        label.handleCustomTap(for: customTypeOne) { str in
            print(str)
        }
        return label
    }()
}
