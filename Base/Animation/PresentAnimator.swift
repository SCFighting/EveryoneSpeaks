//
//  PresentAnimator.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/8.
//

import UIKit

class PresentAnimator: NSObject {
    /// 默认是弹出
    var presenting = true
    /// 默认内容高度为屏幕高度的2/3
    var contentHeight = LayoutConstantConfig.screenHeight*2.0/3.0
    /// 默认蒙层颜色
    var dimmingViewColor = UIColor(white: 0, alpha: 0.6)
    /// 默认点击蒙层消失
    var dismissWhenTapDimming = true
    /// 默认动画时长0.35s
    var transitionDuration = 0.35
    
    init(presenting: Bool = true, contentHeight: Double = LayoutConstantConfig.screenHeight*2.0/3.0, dimmingViewColor: UIColor = UIColor(white: 0, alpha: 0.6), dismissWhenTapDimming: Bool = true, transitionDuration: Double = 0.35) {
        self.presenting = presenting
        self.contentHeight = contentHeight
        self.dimmingViewColor = dimmingViewColor
        self.dismissWhenTapDimming = dismissWhenTapDimming
        self.transitionDuration = transitionDuration
    }
}

extension PresentAnimator: UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        if presenting
        {
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            containerView.addSubview(toView!)
            
            let screenHeight = UIScreen.main.bounds.size.height
            let screenWidth = UIScreen.main.bounds.size.width
            toView?.frame = .init(x: 0, y: contentHeight, width: screenWidth, height: screenHeight)
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: UIView.AnimationOptions.curveEaseInOut
            ) {
                toView?.frame = transitionContext.finalFrame(for: toController!)
            } completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                if !success
                {
                    toView?.removeFromSuperview()
                }
                transitionContext.completeTransition(success)
            }
        }
        else
        {
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            
            UIView.animate(
                withDuration: transitionDuration(using: transitionContext),
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: UIView.AnimationOptions.curveEaseInOut
            ) {
                let screenHeight = UIScreen.main.bounds.size.height
                let screenWidth = UIScreen.main.bounds.size.width
                fromView?.frame = .init(x: 0, y: screenHeight, width: screenWidth, height: screenHeight)
            } completion: { _  in
                let success = !transitionContext.transitionWasCancelled
                if  success {
                    fromView?.removeFromSuperview()
                }
                transitionContext.completeTransition(success)
            }
        }
    }
}
