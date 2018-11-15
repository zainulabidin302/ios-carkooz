//
//  ChatViewController.swift
//  SideNavigation_Example
//
//  Created by apple on 11/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import PusherChatkit

class ChatViewController : UIViewController {

    @IBOutlet weak var roomsTableView: UITableView!
    var chatManager: ChatManager!
    var currentUser: PCCurrentUser?
    var rooms: [PCRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tokenProvider = PCTokenProvider(
            url: "http://localhost:3002/auth",
            requestInjector: { req -> PCTokenProviderRequest in
                req.addQueryItems([URLQueryItem(name: "user_id", value: (AppDelegate.user!["email"] as! String))])
                
                return req
        }
        )
        
        chatManager = ChatManager(
            instanceLocator: "v1:us1:f9fd21ab-6a42-4df0-b895-b6db026c0616",
            tokenProvider: tokenProvider,
            userId: "zain")
        
        
        chatManager.connect(delegate: self as! PCChatManagerDelegate) { [unowned self] currentUser, error in
            guard error == nil else {
                print("Error connecting: \(error!.localizedDescription)")
                return
            }
            print("Connected!")
            
            guard let currentUser = currentUser else { return }
            self.currentUser = currentUser
            self.rooms = currentUser.rooms
            DispatchQueue.main.async {
                print(self.rooms[0])
                self.roomsTableView.reloadData()
            }
        }
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
extension ChatViewController: PCChatManagerDelegate {}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rooms.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseRoomCell", for: indexPath)
        
        print(rooms[indexPath.row])
        cell.textLabel?.text = rooms[indexPath.row].name
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailView")
        
        present(ctrl!, animated: true, completion: nil)
    }
    
}
