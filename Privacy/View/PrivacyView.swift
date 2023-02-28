//
//  PrivacyView.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import UIKit
import ActiveLabel

class PrivacyView: BaseView {

    override init() {
        super.init()
        self.backgroundColor = .init(hexString: "#000000").withAlphaComponent(0.3)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(activityLabel)
        containerView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: LayoutConstantConfig.screenWidth-60, height: LayoutConstantConfig.screenHeight/2))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(containerView.snp.top).offset(15)
        }
        activityLabel.snp.makeConstraints { make in
            make.left.equalTo(containerView.snp.left).offset(15)
            make.right.equalTo(containerView.snp.right).offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.lessThanOrEqualTo(containerView.snp.bottom).offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- Getter
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hexString: "#FFFFFF")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "个人信息保护提示"
        label.textColor = .init(hexString: "#202020")
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
        label.customColor[customTypeOne] = .init(hexString: "#F4350B")
        label.customColor[customTypeTwo] = .init(hexString: "#F4350B")
        label.customColor[customTypeThree] = .init(hexString: "#F4350B")
        label.textColor = .init(hexString: "#CBCBCB")
        label.handleCustomTap(for: customTypeOne) { str in
            print(str)
        }
        return label
    }()
}
