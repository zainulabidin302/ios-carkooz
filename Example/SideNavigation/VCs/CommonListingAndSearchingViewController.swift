//
//  CommonListingAndSearchingViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CommonListingAndSearchingViewController: UIViewController {

    @IBOutlet weak var searchBy: DesignableUITextField!
    @IBOutlet weak var searchCity: DesignableUITextField!
    @IBOutlet weak var maxPrice: DesignableUITextField!
    
    
    @IBOutlet weak var viewLbl: UILabel!
    var items: [String] = []
    var selectedItem: String = ""
    
    var viewId: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewLbl.text = viewId
        searchBy.layer.borderWidth = 1
        searchBy.layer.borderColor = UIColor.lightGray.cgColor
        searchCity.layer.borderWidth = 1
        searchCity.layer.borderColor = UIColor.lightGray.cgColor
        maxPrice.layer.borderWidth = 1
        maxPrice.layer.borderColor = UIColor.lightGray.cgColor
        self.title = viewId
        
        if (viewId == "Car Accessories") {
            items = ["Rating", "Location"]
            searchBy.placeholder = "Search City"
            self.title = "Products"
            
        } else if (viewId == "New Cars") {
            items = ["Rating", "Location"]
            searchBy.placeholder = "Search Name"
            self.title = "New Cars"
            
        } else if (viewId == "Used Cars") {
            items = ["Rating", "Location"]
            searchBy.placeholder = "Search Name"
            self.title = "Used Cars"

        }
        else {
            
            items = ["NON"]
            searchBy.placeholder = "N/A"

        }
        
        createPicker()
        createToolbar()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func createToolbar() {
        var toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CommonListingAndSearchingViewController.dismissKeyboard))
        
        toolbar.setItems([doneBtn], animated: false)
        toolbar.isUserInteractionEnabled = true
        searchBy.inputAccessoryView = toolbar
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        searchBy.text = selectedItem
    }
    func createPicker() {
        
       let picker = UIPickerView()
        picker.delegate = self
        searchBy.inputView = picker
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

extension CommonListingAndSearchingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
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

extension CommonListingAndSearchingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this will hide the keyboard
        textField.resignFirstResponder()
        
        print("Send remote Request now")
        return true
    }
}
