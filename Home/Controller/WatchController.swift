//
//  WatchController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/11.
//

import UIKit

class WatchController: BaseController {

    let model = SuperPlayerModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.fatherView = self.view
        playerView.play(withModelNeedLicence: model)
    }
    
    lazy var playerView: SuperPlayerView! = {
        let view = SuperPlayerView()
        /// 精简布局模式
        view.layoutStyle = .compact
        /// 默认非全屏
        view.isFullScreen = false
        ///锁定旋转
        view.isLockScreen = true
        /// 自动播放
        view.autoPlay = true
        /// 控制层view
        let controView = SPDefaultControlView()
        view.controlView = controView
        view.delegate = self
        return view
    }()
    
    override func customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeVideo))
    }
    
    @objc func closeVideo()
    {
        playerView.pause()
        playerView.removeVideo()
        playerView = nil
        self.rt_navigationController.popViewController(animated: true, complete: nil)
    }
}

extension WatchController: SuperPlayerDelegate
{
    func superPlayerBackAction(_ player: SuperPlayerView!) {
        player.pause()
        player.resetPlayer()
    }
}
