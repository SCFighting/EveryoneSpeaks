//
//  HomeController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/2/28.
//

import UIKit
import JXSegmentedView
class HomeController: BaseController {
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let seds = JXSegmentedTitleDataSource()
        seds.isTitleColorGradientEnabled = true
        return seds
    }()
    lazy var segmentedView: JXSegmentedView = {
        let sev = JXSegmentedView()
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 24
        sev.indicators = [indicator]
        return sev
    }()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    override func loadView() {
        super.loadView()
        
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        view.addSubview(segmentedView)

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 15.0, *) {
                let appperance = UINavigationBarAppearance()
                //添加背景色
            appperance.backgroundColor = .clear
            appperance.backgroundImage = UIImage(named: "nav_background")?.resizableImage(withCapInsets: .zero,resizingMode: .stretch)
                appperance.shadowImage = UIImage()
                appperance.shadowColor = nil
                //设置字体颜色大小
                appperance.titleTextAttributes = [
                    .foregroundColor: UIColor.white
                ]
                navigationController?.navigationBar.standardAppearance = appperance
                navigationController?.navigationBar.scrollEdgeAppearance = appperance
                navigationController?.navigationBar.compactAppearance = appperance
                navigationController?.navigationBar.compactScrollEdgeAppearance = appperance
            }
        let backImage = UIImage(named: "nav_background")?.resizableImage(withCapInsets: .zero,resizingMode: .stretch)
        self.rt_navigationController.navigationBar.setBackgroundImage(backImage, for: .default)
        self.navigationController?.navigationBar.alpha = 1
        //处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view.snp.top).offset(LayoutConstantConfig.navigationFullHeight)
            make.height.equalTo(30)
        }
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(segmentedView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom).offset(-LayoutConstantConfig.tabBarFullHeight)
        }
    }

    
    
    
    let viewmodel = HomeViewModel()
    let disposbag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
//        //图片拉伸，否则在某些机型导航栏图片是没有填满的
//            UIImage *backImage = [[UIImage imageNamed:@"nav_background"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
//            //设置导航栏背景图片
//            [self.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    }
    
    
    func bindViewModel(){
        viewmodel.output.channelNameArray.subscribe(onNext: { [self]nameArray in
            DDLogDebug(nameArray)
            self.segmentedDataSource.titles = nameArray
            segmentedView.reloadData()
        }).disposed(by: disposbag)
        
        viewmodel.queryChannelClassification().subscribe(onSuccess: { [self]channelArray in
            viewmodel.channelListArray = channelArray
            Observable.just(channelArray).bind(to: viewmodel.input.channelModelArray).disposed(by: disposbag)
        }).disposed(by: disposbag)
        
        
//        viewmodel.input.chan
    }
    
}

extension HomeController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension HomeController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return HomeSubController()
    }
}
