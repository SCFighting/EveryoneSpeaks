//
//  HomeSubController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/9.
//

import UIKit
import JXSegmentedView
class HomeSubController: BaseController {

    let viewModel = HomeSubViewModel()
    var channel_id = 20
    let disposbag = DisposeBag()
    override func loadView() {
        super.loadView()
        self.view = tableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.output.dataSource.bind(to: tableView.rx.items(cellIdentifier: "HomeCell",cellType: HomeCell.self)){index,model,cell in
            cell.viewmodel.input.activity.onNext(model)
        }.disposed(by: disposbag)
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ActivityModel.self)).bind { [self] indexPath,model in
            let provider = MoyaProvider<Service>()
            provider.rx.request(.activityWatchInfo(activity_id: model.id)).subscribe(onSuccess: {response in
                if let json = try? response.mapJSON() as? Dictionary<String,Any>, let videoJson = json["video"] as? Dictionary<String,Any>
                {
                    let videoInfo = videoJson.kj.model(VideoInfoModel.self)
                    let vc = WatchController()
                    vc.hidesBottomBarWhenPushed = true
                    if videoInfo.status == 0
                    {
                        DDLogDebug(TXLiveBase.getLicenceInfo())
                        vc.model.videoURL = videoInfo.rtmp_url
                        self.rt_navigationController.pushViewController(vc, animated: true)
                    }
                    else if videoInfo.status == 2
                    {
                        vc.model.videoURL = videoInfo.hls_url
                        self.rt_navigationController.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        self.view.makeToast("video status = \(videoInfo.status)")
                    }
                }
            }).disposed(by: disposbag)
        }.disposed(by: disposbag)
        viewModel.input.viewDidload.onNext(channel_id)
    }
    
    lazy var tableView:UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 90
        tv.rowHeight = UITableView.automaticDimension
        return tv
    }()
}

extension HomeSubController:  JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
