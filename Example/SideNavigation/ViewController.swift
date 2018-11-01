//
//  ViewController.swift
//  Slide
//
//  Created by Steve on 2017/8/1.
//  Copyright © 2017年 Jack. All rights reserved.
//

import UIKit
import SideNavigation

class ViewController: UIViewController {

    var leftViewController: LeftViewController! {
        didSet {
            self.slideMenuManager1 = SideMenuManager(self, left: self.leftViewController)
        }
    }
//    var rightViewController: RightViewController! {
//        didSet {
//            self.slideMenuManager2 = SideMenuManager(self, right: self.rightViewController)
//        }
//    }
    var slideMenuManager1: SideMenuManager!
//    var slideMenuManager2: SideMenuManager!
    
    func pushView(id: String) {
        let dest = self.storyboard!.instantiateViewController(withIdentifier: id)
        dest.view.backgroundColor = .blue
        self.navigationController?.pushViewController(dest, animated: false)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.leftViewController = LeftViewController()
        self.leftViewController.didselected = { [weak self]  (indexPath) in
            
            switch indexPath.row {
            case 0:
                self!.pushView(id: "ProfileViewController")
                break
            case 1:
                self!.pushView(id: "ServicesViewController")
                break
            default:
                break
            }
            
        }
//        self.rightViewController = RightViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "left", style: .plain, target: self, action: #selector(leftClick))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "right", style: .plain, target: self, action: #selector(rightClick))
    }

    @objc func leftClick() {
        self.present(self.leftViewController, animated: true, completion: nil)
    }

//    @objc func rightClick() {
//        self.present(self.rightViewController, animated: true, completion: nil)
//    }

}



