//
//  AddProductDetailsViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class AddProductDetailsViewController: UIViewController {

    @IBOutlet var fieldList: [FloatLabelTextField]!
    @IBOutlet weak var productBodyType: FloatLabelTextField!
    @IBOutlet weak var productDescription: FloatLabelTextField!
    @IBOutlet weak var productPrice: FloatLabelTextField!
    @IBOutlet weak var productBrand: FloatLabelTextField!
    @IBOutlet weak var productModel: FloatLabelTextField!
    @IBOutlet weak var productName: FloatLabelTextField!
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        
        for field in fieldList {
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submit() {
        activityView.startAnimating()
        
        
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: URL(string:  AppDelegate.baseURL + "add_services.php")!)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let dictPost: [String: String? ] = [
            "products": "1",
            "p_name": productName.text,
            "p_model": productModel.text,
            "p_brand": productBrand.text,
            "p_price": productPrice.text,
            "p_desc": productDescription.text,
            "sp_id": (AppDelegate.user!["id"] as! String),
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
                guard let errorMsg = json["product"] else {
                    guard let errorMsg = json["msg"]  else {
                        print(json)
                        AppDelegate.showToast(message: "Unkown error", duration: 4, controller: self)
                        return
                    }
                    AppDelegate.showToast(message: errorMsg as! String, duration: 4, controller: self)
                    return

                }
                AppDelegate.showToast(message: errorMsg as! String, duration: 4, controller: self)

                return
            }
            self.dismiss(animated: true, completion: nil)
//            AppDelegate.showToast(message: "Account created, please login with your new account credentails.", duration: 3, controller: self)
//            //            print(json)
            
            
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
