//
//  MainLoginView.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import UIKit

class MainLoginView: BaseView {
    
    override init() {
        super.init()
        addSubview(titleLabel)
        addSubview(desLabel)
        addSubview(wechatLogin)
        self.backgroundColor = .init(hexString: "#FFFFFF")
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.top).offset(LayoutConstantConfig.navigationFullHeight + 50)
        }
        desLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        wechatLogin.snp.makeConstraints { make in
            make.centerX.equalTo(desLabel)
            make.size.equalTo(CGSize(width: LayoutConstantConfig.screenWidth-80, height: 40))
            make.bottom.equalTo(self.snp.bottom).offset(-150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -- Getter
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "人人讲"
        label.textColor = .init(hexString: "#FA5D5C")
        label.font = .systemFont(ofSize: 55, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var desLabel: UILabel = {
        let label = UILabel()
        label.text = "啦啦啦啦啦"
        label.textColor = .init(hexString: "#BABABA")
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var wechatLogin: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("微信登录", for: .normal)
        btn.setTitleColor(.init(hexString: "#FFFFFF"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        btn.backgroundColor = .init(hexString: "#FA5D5C")
        return btn
    }()
}
