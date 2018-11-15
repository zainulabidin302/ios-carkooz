//
//  ProfileViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SideNavigation

class ProfileViewController: UIViewController {

    
    @IBOutlet var fieldWrapperView: [UIView]!
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        fieldWrapperView.forEach { (item) in
            item.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        nameLabel.text = AppDelegate.user?["name"] as? String
        emailLabel.text = AppDelegate.user?["email"] as? String
        mobileLabel.text = AppDelegate.user?["contact"] as? String
        addressLabel.text = AppDelegate.user?["address"] as? String
        cityLabel.text = AppDelegate.user?["city"] as? String
        stateLabel.text = AppDelegate.user?["state"] as? String
        countryLabel.text = AppDelegate.user?["country"] as? String
        // Do any additional setup after loading the view.
        
        
//        self.view.backgroundColor = .red
        self.leftViewController = LeftViewController()
        self.leftViewController.didselected = { [weak self]  (indexPath) in
            
            switch indexPath.row {
            case 0:
                self!.pushView(id: "ProfileViewController", title: "Account Profile")
                break
            case 1:
                self!.pushView(id: "ServicesViewController", title: "Services")
                break
            case 2:
                self!.pushView(id: "ChatViewController", title: "Chat")
                break
            case 3:
                self!.pushView(id: "RequestCarInspectionViewController", title: "Request Car Inspection")
                break
            case 4:
                self!.pushView(id: "MyCarAdsListing", title: "My Car Ads")
                break
            case 5:
                self!.pushView(id: "MyServicesViewController", title:"My Services")
                break
            case 6:
                self!.pushView(id: "MyProductsViewController", title:"My Products")
                break
            case 7:
                self?.dismiss(animated: true, completion: nil)
                break
            case 8:
                self!.dismiss(animated: true, completion: {
                    self!.presentingViewController?.dismiss(animated: true, completion: nil)
                })

                break
//            case 9:
//                self?.parent?.parent?.dismiss(animated: true, completion: nil)
//                break

                
            default:
                break
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    func pushView(id: String, title: String?) {
        let dest = self.storyboard!.instantiateViewController(withIdentifier: id)
       
        self.navigationController?.pushViewController(dest, animated: false)
//        self.navigationController?.barButton
        dest.title = title
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //        self.rightViewController = RightViewController()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let btn =  UIBarButtonItem(title: "left", style: .plain, target: self, action: #selector(leftClick))
//        btn.tintColor = UIColor.white
//        
//        btn.image = UIImage(named: "settings-icon")
//        
//        self.navigationItem.leftBarButtonItem = btn
//        
//        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "right", style: .plain, target: self, action: #selector(rightClick))
    }
    
    @IBAction  func leftClick() {
        self.present(self.leftViewController, animated: true, completion: nil)
    }
    
    //    @objc func rightClick() {
    //        self.present(self.rightViewController, animated: true, completion: nil)
    //    }

}
