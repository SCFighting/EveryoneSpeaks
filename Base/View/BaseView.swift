//
//  BaseView.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import UIKit

class BaseView: UIView {

    init() {
        super.init(frame:.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
