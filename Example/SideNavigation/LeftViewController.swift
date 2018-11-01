
//
//  LeftViewController.swift
//  Slide
//
//  Created by Steve on 2017/8/1.
//  Copyright © 2017年 Jack. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    var tableView: UITableView!
    var items = ["Profile", "Servies", "Chat", "Request Car Inspection", "My Cars for sale", "My Services", "My Products", "Change Password", "Logout"]
    var didselected: ((IndexPath) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        let headerView = UIView(frame: .zero)
        
        headerView.backgroundColor = UIColor(red: ((1/255) * 244), green: ((1/255) * 165), blue: ((1/255) * 76), alpha: 1)
        tableView.tableHeaderView = headerView
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.top)
            make.width.equalTo(tableView.snp.width)
            make.height.equalTo(180)
        }
        headerView.superview?.layoutIfNeeded()
    }

    func startdismiss()  {
        self.dismiss(animated: false, completion: nil)
    }
}

extension LeftViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didselected?(indexPath)
        self.dismiss(animated: true, completion: nil)
    }
}


