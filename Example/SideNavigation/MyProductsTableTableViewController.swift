//
//  MyProductsTableTableViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 10/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class MyProductsTableTableViewController: UITableViewController {
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    var data: [[String: String]] = []
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
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    // MARK: - Table view data source
    
    @IBAction func getData() {
        
        activityView.startAnimating()
        
        let dictPost: [String: String? ] = [
            "user_products": "1",
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
                guard let errorJSON = (try? JSONSerialization.jsonObject(with: content, options: [])) as? [String: String] else {
                    
                    return
                }

                AppDelegate.showToast(message: errorJSON["message"]!, duration: 4, controller: self)
                return
            }
            
            if (json.count == 1) {
                guard let error = json[0]["product_name"] else {
                    AppDelegate.showToast(message: json[0]["msg"] as! String, duration: 4, controller: self)
                    return
                }
            }
            self.data.removeAll()
            for row in json {
                self.data.append(row)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        task.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return data.count - 1 // the last row represent status
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseProductCell", for: indexPath) as! MyProductTableViewCell
        
        print("INDEX == ", indexPath.row)
        print("INDEX ==--------------------------------- ")


        cell.productName.text = (data[indexPath.row]["product_name"] as! String)
//        cell.productModel.text = (data[indexPath.row]["model"] as! String)
//        cell.productBrandName.text = (data[indexPath.row]["brand"] as! String)
        cell.productPrice.text = (data[indexPath.row]["price"]) as! String
        cell.productName.text = (data[indexPath.row]["description"]) as! String

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
