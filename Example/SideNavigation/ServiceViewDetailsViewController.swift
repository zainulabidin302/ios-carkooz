//
//  ServiceViewDetailsViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 11/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ServiceViewDetailsViewController: UIViewController {
    var carDetailsData: [String: String] = [:]
    
    
    @IBOutlet weak var phoneLabelView: UIView!
    @IBOutlet weak var chatLabelView: UIView!
    
    @IBOutlet weak var serviceProviderDetailsView: UIView!
    @IBOutlet weak var descriptionLabelView: UIView!
    @IBOutlet weak var ratingLabelView: UIView!
    @IBOutlet weak var otherFeaturesView: UIView!
    
    
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var chatLabel: UIView!
    
    
    
    @IBOutlet weak var serviceProviderNameLbl: UILabel!
    
    @IBOutlet weak var serviceProviderEmailLbl: UILabel!
    @IBOutlet weak var serviceProviderWebsiteLbl: UILabel!
    @IBOutlet weak var serviceProviderAddressLbl: UILabel!
    @IBOutlet weak var serviceProviderCitybl: UILabel!
    @IBOutlet weak var serviceProviderStateLbl: UILabel!
    @IBOutlet weak var serviceProviderCountryLbl: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        self.priceLabel.text = self.carDetailsData["price"]

        
        
        
        self.serviceProviderNameLbl.text = self.carDetailsData["name"]
        self.serviceProviderEmailLbl.text = self.carDetailsData["email"]
        self.serviceProviderWebsiteLbl.text = self.carDetailsData["website"]
        self.serviceProviderAddressLbl.text = self.carDetailsData["address"]
        self.serviceProviderCitybl.text = self.carDetailsData["city"]
        self.serviceProviderStateLbl.text = self.carDetailsData["state"]
        self.serviceProviderCountryLbl.text = self.carDetailsData["country"]
        
        
        
        borderize(phoneLabelView)
        borderize(chatLabelView)
        borderize(otherFeaturesView)
        borderize(ratingLabelView)
        borderize(descriptionLabelView)
        borderize(serviceProviderDetailsView)
        
        
        
        
    }
    
    func borderize(_ view: UIView) {
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
    }
    
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
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
