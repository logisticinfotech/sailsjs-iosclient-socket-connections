//
//  SDSenderTextCell.swift
//  SocketDemo
//
//  Created by Khyati on 28/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit

class SDSenderTextCell: UITableViewCell {

    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet var lblSenderTextMessageTime: UILabel!
    @IBOutlet var lblSenderTextMessage: UILabel!
    @IBOutlet var viewSenderTextMessage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSenderTextMessage.layer.cornerRadius = 12
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
