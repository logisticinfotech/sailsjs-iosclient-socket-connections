//
//  SDChatVC.swift
//  SocketDemo
//
//  Created by Khyati on 28/08/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit
import SwiftyJSON

class SDChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    //MARK: - IBOutlets
    //MARK: -
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var lblMsgPlaceholder: UILabel!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet var consViewMessageBottom: NSLayoutConstraint!
    @IBOutlet var consViewMessageHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTyping: UILabel!
    
    //MARK: - Class Variables
    //MARK: -
    
    var objOtherOnlineUser : SDOnlineUserBean!
    var arrChatMessages : NSMutableArray = NSMutableArray()
    var keyboardHeight:CGFloat = 0.0
    var timerTyping = Timer()

    //MARK: - ViewController Life Cycle
    //MARK: -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        SocketManagerTest.sharedInstance.objSocketDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        txtViewMessage.becomeFirstResponder()
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
        return arrChatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell?
        if (arrChatMessages.object(at: indexPath.row) as! SDChatBean).fromuser == appDelegate.currentUserId
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "SDSenderTextCell") as! SDSenderTextCell
            (cell as! SDSenderTextCell).lblSenderTextMessage.text = (arrChatMessages.object(at: indexPath.row) as! SDChatBean).mediadata!
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "SDReceiverTextCell") as! SDReceiverTextCell
            (cell as! SDReceiverTextCell).lblReceiverMessage.text = (arrChatMessages.object(at: indexPath.row) as! SDChatBean).mediadata!
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    //MARK: - UITextview delegate Methods
    //MARK: -
    
    func textViewDidChange(_ textView: UITextView)
    {
        if (consViewMessageHeight.constant <= 125.0)  && textView.contentSize.height > 59.0{
            UIView.animate(withDuration: 0.1, animations:
                {
                self.consViewMessageHeight.constant = textView.contentSize.height + 5.0
                self.view.layoutIfNeeded()
            })
        }
        else if textView.contentSize.height < 100 && consViewMessageHeight.constant >= 60.0{
            UIView.animate(withDuration: 0.1, animations:
                {
                self.consViewMessageHeight.constant = self.consViewMessageHeight.constant - 18
                self.view.layoutIfNeeded()
            })
        }
        
        if(textView.text.count == 0)
        {
            textView.resignFirstResponder()
            lblMsgPlaceholder.isHidden = false
        }
        else
        {
            lblMsgPlaceholder.isHidden = true
        }
        
        SocketManagerTest.sharedInstance.emitPrivateMessageTypingSocketSubscribe(toUserId: objOtherOnlineUser.id!) { (response) in}
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if(consViewMessageHeight.constant > 59.0)
        {
            UIView.animate(withDuration: 0.1, animations: {
                self.consViewMessageHeight.constant = 59.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //MARK: - Keyboard Notification Selector     Methods
    //MARK: -
    
    @objc func  keyboardWillShow(_ notification : Notification?)
    {
        self.consViewMessageBottom.constant = 0.0
        UIView.animate(withDuration: 0.2) {
            if let keyboardFrame: NSValue = notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
            {
                let keyboardRectangle = keyboardFrame.cgRectValue
                self.keyboardHeight = keyboardRectangle.height
                var tempConstant : CGFloat = 0

                if #available(iOS 11.0, *)
                {
                    tempConstant += self.keyboardHeight - self.view.safeAreaInsets.bottom
                }
                else
                {
                    tempConstant += self.keyboardHeight
                }
                self.consViewMessageBottom.constant = -tempConstant
            }
            self.view.layoutIfNeeded()
            if (self.arrChatMessages.count) > 0
            {
                let numberOfSections = self.tblChat.numberOfSections
                let numberOfRows = self.tblChat.numberOfRows(inSection: numberOfSections-1)

                self.tblChat.scrollToRow(at: IndexPath.init(row: numberOfRows-1, section: numberOfSections-1), at: .bottom, animated: false)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification : Notification?)
    {
        UIView.animate(withDuration: 0.2){
            self.consViewMessageBottom.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }

    //MARK: - IBAction Event Methods
    //MARK: -
    
    @IBAction func onClickSendMessage(_ sender: Any)
    {
        if !txtViewMessage.text.isEmpty
        {
            SocketManagerTest.sharedInstance.emitSendPrivateMessageSocketSubscribe(strMsg: txtViewMessage.text, userId: Int(appDelegate.currentUserId!), toUserId: objOtherOnlineUser.id!) { (dictResponse) in
                
                let dictActionData = (dictResponse?.object(forKey: "data") as! NSDictionary).object(forKey: "actionsdata")
                self.arrChatMessages.add(SDChatBean.init(json: JSON.init(dictActionData!)))
                self.tblChat.reloadData()
                
                DispatchQueue.main.async{
                    self.tblChat.scrollToRow(at: IndexPath.init(row: self.arrChatMessages.count - 1, section: 0), at: .top, animated: true)
                }
            }
        }
        txtViewMessage.text = ""
        self.consViewMessageHeight.constant = 59.0
    }
    
    //MARK: - Misc Methods
    //MARK: -
    
    //set appearance
    func setAppearance()
    {
        self.navigationItem.title = objOtherOnlineUser.username
        tblChat.tableFooterView = UIView()
        tblChat.separatorColor = UIColor.clear
        txtViewMessage.delegate = self
        let tapGestureStartDate = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tblChat.addGestureRecognizer(tapGestureStartDate)
        lblTyping.isHidden = true
    }
    
    func getChatHistory()
    {
        let dictParameters = ["userid":appDelegate.currentUserId!,"createdAt":""] as [String : Any]
        sharedAFUtility.doRequestFor(APIDetails.GetChatHistory, method: .post, dicsParams: dictParameters, dicsHeaders: nil, completionHandler: { (response, statusCode, error) in
            if response == nil
            {
                return
            }
            if statusCode == 200
            { // Success
                if(response?.object(forKey: "data") != nil)
                {
                }
                else
                {
                    showAlertInTabWithTitle(CommonConstants.AlertTitle, message: ( response?.object(forKey: "message") as! String), viewController: self)
                }
            }
            else
            {
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
    
    @objc func handleTapGesture(_ sender:UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
}

//# MARK: - SocketWrapperDelegate Method
//# MARK: -

extension SDChatVC : SocketDelegate
{
    func receivePrivateMessage(_ data: NSDictionary)
    {
        print("message data ------->,\(data)")
        let objChatBean = SDChatBean.init(json: JSON.init(data.object(forKey: "chat")!))
        
        if objChatBean.fromuser == objOtherOnlineUser.id
        {
            self.arrChatMessages.add(objChatBean)
            self.tblChat.reloadData()
            
            DispatchQueue.main.async{
                self.tblChat.scrollToRow(at: IndexPath.init(row: self.arrChatMessages.count - 1, section: 0), at: .top, animated: true)
            }
        }
    }
    
    func receiveTypingSocket(_ data: NSDictionary)
    {
        if data.object(forKey: "fromuser") as? Int == self.objOtherOnlineUser.id
        {
            timerTyping.invalidate()
            
            lblTyping.text = "  \(self.objOtherOnlineUser.username!) is typing...  "
            lblTyping.isHidden = false
          
            timerTyping = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { (timer) in
                self.lblTyping.isHidden = true
            })
        }        
    }
}
