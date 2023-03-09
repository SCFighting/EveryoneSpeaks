//
//  RootController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import RAMAnimatedTabBarController
import RTRootNavigationController
import Foundation
class RootController: RAMAnimatedTabBarController {
    override func loadView() {
        super.loadView()
        addAllChildsControllors()
        if #available(iOS 13.0, *) {
            let app = UITabBarAppearance()
            app.backgroundImage = UIImage(named: "nav_background")?.resizableImage(withCapInsets: .zero,resizingMode: .stretch)
            self.tabBar.standardAppearance = app
            if #available(iOS 15.0, *) {
                self.tabBar.scrollEdgeAppearance = app
            } else {
                // Fallback on earlier versions
            }
        } else {
            // Fallback on earlier versions
        }
        
//        self.tabBar.backgroundImage =
    }
    
    ///添加所有的子控制器
    fileprivate func addAllChildsControllors() {
        ///首页
        addOneChildVC(childVC: HomeController(), title: "首页", image:UIImage(imageLiteralResourceName: "btn_home_normal"), selecteImage:UIImage(imageLiteralResourceName: "btn_home_selected"))
        //我的
        addOneChildVC(childVC: MineController(), title: "我的", image:UIImage(imageLiteralResourceName: "btn_user_normal") , selecteImage:UIImage(imageLiteralResourceName: "btn_user_selected"))
    }
    
    ///添加一个控制器
    private func addOneChildVC(childVC: UIViewController, title: String?, image: UIImage?, selecteImage: UIImage?) {
        
        //1.添加子控制器
        let nav = RTRootNavigationController(rootViewController: childVC)
        addChild(nav)
        //2.添加标题
        let item = RAMAnimatedTabBarItem(title: title, image: image, selectedImage: selecteImage)
        let animation = RAMBounceAnimation()
        animation.iconSelectedColor = UIColor.blue
        item.animation = animation
        
        nav.tabBarItem = item
        
        
    }
}
