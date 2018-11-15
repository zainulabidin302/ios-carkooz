//
//  SignupViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTxt: DesignableUITextField!
    @IBOutlet weak var emailTxt: DesignableUITextField!
    @IBOutlet weak var mobileTxt: DesignableUITextField!
    @IBOutlet weak var passTxt: DesignableUITextField!
    @IBOutlet weak var rePassTxt: DesignableUITextField!
    @IBOutlet weak var addressTxt: DesignableUITextField!
    @IBOutlet weak var cityTxt: DesignableUITextField!
    @IBOutlet weak var stateTxt: DesignableUITextField!
    @IBOutlet weak var countryTxt: DesignableUITextField!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        self.view.addSubview(activityView)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signup(_ sender: Any) {
        activityView.startAnimating()
        

        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string:  AppDelegate.baseURL + "register.php")!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dictPost: [String: String? ] = [
            "signup": Optional("1"),
            "email": emailTxt.text,
            "name": nameTxt.text,
            "contact": mobileTxt.text,
            "password": passTxt.text,
            "repassword": rePassTxt.text,
            "city": cityTxt.text,
            "address": addressTxt.text,
            "country": countryTxt.text,
            "state": stateTxt.text,
            "lat": Optional(String(Double(AppDelegate.location!.latitude ?? 0))),
            "long": Optional(String(Double(AppDelegate.location!.longitude ?? 0))),
        ]
        
        let body = AppDelegate.toQueryParmas(dictPost)
        print(body)
        request.httpBody = body.data(using: .utf8)
        
        
        
        
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.activityView.stopAnimating()
            })
            guard error == nil else {
                print("Error \(error!)")
                let message = "Can not create account, try again."
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
                AppDelegate.showToast(message: "Can not create account", duration: 4, controller: self)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Malformed json")
                print(content)

                AppDelegate.showToast(message: "Can not create account", duration: 4, controller: self)
                return
            }
            if (json["status"] as! String == "400") {
                
                let message = json["error"] as! String
                AppDelegate.showToast(message: message, duration: 4, controller: self)
            }
            self.dismiss(animated: true, completion: nil)
            AppDelegate.showToast(message: "Account created, please login with your new account credentails.", duration: 3, controller: self)
            self.createChatUser(id: self.emailTxt.text!, name: self.nameTxt.text!)
            
        }
        task.resume()
        
    }
    
    func createChatUser(id: String, name: String) {
        
        let session = URLSession(configuration: .default)
        let query = "id=" + id + "&name=" + name
        var request = URLRequest(url: URL(string:  AppDelegate.chatServerUrl + "user?" + query)!)
        print(request)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error \(error!)")
                return
            }
            guard let content = data else {
                print("Error \(error!)")
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Malformed json")
                print(content)
                return
            }
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
