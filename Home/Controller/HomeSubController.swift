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
