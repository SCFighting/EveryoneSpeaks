//
//  PresentController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/8.
//

import UIKit

class PresentController: BaseController {

    override init() {
        super.init()
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(dismisButton)
        dismisButton.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    @objc func dismisButtonClick()
    {
        if animation.dismissWhenTapDimming
        {
            self.dismiss(animated: true)
        }
    }
    
    lazy var animation: PresentAnimator = {
        let animate = PresentAnimator()
        return animate
    }()
    
    lazy var dismisButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.addTarget(self , action: #selector(dismisButtonClick), for: .touchUpInside)
        return btn
    }()
}

extension PresentController: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animation.presenting = true
        return animation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animation.presenting = false
        return animation
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let vc = PresentationController(presentedViewController: presented, presenting: presenting)
        vc.dimmingView.backgroundColor = animation.dimmingViewColor
        return vc
    }
}
