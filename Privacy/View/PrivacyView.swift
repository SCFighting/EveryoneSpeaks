//
//  PrivacyView.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import UIKit
import ActiveLabel

class PrivacyView: BaseView {

    let viewModel = PrivacyViewModel()
    
    let disposBag = DisposeBag()
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
        bindModel()
    }
    
    func bindModel() {
 
        let userPrivacy = Observable.create { observer in
            self.activityLabel.handleCustomTap(for: ActiveType.custom(pattern: "《人人讲用户协议》")) { str in
                observer.onNext(str)
            }
            return Disposables.create()
        }
        let privacyPolicy = Observable.create { observer in
            self.activityLabel.handleCustomTap(for: ActiveType.custom(pattern: "《人人讲隐私政策》")) { str in
                observer.onNext(str)
            }
            return Disposables.create()
        }
        let childPrivacy = Observable.create { observer in
            self.activityLabel.handleCustomTap(for: ActiveType.custom(pattern: "《儿童|青少年个人信息保护法规》")) { str in
                observer.onNext(str)
            }
            return Disposables.create()
        }
        let output = viewModel.transform(input: PrivacyViewModel.Input(userPrivacy: userPrivacy, privacyPolicy: privacyPolicy, childPrivacy: childPrivacy, confirm: self.confirmButton.rx.tap, refuse: self.refuseButton.rx.tap))
        output.protocolText.bind(to: self.activityLabel.rx.text).disposed(by: disposBag)
        output.title.bind(to: self.titleLabel.rx.text).disposed(by: disposBag)
        output.userPrivacy.subscribe(onNext: {(str) in
            DDLogDebug("str = \(str)")
        }).disposed(by: disposBag)
        output.privacyPolicy.subscribe(onNext: {(str) in
            DDLogDebug("str = \(str)")
        }).disposed(by: disposBag)
        output.childPrivacy.subscribe(onNext: {(str) in
            DDLogDebug("str = \(str)")
        }).disposed(by: disposBag)
        
        output.refuse.subscribe(onNext: { [self] in
            UIView.transition(with: containerView, duration: 0.3,options: .curveEaseInOut) { [self] in
                containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                confirmButton.setTitle("同意并继续", for: .normal)
                refuseButton.setTitle("放弃使用", for: .normal)
            }
            UIView.animate(withDuration: 0.3, delay: 0.3) { [self] in
                containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }).disposed(by: disposBag)
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
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.customColor[customTypeOne] = .init(hexString: "#F4350B")
        label.customColor[customTypeTwo] = .init(hexString: "#F4350B")
        label.customColor[customTypeThree] = .init(hexString: "#F4350B")
        label.textColor = .init(hexString: "#000000")
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
