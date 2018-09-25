//
//  ChatRoomVC.swift
//  SocketDemo
//
//  Created by Jay on 21/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit

class ChatRoomVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- Variables
    let arrRooms = ["Room 1","Room 2","Room 3","Room 4","Room 5"]
    
    // MARK:- IBOutlet
    @IBOutlet weak var tblRooms: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Chat Room"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //    MARK:- UITableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "RoomCell")!
        cell.textLabel?.text = arrRooms[indexPath.row]
        return cell
    }
    

}
