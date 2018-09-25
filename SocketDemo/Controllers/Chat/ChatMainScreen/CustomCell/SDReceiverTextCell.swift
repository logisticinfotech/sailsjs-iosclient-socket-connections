//
//  SDReceiverTextCell.swift
//  SocketDemo
//
//  Created by Khyati on 28/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit

class SDReceiverTextCell: UITableViewCell {

    @IBOutlet var lblReceiverTextMessageTime: UILabel!
    @IBOutlet var lblReceiverMessage: UILabel!
    @IBOutlet var viewReceiverTextMessage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewReceiverTextMessage.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
