//
//  ChatViewController.swift
//  ChooseImage
//
//  Created by Ambi on 12/1/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit
import ReverseExtension
class ChatViewController: UIViewController, UITextViewDelegate {

    
    
   
 
    @IBOutlet weak var tfChat: UITextField!
    @IBOutlet weak var tbView: UITableView!
//    var messages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        tfChat.autocorrectionType = .no
        
        tbView.dataSource = self
        tbView.delegate = self
        tbView.re.delegate = self
        
        
        tbView.register(UINib(nibName: "ChatRightTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRightTableViewCell")
        tbView.register(UINib(nibName: "ChatLeftTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatLeftTableViewCell")
        tbView.separatorStyle = .none
        tbView.rowHeight = UITableViewAutomaticDimension
        tbView.backgroundColor = .clear
        
        //You can apply reverse effect only set delegate.
        tbView.re.scrollViewDidReachTop = { scrollView in
            print("scrollViewDidReachTop")
        }
        tbView.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        
        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: "F4F4F4")

        self.tbView.backgroundColor = UIColor.hexStringToUIColor(hex: "F4F4F4")
        
//        let backgroundImage = UIImage(named: "ava")
//        let imageView = UIImageView(image: backgroundImage)
//        self.tbView.backgroundView = imageView
        
        
//        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
//        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.frame = self.view.bounds
//        
//        self.tbView.layer.addSublayer(gradientLayer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: Notification.Name("getMessage"), object: nil)
        
        SocketIOManager.sharedInstance.connection()
        
       
    }
    
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func hide() {
        self.tfChat?.resignFirstResponder()
    }
    

    var keyboardHeight:CGFloat? = nil
    @objc final func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("1 ~~~> \(self.view.frame.origin.y)")
            keyboardHeight = keyboardSize.height
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc final func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
               print("2 ~~~> \(self.view.frame.origin.y)")
            
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func getMessage(notification: Notification)  {
        print("GetTTTTT")
        tbView.reloadData()
    }
    

    @IBAction func btnAdd(_ sender: Any) {
        
       let message = Message()
       message.receiveId = UserIdConfigure.leftId
       message.sendId = UserIdConfigure.rightId
       message.roomId = UserIdConfigure.roomId
       message.content = self.tfChat.text!
       message.type = "0"
        
        sendMessage(message)

    }
    
    func addImages()  {
        images.append(UIImage(named: "23")!)
    }
    
    func sendMessage(_ message: Message) {
        
        SocketIOManager.sharedInstance.sendMessage(message:message)
        SocketIOManager.messages.append(message)
        
        print("Size of messages is \(SocketIOManager.messages.count)")
        
        tbView.beginUpdates()
        tbView.re.insertRows(at: [IndexPath(row: SocketIOManager.messages.count - 1, section: 0)], with: .automatic)
        tbView.endUpdates()
        
        
    }
    

    
    
    var images = [UIImage]()
    var scrollView = UIScrollView()
    var isShow = false
    
    @IBAction func btnImage(_ sender: Any) {
        
            addImages()
        
//        let scrollView = UIScrollView()
        
        let image = UIImage(named: "23")!
        
    
        
        for i in 0..<images.count {
            let imageView = UIImageView()
            let x = self.view.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[i]
            
            scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
        
        
        
        
        
        var customView = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-keyboardHeight!, width: self.view.frame.size.width, height: keyboardHeight!))
        customView.backgroundColor = UIColor.blue
        customView.layer.zPosition = CGFloat(MAXFLOAT)
        customView.addSubview(scrollView)
        
        var windowz = UIApplication.shared.windows
        
        var windowCount = windowz.count
        if !isShow {
             customView.isHidden = false
            windowz[windowCount-1].addSubview(customView);
        } else {
           windowz.removeLast()
        }
        
        isShow = !isShow
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        self.isMenuHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {

    }

    

}

extension ChatViewController: UITableViewDelegate {
    //ReverseExtension also supports handling UITableViewDelegate.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.y =", scrollView.contentOffset.y)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SocketIOManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let message = SocketIOManager.messages[SocketIOManager.messages.count - (indexPath.row + 1)]
        if message.sendId == UserIdConfigure.rightId {
            //Right
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightTableViewCell", for: indexPath) as! ChatRightTableViewCell
            cell.configLayout(messages: SocketIOManager.messages, index: SocketIOManager.messages.count - (indexPath.row + 1))
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftTableViewCell", for: indexPath) as! ChatLeftTableViewCell
            cell.configLayout(messages: SocketIOManager.messages, index: SocketIOManager.messages.count - (indexPath.row + 1))
             cell.backgroundColor = UIColor.clear
            return cell
            
        }
        
       
    }
    
    
    
}
