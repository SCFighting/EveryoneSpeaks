//
//  PresentationController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/8.
//

import UIKit

class PresentationController: UIPresentationController {
    
    /// 默认的灰色蒙层
    lazy var dimmingView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.alpha = 0
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = self.frameOfPresentedViewInContainerView
        dimmingView.alpha = 0
        
        containerView?.insertSubview(dimmingView, at: 0)
        dimmingView.addSubview(presentedViewController.view)
        
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator == nil) {
            dimmingView.alpha = 1.0
            return
        }
        coordinator?.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        if coordinator == nil {
            dimmingView.alpha = 0
            return
        }
        coordinator?.animate(alongsideTransition: { context in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
