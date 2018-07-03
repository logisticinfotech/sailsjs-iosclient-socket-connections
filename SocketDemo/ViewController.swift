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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func onClickConnect(_ sender: Any) {
        SocketManagerTest.sharedInstance.establishConnection()
        SocketManagerTest.sharedInstance.establishConnectionReturn { (socketData) -> Void in
        }
    }
    
    
    @IBAction func onClickEmit(_ sender: Any)
    {
        SocketManagerTest.sharedInstance.emitPost()
    }
    
    
    
}

