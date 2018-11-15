//
//  RequestCarInspectionViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class RequestCarInspectionViewController: UIViewController {

    
    
    @IBOutlet var filedsList: [FloatLabelTextField]!
    
    
    
    @IBOutlet weak var carDetailsTxt: FloatLabelTextField!
    @IBOutlet weak var cityTxt: FloatLabelTextField!
    @IBOutlet weak var addressTxt: FloatLabelTextField!
    @IBOutlet weak var mobileTxt: FloatLabelTextField!
    @IBOutlet weak var emailTxt: FloatLabelTextField!
    @IBOutlet weak var nameTxt: FloatLabelTextField!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filedsList.forEach { (item) in
            
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.lightGray.cgColor
        }
        // Do any additional setup after loading the view.
        self.activityView.color = UIColor.black
        activityView.center = self.view.center
        self.view.addSubview(activityView)

    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit() {
        activityView.startAnimating()
        
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string:  AppDelegate.baseURL + "inspection.php")!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let dictPost: [String: String? ] = [
            "external": "1",
            "car_info": carDetailsTxt.text,
            "phone": mobileTxt.text,
            "email": emailTxt.text,
            "city": cityTxt.text,
            "address": addressTxt.text,
            "name": nameTxt.text,
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
                AppDelegate.showToast(message: "Error requesting. Please try again.", duration: 4, controller: self)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Malformed json")
                print(content)
                
                AppDelegate.showToast(message: "Error requesting. Please try again.", duration: 4, controller: self)
                return
            }
            if (json["status"] as! String == "400") {
                
                let message = json["error"] as! String
                AppDelegate.showToast(message: message, duration: 4, controller: self)
            }
            AppDelegate.showToast(message: "Request sent.", duration: 5, controller: self)
            
            
            
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
