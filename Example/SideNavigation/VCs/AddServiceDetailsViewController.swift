//
//  AddServiceDetailsViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class AddServiceDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageViewForSelectedImage: UIImageView!
    @IBOutlet var filedsList: [FloatLabelTextField]!
    @IBOutlet weak var serviceName: FloatLabelTextField!
    @IBOutlet weak var serviceCategory: FloatLabelTextField!
    @IBOutlet weak var serviceDescription: FloatLabelTextField!
    @IBOutlet weak var addPromotion: UISwitch!
    @IBOutlet weak var makeFeatured: UISwitch!
    @IBOutlet weak var servicePrice: FloatLabelTextField!
    @IBOutlet weak var promotionDescription: FloatLabelTextField!
    var categoriesList: [String] = ["Car Wash", "Car Detailing", "Mechanic", "Tire Shop", "Tow Truck", "Gas Station", "Oil Change"]

    var selectedImage: UIImage? {
        didSet {
            if let img =  self.selectedImage {
                imageViewForSelectedImage.image = img
                imageViewForSelectedImage.isHidden = false
            }
        }
    }
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        activityView.color = UIColor.black
        self.view.addSubview(activityView)
        promotionDescription.isHidden = true
        imageViewForSelectedImage.isHighlighted = true
        self.filedsList.forEach { (item) in
            item.layer.borderWidth = 1
            item.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        // Create UI PickerView
        let picker = UIPickerView()
        picker.delegate = self
        serviceCategory.inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddServiceDetailsViewController.dismissKeyboard))
        
        toolbar.setItems([btnDone], animated: true)
        toolbar.isUserInteractionEnabled = true
        serviceCategory.inputAccessoryView = toolbar
        
    }
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        if(addPromotion.isOn) {
            promotionDescription.isHidden = false
        } else {
            promotionDescription.isHidden = true
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func imagePickerTapped(_ sender: Any) {
        
        if(!UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            AppDelegate.showToast(message: "Can not open image view", duration: 3, controller: self)
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submit() {
        activityView.startAnimating()
        
        let dictPost: [String: String] = [
            "addservice": "1",
            "name": serviceName.text!,
            "description": serviceDescription.text!,
            "price": servicePrice.text!,
            "category": serviceCategory.text!,
            "feature": makeFeatured.isOn ? ("yes") : ("no"),
            "promotion_desc": "", //
            "sp_id": (AppDelegate.user!["id"] as! String),
            "pprice": servicePrice.text!,
            "user_lat": AppDelegate.loc.lat,
            "user_long": AppDelegate.loc.long
        ]
        let boundary = "Boundary-\(UUID().uuidString)"
        if self.selectedImage == nil {
            AppDelegate.showToast(message: "Please select an image", duration: 4, controller: self)
            return
        }
        
        var data = API.createBody(parameters: dictPost,
                                  boundry: boundary, data: UIImageJPEGRepresentation(self.selectedImage!, 0.7) , mimeType: "image/jpg", filename: "\(UUID().uuidString).jpg")
        
        var request = API.requestHelper("add_services.php", body: data, boundry: boundary)
        
        

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("RESPONSE RECIEVED", data, response, error)
            DispatchQueue.main.async(execute: { () -> Void in
                self.activityView.stopAnimating()
            })
            guard error == nil else {
                print("Error \(error!)")
                let message = "Can not create service, please try again."
               AppDelegate.showToast(message: message, duration: 5, controller: self)
                return
            }
            
            guard let content = data else {
                print("Empty Data \(data!)")
                AppDelegate.showToast(message: "Can not create service, please try again.", duration: 4, controller: self)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Malformed json")
                print(String(data: content, encoding: .utf8))
                
                
                
                AppDelegate.showToast(message: "Can not create service, please try again.", duration: 4, controller: self)
                return
            }
            if (json["status"] as! String == "400") {
                
                let message = json["error"] as! String
                AppDelegate.showToast(message: message, duration: 4, controller: self)
            } else {
                self.dismiss(animated: true, completion: {
                    AppDelegate.showToast(message: "Service created, please login with your new account credentails.", duration: 3, controller: self)
                                print(json)

                })
                
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

extension AddServiceDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        serviceCategory.text = categoriesList[row]
    }
    
}

extension AddServiceDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        self.selectedImage = image
        dismiss(animated: true, completion: nil)
        
        

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
