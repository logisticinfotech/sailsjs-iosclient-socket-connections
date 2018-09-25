//
//  UIViewcontroller+NavigationButton.swift
//  SocketDemo
//
//  Created by Khyati on 31/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import Foundation
import UIKit

var refreshControl: UIRefreshControl!

extension UIViewController {
    func setPullToRefresh(view:UIView){
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        view.addSubview(refreshControl)
        
    }
    @objc func refresh(sender:UIRefreshControl) {
    }
}
