//
//  EditProfileViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var name: FloatLabelTextField!
    @IBOutlet weak var emailTxt: FloatLabelTextField!
    @IBOutlet weak var mobileTxt: FloatLabelTextField!
    @IBOutlet weak var addressTxt: FloatLabelTextField!
    @IBOutlet weak var cityTxt: FloatLabelTextField!
    @IBOutlet weak var stateTxt: FloatLabelTextField!
    @IBOutlet weak var countryTxt: FloatLabelTextField!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.name.layer.borderColor = UIColor.lightGray.cgColor
        self.name.layer.borderWidth = 1
        self.emailTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.emailTxt.layer.borderWidth = 1
        self.mobileTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.mobileTxt.layer.borderWidth = 1
        self.addressTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.addressTxt.layer.borderWidth = 1
        self.cityTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.cityTxt.layer.borderWidth = 1
        self.stateTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.stateTxt.layer.borderWidth = 1
        self.countryTxt.layer.borderColor = UIColor.lightGray.cgColor
        self.countryTxt.layer.borderWidth = 1

    
        
        
        self.name.text = AppDelegate.user!["name"] as? String
        self.emailTxt.text = AppDelegate.user!["email"] as? String
        self.emailTxt.isUserInteractionEnabled = false
        self.mobileTxt.text = AppDelegate.user!["contact"] as? String
        self.addressTxt.text = AppDelegate.user!["address"] as? String
        self.cityTxt.text = AppDelegate.user!["city"] as? String
        self.stateTxt.text = AppDelegate.user!["state"] as? String
        self.countryTxt.text = AppDelegate.user!["country"] as? String
        // Do any additional setup after loading the view.
        
            activityView.center = self.view.center
        activityView.color = UIColor.black
            self.view.addSubview(activityView)
    }
    

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: Any) {
        activityView.startAnimating()
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string:  AppDelegate.baseURL + "changepass.php")!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dictPost: [String: String? ] = [
            "updateprofile": Optional("1"),
            "uid": (AppDelegate.user!["id"] as! String),
            "pname": name.text,
            "pcontact": mobileTxt.text,
            "pcity": cityTxt.text,
            "padd": addressTxt.text,
            "pcountry": countryTxt.text,
            "pstate": stateTxt.text,
            ]
        
        let body = AppDelegate.toQueryParmas(dictPost)
        request.httpBody = body.data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.activityView.stopAnimating()
            })
            guard error == nil else {
                print("Error \(error!)")
                let message = "Can not update account, try again."
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                self.present(alert, animated: true)
                // duration in seconds
                let duration: Double = 3
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                    alert.dismiss(animated: true)
                }
                return
            }
            
            guard let content = data else {
                print("Empty Data \(data!)")
                AppDelegate.showToast(message: "Can not update account", duration: 4, controller: self)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Malformed json")
                print(content)
                
                AppDelegate.showToast(message: "Can not update account", duration: 4, controller: self)
                return
            }
            if (json["status"] as! String == "400") {
                
                let message = json["error"] as! String
                AppDelegate.showToast(message: message, duration: 4, controller: self)
            }
            AppDelegate.showToast(message: "Update success.", duration: 3, controller: self)
            AppDelegate.user = json
            
        }
        task.resume()
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
