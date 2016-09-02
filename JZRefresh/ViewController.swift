//
//  ViewController.swift
//  JZRefresh
//
//  Created by Jun Zhang on 16/8/25.
//  Copyright © 2016年 Jun Zhang. All rights reserved.
//

import UIKit

let G_PI = CGFloat(M_PI)

let keyHeaderHeight: CGFloat = 60

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "test")

        tableView.header = JZRefreshHeader(frame:CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40))
        tableView.header.performTarget = self
        tableView.header.action = #selector(test)

        tableView.header.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func test() {
        print("treee")
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_MSEC * 13000)), dispatch_get_main_queue(), {
            print("end")
            self.tableView.header.endRefresh()
        })
    }
    
    @IBAction func endAction(sender: AnyObject) {
        tableView.header.endRefresh()
    }

    @IBAction func endRefresh(sender: AnyObject) {
        tableView.header.beginRefresh()
    }
    @IBOutlet weak var refreshAction: UIButton!
    @IBOutlet weak var beginRefresh: UIButton!
}


extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("test")
        cell?.textLabel?.text = String(indexPath.row)
        return cell ?? UITableViewCell()
    }
}





