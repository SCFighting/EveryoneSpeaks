//
//  HomeController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import UIKit

class HomeController: BaseController {
    
    let provider = MoyaProvider<Service>()
    let disposbag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        provider.rx.request(.channelClassification).subscribe(onSuccess: {response in
           let array =  response.data.kj.modelArray(ChannelClassificationModel.self)
            DDLogDebug(array)
            if let json = try? response.mapJSON()
            {
                DDLogDebug(json)
            }
        }, onFailure: {error in
            DDLogDebug(error)
        }).disposed(by: disposbag)
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
