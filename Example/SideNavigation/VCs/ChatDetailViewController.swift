//
//  ChatDetailViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 11/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ChatDetailViewController: UIViewController {

    @IBOutlet weak var chatWindow: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let messages = ["Message 1", "Message 2", "Message 3"]
        
        for message in messages {
            let lbl = UILabel()
            lbl.text = message
            chatWindow.addSubview(lbl)
            
        }
        // Do any additional setup after loading the view.
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

extension ChatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "chatDetailViewCell", for: indexPath)
     
     return cell
     }

    
    
}
