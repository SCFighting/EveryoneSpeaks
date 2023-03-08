//
//  ViewController.swift
//  EveryoneSpeaks
//
//  Created by SC on 2023/3/8.
//

import UIKit

class ViewController: PresentController {

    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let tt = UIView()
        tt.backgroundColor = .red
        view.addSubview(tt)
        tt.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(400)
        }
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
