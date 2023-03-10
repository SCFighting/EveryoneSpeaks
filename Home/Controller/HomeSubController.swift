//
//  HomeSubController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/9.
//

import UIKit
import JXSegmentedView
class HomeSubController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension HomeSubController:  JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
