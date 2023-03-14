//
//  SearchController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/14.
//

import UIKit

class SearchController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = searchVC.searchBar
//        searchVC.searchBar.becomeFirstResponder()
//        searchVC.isActive = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchVC.isActive = true
    }
    
    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
    
    lazy var searchVC:UISearchController = {
        let vc = UISearchController(searchResultsController: searchResultVC)
        vc.hidesNavigationBarDuringPresentation = false
        vc.obscuresBackgroundDuringPresentation = false
        vc.dimsBackgroundDuringPresentation = false
        vc.searchBar.setShowsCancelButton(true, animated: true)
        vc.delegate = self
        vc.searchBar.tintColor = .gray
        vc.searchBar.delegate = self
        // 调整输入框高度, 宽度可以设置大于0的任意值，高度为输入框显示高度
        var image = self.searchFieldImage(CGSize.init(width: 100, height: 30))
        image = image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 45, bottom: 0, right: 45), resizingMode: UIImage.ResizingMode.stretch)
        vc.searchBar.setSearchFieldBackgroundImage(image, for: .normal)
        return vc
    }()
    
    lazy var searchResultVC: SearchResultController = {
        let vc = SearchResultController()
        return vc
    }()
    
    func searchFieldImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        UIColor.init(white: 0, alpha: 0.1).setFill()
        // 圆角效果
        let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: size), cornerRadius: size.height / 2)
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    

}

extension SearchController: UISearchControllerDelegate
{
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            self.searchVC.searchBar.becomeFirstResponder()
        }
    }
}

extension SearchController: UISearchBarDelegate
{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.isFirstResponder
        {
            searchBar.resignFirstResponder()
        }
        else
        {
            searchVC.dismiss(animated: true)
            self.rt_navigationController.popViewController(animated: true, complete: nil)
        }
    }
}
