//
//  SetViewController.swift
//  Cofactories
//
//  Created by 宋国华 on 15/11/24.
//  Copyright © 2015年 宋国华. All rights reserved.
//

import UIKit


var selfType:Int!

class SetViewController: UITableViewController{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        let MeVc = MeViewController()
        MeVc.navigationController?.navigationBarHidden = true
        
        // Uncomment the following line to preserve selection between presentations
        
        print("身份类型：\(selfType)")
        
        
     
        initView()
        
    }
    func initView() {
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        self.tableView!.dataSource = self;
        self.tableView!.delegate = self;
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let heightForHeader:CGFloat = 10
        return heightForHeader
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
        return 4
        }
        if section == 1 {
        return 4
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let fontSize : CGFloat = 14.0
        cell.textLabel?.font = UIFont.systemFontOfSize(fontSize)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "手机号"
                break
            case 1:
                cell.textLabel?.text = "名称"
                break
            case 2:
                cell.textLabel?.text = "地址"
                break
            case 3:
                cell.textLabel?.text = "二级身份"
                break
                
            default:
                break
            }
            break
        
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "相册"
                break
            case 1:
                cell.textLabel?.text = "备注"
                break
            case 2:
                cell.textLabel?.text = "邀请码"
                break
            case 3:
                cell.textLabel?.text = "规模"
                break
                
            default:
                break
            }
            break
            
        default:
            break
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let MeVC = MeViewController()
        self.navigationController!.pushViewController(MeVC, animated: true)
    }


}
