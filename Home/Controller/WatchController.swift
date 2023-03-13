//
//  WatchController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/11.
//

import UIKit

class WatchController: BaseController {

    let playerView = SuperPlayerView()
    let model = SuperPlayerModel()
    override func viewDidLoad() {
        super.viewDidLoad()
//        playerView.layoutStyle = .fullScreen
        playerView.play(withModelNeedLicence: model)

       
        playerView.fatherView = self.view
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WatchController: SuperPlayerDelegate
{
    func superPlayerError(_ player: SuperPlayerView!, errCode code: Int32, errMessage why: String!) {
        DDLogDebug(why)
    }
}
