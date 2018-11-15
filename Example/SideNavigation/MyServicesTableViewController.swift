//
//  MyServicesTableViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class MyServicesTableViewController: UITableViewController {
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var data: [[String: Any]] = [] {
        didSet {
            print(self.data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var isEmbebed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        activityView.color = UIColor.black
        self.view.addSubview(activityView)
        
        // Do any additional setup after loading the view.
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navController = segue.destination as? UINavigationController {
            
            if let recieverVC = navController.topViewController as? ServiceViewDetailsViewController {
                let btn = sender as? UIButton
                if let btn = btn {
                    recieverVC.carDetailsData =  data[btn.tag] as! [String : String]
                }
                
                
            }
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if (!isEmbebed) {
            getData()
        }
    }
    
    // MARK: - Table view data source
    
    @IBAction func getData() {
        
        activityView.startAnimating()
        
        let dictPost: [String: String? ] = [
            "user_service": "1",
            "app_request": "1",
            "uid": (AppDelegate.user!["id"] as! String),
            ]
        
        let body = AppDelegate.toQueryParmas(dictPost)
        let urlStr = AppDelegate.baseURL + "data_services.php"
        
        let url = URL(string: urlStr)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
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
            print(String(decoding: Data(content), as: UTF8.self))
            
            // serialise the data / NSData object into Dictionary [String : Any]
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: [])) as? [[String: String]] else {
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
            self.data = json
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! MyServiceTableViewCell
        
        print("INDEX == ", indexPath.row)
        print(data[indexPath.row])
        print("INDEX ==--------------------------------- ")
        cell.serviceType.text = (data[indexPath.row]["title"] as! String)
        cell.serviceActive.text = (data[indexPath.row]["ad_active"] as! String)
        cell.servicePrice.text = (data[indexPath.row]["price"] as! String) + "$"
        cell.servcieLocation.text = (data[indexPath.row]["city"] as! String)
        cell.serviceRating.text = data[indexPath.row]["average"] as? String
        
        let imgAsData = (data[indexPath.row]["image"] as? String)?.data(using: .utf8)
        
        if let imgAsData = imgAsData {
           let images = try? JSONSerialization.jsonObject(with: imgAsData, options: []) as? Array<String>
            if let images = images {
                
                if (images!.count > 0) {
                    print( AppDelegate.imagesBaseUrl + "service/\(images![0])")
//                    let url = URL(string: AppDelegate.imagesBaseUrl + "service/\(images![0])")
//                    let data = NSData(contentsOf : url!)
                    
                    
                    cell.serviceImage.imageFromServerURL(AppDelegate.imagesBaseUrl + "service/\(images![0])", placeHolder: UIImage(named: "placeholder-image"))
                    
                }
            }
        }
        
        
        
        

        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
