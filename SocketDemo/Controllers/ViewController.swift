//
//  ViewController.swift
//  SocketDemo
//
//  Created by Bhavin on 02/07/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onClickstartWithUser(_ sender: Any) {
    }
    @IBAction func onClickConnect(_ sender: Any) {
        SocketManagerTest.sharedInstance.establishConnection()
        let roomVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        self.navigationController?.pushViewController(roomVC, animated: true)
        SocketManagerTest.sharedInstance.establishConnectionReturn { (socketData) -> Void in
//            let roomVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
//            self.navigationController?.pushViewController(roomVC, animated: true)
        }
    }
    
    
    @IBAction func onClickEmit(_ sender: Any)
    {
        SocketManagerTest.sharedInstance.emitPost()
    }
    
    
    
}

