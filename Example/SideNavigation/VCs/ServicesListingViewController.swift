//
//  CommonListingAndSearchingViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ServicesListingViewController: UIViewController {
    var items: [String] = []
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    
    var filterA: [String] = ["NearBy Location", "Rating"]
    var filterB: [String] = ["Car Wash", "Car Detailing", "Mechanic", "Tire Shop", "Tow Truck", "Gas Station", "Oil Change"]
    var filterASelected: String = ""
    var filterBSelected: String = ""
    var selectedItem: String = ""
    
    @IBOutlet weak var searchNameTextField: DesignableUITextField!
    @IBOutlet weak var filterATxtField: DesignableUITextField!
    @IBOutlet weak var filterBTxtField: DesignableUITextField!
    @IBOutlet weak var btn: UIButton!
    
    var viewId: String? = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        viewLbl.text = viewId
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        filterATxtField.delegate = self as! UITextFieldDelegate
        filterBTxtField.delegate = self as! UITextFieldDelegate
        
        self.title = viewId
        self.title = "Service"
        
        
        createPicker()
        createToolbar()
        self.view.addSubview(activityView)
//        activityView.color = .black
//        activityView.center = self.view.center
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ServicesListingViewController.dismissKeyboard))
        
        toolbar.setItems([doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        filterATxtField.inputAccessoryView = toolbar
        filterBTxtField.inputAccessoryView = toolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func createPicker() {
        let picker = UIPickerView()
        picker.delegate = (self as! UIPickerViewDelegate)
        filterATxtField.inputView = picker
        filterBTxtField.inputView = picker
    }
    var embeddedVC : MyServicesTableViewController?
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let embeddedVC = segue.destination as? MyServicesTableViewController {
                embeddedVC.isEmbebed = true
                embeddedVC.data = []
                self.embeddedVC = embeddedVC
            }
    }
    
    
    @IBAction func getData() {
        
        activityView.startAnimating()
        
        let dictPost: [String: String? ] = [
           
            "getservice": "1",
            "app_requset": "1",
            "name": searchNameTextField.text,
            "category": filterBSelected,
            "sort": filterASelected,
            "user_lat":"31.4903374",
            "user_long":"74.3323967",
            ]
        
        let body = AppDelegate.toQueryParmas(dictPost)
        let urlStr = AppDelegate.baseURL + "data_services.php"
        
        let url = URL(string: urlStr)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body.data(using: .utf8)
        print(body)
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
            print(String(decoding: Data(content), as: UTF8.self))
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: [])) as? [[String: Any]] else {
                print("Malformed json")
                print(content)
                
                AppDelegate.showToast(message: "Can not create account", duration: 4, controller: self)
                return
            }
            if (json.count == 1) {
                guard let error = json[0]["title"] else {
                    AppDelegate.showToast(message: json[0]["msg"] as! String, duration: 4, controller: self)
                    return
                }
            }
            
            //            if (json["status"] as! String == "400") {
            //
            //                let message = json["error"] as! String
            //                AppDelegate.showToast(message: message, duration: 4, controller: self)
            //            }
            //            self.dismiss(animated: true, completion: nil)
            //            AppDelegate.showToast(message: "Account created, please login with your new account credentails.", duration: 3, controller: self)
            if let vc = self.embeddedVC {
                print("Updating data")
               vc.data = json
            }
            //            self.data.removeAll()
            //            for row in json {
            //                self.data.append(row)
            //            }
            //            DispatchQueue.main.async {
            //                self.tableView.reloadData()
            //            }
            
        }
        task.resume()
    }
}
//}

extension ServicesListingViewController: UIPickerViewDelegate, UIPickerViewDataSource {


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        selectedItem = items[row]
    }
}

extension ServicesListingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getData()
        // this will hide the keyboard
        textField.resignFirstResponder()
        
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.restorationIdentifier == "FilterA") {
                items = self.filterA
        } else if textField.restorationIdentifier == "FilterB" {
            self.items = self.filterB
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.restorationIdentifier == "FilterA") {
            filterASelected = selectedItem
            filterATxtField.text = filterASelected
        } else if textField.restorationIdentifier == "FilterB" {
            filterBSelected = selectedItem
            filterBTxtField.text = filterBSelected
        }
    }
}
