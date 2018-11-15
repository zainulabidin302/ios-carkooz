//
//  LoginViewController.swift
//  Carkooz
//
//  Created by apple on 10/28/18.
//  Copyright © 2018 Tendril. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var password: DesignableUITextField!
    @IBOutlet weak var email: DesignableUITextField!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        AppDelegate.location  = locValue
    }
    
    @IBAction func signIn() {
        activityView.startAnimating()
        var request = URLRequest(url: URL(string: "https://carkooz.com/database/login.php")!)
        let data = "login=1&email=\(self.email.text!)&password=\(self.password.text!)"
        print(data)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = data.data(using: .utf8)
        request.httpMethod = "POST"
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
            }
            print("response recieved")
            guard error == nil else {
                AppDelegate.showToast(message: "Please check your connection", duration: 4, controller: self)
                return
            }
            
            guard let content = data else {
                AppDelegate.showToast(message: "Something went wrong, please try again.", duration: 4, controller: self)
                return
            }
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                AppDelegate.showToast(message: "Something went wrong, please try again.", duration: 4, controller: self)
                print(content)
                print("Malformed json")
                return
            }

            
            AppDelegate.user = json
            DispatchQueue.main.async(execute: { () -> Void in
                let newController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController")
                self.present(newController!, animated: true, completion: nil)
            })
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
