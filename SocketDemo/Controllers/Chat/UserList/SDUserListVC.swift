//
//  SDUserListVC.swift
//  SocketDemo
//
//  Created by Khyati on 28/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit
import PKHUD
import SwiftyJSON

class SDUserListVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    //MARK: - IBOutlets
    //MARK: -
 
    @IBOutlet weak var tblUserList: UITableView!
    
    //MARK: - Class Variables
    //MARK: -
    
    var arrUsers = NSMutableArray()
    
    //MARK: - ViewController Life Cycle
    //MARK: -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+1)
        {
            SocketManagerTest.sharedInstance.emitChangeUserStatusSocketSubscribe(strStatus: UserStatus.online.rawValue) { (response) in}
        }
        self.setAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        SocketManagerTest.sharedInstance.objSocketDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        SocketManagerTest.sharedInstance.objSocketDelegate = nil
    }
    
    //MARK: - UITableView Delegate Methods
    //MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SDUserListCell") as! SDUserListCell
        cell.lblTitle.text = (arrUsers.object(at: indexPath.row) as! SDOnlineUserBean).username
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let chatVC = StoryBoards.SDChatSB.instantiateViewController(withIdentifier: "SDChatVC") as! SDChatVC
        chatVC.objOtherOnlineUser = arrUsers.object(at: indexPath.row) as! SDOnlineUserBean
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    //MARK: - User Define Methods
    //MARK: -
    
    //set appearance
    func setAppearance()
    {
        self.navigationItem.title = "User List"
        self.navigationItem.setHidesBackButton(true, animated:false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tblUserList.tableFooterView = UIView()
        self.getOnlineUserList()
        if refreshControl != nil
        {
            refreshControl.endRefreshing()
        }
        self.setPullToRefresh(view: self.tblUserList)
    }
    
    override func refresh(sender:UIRefreshControl)
    {
        self.getOnlineUserList()
        sender.endRefreshing()
    }
    
    // get online user list
    func getOnlineUserList()
    {
        view.endEditing(true)
        arrUsers.removeAllObjects()
        HUD.show(.systemActivity)
        sharedAFUtility.doRequestFor(APIDetails.GetOnlineUserList+"1", method: .get, dicsParams: nil, dicsHeaders: nil, completionHandler: { (response, statusCode, error) in
            if response == nil
            {
                HUD.hide()
                return
            }
            if statusCode == 200
            { // Success
                HUD.flash(.success)
                if(response?.object(forKey: "data") != nil){
                    if ((response?.object(forKey: "data")) as! NSArray).count > 0{
                        for objUserData in (response?.object(forKey: "data")) as! NSArray{
                            let objUser = SDOnlineUserBean.init(json: JSON(objUserData))
                            if objUser.id != Int(appDelegate.currentUserId!){
                                self.arrUsers.add(objUser)
                            }
                        }
                        self.tblUserList.reloadData()
                    }
                }
                else
                {
                    showAlertInTabWithTitle(CommonConstants.AlertTitle, message: ( response?.object(forKey: "message") as! String), viewController: self)
                }
            }
            else
            {
                HUD.flash(.error)
                if error != nil
                {
                    showAlertWithTitle(CommonConstants.AlertTitle, message:(error?.localizedDescription)!)
                }
                else
                {
                    if (response?.object(forKey: "error")) != nil
                    {
                        showAlertWithTitle(CommonConstants.AlertTitle, message: (response?.object(forKey: "error") as! String))
                    }
                    else
                    {
                        showAlertWithTitle(CommonConstants.AlertTitle, message: (response?.object(forKey: "message") as! String))
                    }
                }
            }
        })
    }
}

//MARK: - User Define Methods
//MARK: -

extension SDUserListVC : SocketDelegate
{
    func receiveUserStatusUpdateSocket(_ data: NSDictionary)
    {
        let objUser = SDOnlineUserBean.init(json: JSON(data.object(forKey: "actionsdata")!))
      
        if objUser.userstatus == "offline"
        {
            let arrOfflineUser = arrUsers.filter{ ($0 as! SDOnlineUserBean).id == objUser.id }
            
            if arrOfflineUser.count > 0
            {
                for objOfflineUser in arrOfflineUser
                {
                    arrUsers.remove(objOfflineUser)
                }
                tblUserList.reloadData()
            }
        }
        else
        {
            if objUser.id != appDelegate.currentUserId
            {
                arrUsers.add(objUser)
                tblUserList.reloadData()
            }
        }
    }
}
