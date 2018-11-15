//
//  AddCarDetailsViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class AddCarDetailsViewController: UIViewController {

    
    
    
    @IBOutlet var fieldsCollection: [FloatLabelTextField]!
    
    @IBOutlet weak var carName: FloatLabelTextField!
    @IBOutlet weak var carType: FloatLabelTextField!
    @IBOutlet weak var carPrice: FloatLabelTextField!
    @IBOutlet weak var modelYear: FloatLabelTextField!
    @IBOutlet weak var assemble: FloatLabelTextField!
    @IBOutlet weak var registrationCity: FloatLabelTextField!
    @IBOutlet weak var cngYesNo: FloatLabelTextField!
    @IBOutlet weak var bodyType: FloatLabelTextField!
    @IBOutlet weak var brand: FloatLabelTextField!
    @IBOutlet weak var color: FloatLabelTextField!
    @IBOutlet weak var engineCapacity: FloatLabelTextField!
    @IBOutlet weak var carDescription: FloatLabelTextField!
    @IBOutlet weak var tags: FloatLabelTextField!
    @IBOutlet weak var makeFeatured: UISwitch!
    @IBOutlet weak var addPromotions: UISwitch!
    @IBOutlet weak var carCondition: FloatLabelTextField!
    @IBOutlet weak var carMake: FloatLabelTextField!
    @IBOutlet weak var carMilage: FloatLabelTextField!
    
    
    
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        activityView.color = UIColor.black
        self.view.addSubview(activityView)
        
        self.fieldsCollection.forEach { (item) in
            
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.lightGray.cgColor
            
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
        
            "car_service": "1",
            "car_name": carName.text,
            "car_make": carMake.text,
            "car_model": modelYear.text,
            "car_assemble": assemble.text,
            "car_type": carType.text,
            "car_car_type": carCondition.text, // car condition
            "car_city": registrationCity.text,
            "car_color": color.text,
            "car_capacity": engineCapacity.text,
            "car_milage": carMilage.text,
            "car_gas": cngYesNo.text,
            "car_price": carPrice.text,
            "ms1": "[“feature1”, “feature2”]",
            "car_desc": carDescription.text,
            "feature": makeFeatured.isOn ? Optional("yes") : Optional("no"),
            "promotion_desc": "", //
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
            self.dismiss(animated: true, completion: nil)
            AppDelegate.showToast(message: "Account created, please login with your new account credentails.", duration: 3, controller: self)
            //            print(json)
            
            
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
