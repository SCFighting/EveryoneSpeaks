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
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(ActivityModel.self)).bind { [self] index,model in
            let provider = MoyaProvider<Service>()
            provider.rx.request(.activityWatchInfo(activity_id: model.id)).subscribe { response in
                DDLogDebug(try? response.mapJSON(failsOnEmptyData: false))
            }.disposed(by: disposbag)
        }.disposed(by: disposbag)
//        viewModel.output.dataSource.bind(to: tableView.rx.sel)
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
