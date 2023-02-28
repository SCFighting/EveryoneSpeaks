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
       
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(scrollView)
        scrollView.addSubview(activityLabel)
        containerView.addSubview(gradientView)
        gradientView.addSubview(confirmButton)
        gradientView.addSubview(refuseButton)
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        containerView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: LayoutConstantConfig.screenWidth-80, height: LayoutConstantConfig.screenHeight*2/3))
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(containerView)
            make.top.equalTo(containerView.snp.top).offset(15)
        }
        scrollView.snp.makeConstraints { make in
            make.left.right.equalTo(containerView)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        activityLabel.snp.makeConstraints { make in
            make.left.equalTo(scrollView.snp.left).offset(15)
            make.right.equalTo(scrollView.snp.right).offset(-15)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.lessThanOrEqualTo(scrollView.snp.bottom).offset(-15)
            make.width.lessThanOrEqualTo(LayoutConstantConfig.screenWidth-80-30)
        }
        gradientView.snp.makeConstraints { make in
            make.left.right.equalTo(containerView)
            make.top.equalTo(scrollView.snp.bottom).offset((-10))
            make.bottom.equalTo(containerView.snp.bottom)
        }
        confirmButton.snp.makeConstraints { make in
            make.left.equalTo(gradientView.snp.left).offset(30)
            make.right.equalTo(gradientView.snp.right).offset(-30)
            make.height.equalTo(40)
            make.top.equalTo(gradientView.snp.top).offset(15)
        }
        refuseButton.snp.makeConstraints { make in
            make.left.right.equalTo(confirmButton)
            make.top.equalTo(confirmButton.snp.bottom).offset(5)
            make.centerX.equalTo(confirmButton)
            make.bottom.equalTo(gradientView.snp.bottom).offset(-15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = gradientView.layer as? CAGradientLayer
        {
            let transparent = UIColor(white: 1, alpha: 0.2).cgColor
            let opaque = UIColor(white: 1, alpha: 1).cgColor
            gradientLayer.colors=[opaque, opaque, opaque, transparent]
            gradientLayer.locations=[0,0.5,0.8,1]
            gradientLayer.startPoint=CGPointMake(0,1);
            gradientLayer.endPoint=CGPointMake(0,0);
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
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var activityLabel: ActiveLabel = {
        let label = ActiveLabel()
        let customTypeOne = ActiveType.custom(pattern: "《人人讲用户协议》")
        let customTypeTwo = ActiveType.custom(pattern: "《人人讲隐私政策》")
        let customTypeThree = ActiveType.custom(pattern: "《儿童|青少年个人信息保护法规》")
        label.enabledTypes = [customTypeOne,customTypeTwo,customTypeThree]
        label.lineSpacing = 5
        label.text = """
                     欢迎来到人人讲!
                     我们将通过《人人讲用户协议》和《人人讲隐私政策》,帮助您了解我们为您提供的服务,我们如何处理个人信息以及您享有的权利.我们会严格按照相关法律法规要求,
                     采取各种安全措施来保护您的个人信息.我们重视青少年|儿童的个人信息保护,若您是未满18周岁的未成年人,请在监护人的指导下阅读并同意以上协议以及《儿童|青少年个人信息保护法规》.
                     点击"同意"按钮,表示您已知情以上协议和以下约定
                     1. 为了保障软件的安全运行和账户安全,我们会申请收集您的设备信息,IP地址,MAC地址
                     2. 上传或拍摄图片,视频,需要使用您的存储,相机麦克风权限
                     3. 我们可能会申请位置权限,用于为您推荐您可能感兴趣的内容
                     4. 为了帮助你发现更多朋友,我们会申请通讯录权限
                     5. 我们尊重您的选择,你可以访问,修改,删除您的个人信息并管理您的授权,我们也为您提供注销,投诉渠道
                     """
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.customColor[customTypeOne] = .init(hexString: "#F4350B")
        label.customColor[customTypeTwo] = .init(hexString: "#F4350B")
        label.customColor[customTypeThree] = .init(hexString: "#F4350B")
        label.textColor = .init(hexString: "#000000")
        label.handleCustomTap(for: customTypeOne) { str in
            print(str)
        }
        return label
    }()
    
    lazy var gradientView: GradientView = {
        let view = GradientView()
        return view
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.init(hexString: "#FA5D5C")
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setTitle("同意", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    lazy var refuseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.init(hexString: "#FA5D5C"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        button.setTitle("不同意", for: .normal)
        return button
    }()
}
