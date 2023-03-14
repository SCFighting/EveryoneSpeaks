//
//  NavigationController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/14.
//

import UIKit

class NavigationController: RTRootNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewController.isKind(of: HomeController.self)
        {
            viewController.hidesBottomBarWhenPushed = false;
        }
        else
        {
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController!, animated: Bool, complete block: ((Bool) -> Void)!) {
        if viewController.isKind(of: HomeController.self)
        {
            viewController.hidesBottomBarWhenPushed = false;
        }
        else
        {
            viewController.hidesBottomBarWhenPushed = true;
        }
        super.pushViewController(viewController, animated: animated, complete: block)
    }
}
