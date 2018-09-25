//
//  SDCreateUserVC.swift
//  SocketDemo
//
//  Created by Khyati on 28/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit
import PKHUD

class SDCreateUserVC: UIViewController {
    
    //MARK: - IBOutlets
    //MARK: -
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtYourName: UITextField!
    
    //MARK: - ViewController Life Cycle
    //MARK: -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setAppearance()
    }

    //MARK: - IBAction Event Methods
    //MARK: -
    
    @IBAction func onClickBtnLogin(_ sender: Any)
    {
        if txtYourName.text != nil && txtYourName.text != ""
        {
            view.endEditing(true)
            HUD.show(.systemActivity)
            let dictParameters = ["username":txtYourName.text!]
            sharedAFUtility.doRequestFor(APIDetails.CreateUser, method: .post, dicsParams: dictParameters, dicsHeaders: nil, completionHandler: { (response, statusCode, error) in
                if response == nil
                {
                    HUD.hide()
                    return
                }
                
                if statusCode == 200
                { // Success
                    HUD.flash(.success)
                    if response?.object(forKey: "data") != nil
                    {
                        if (response?.object(forKey: "data") as! NSDictionary).object(forKey: "id") != nil
                        {
                            appDelegate.currentUserId = ((response?.object(forKey: "data") as! NSDictionary).object(forKey: "id")) as? Int
                        }
                    }
                    SocketManagerTest.sharedInstance.establishConnection()
                    let userListVC = StoryBoards.SDUserListSB.instantiateViewController(withIdentifier: "SDUserListVC") as! SDUserListVC
                    self.navigationController?.pushViewController(userListVC, animated: true)
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
        else
        {
            showAlertWithTitle(CommonConstants.AlertTitle, message: "Please enter your name")
        }
    }
    
    //MARK: - Misc Methods
    //MARK: -
    
    // set appearance
    func setAppearance()
    {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
}
