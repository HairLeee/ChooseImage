//
//  ChatViewController.swift
//  ChooseImage
//
//  Created by Ambi on 12/1/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit
import ReverseExtension
import Alamofire
import ObjectMapper
class ChatViewController: UIViewController, UITextViewDelegate {

    
    
   
 
    @IBOutlet weak var tfChat: UITextView!
    @IBOutlet weak var imvPickImage: UIButton!
    @IBOutlet weak var btnAddOutlet: UIButton!
    @IBOutlet weak var tbView: UITableView!
    var placeholderLabel : UILabel!
//    var messages = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        tfChat.autocorrectionType = .no
        tfChat.delegate = self
        
        tbView.dataSource = self
        tbView.delegate = self
        tbView.re.delegate = self
    
        
        tbView.register(UINib(nibName: "ChatRightTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRightTableViewCell")
        tbView.register(UINib(nibName: "ChatLeftTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatLeftTableViewCell")
             tbView.register(UINib(nibName: "ChatRightImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRightImageTableViewCell")
        
        
        
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
        
//        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: "F4F4F4")
//
//        self.tbView.backgroundColor = UIColor.hexStringToUIColor(hex: "F4F4F4")
        
        let backgroundImage = UIImage(named: "bg3")
        let imageView = UIImageView(image: backgroundImage)
        self.tbView.backgroundView = imageView
        tbView.bounds = view.frame.insetBy(dx: 10.0, dy: 50.0)

       hideChatIcon(isChatting: false)
       makePlaceHolder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: Notification.Name("getMessage"), object: nil)
        
//        SocketIOManager.sharedInstance.connection()
        
        
      
       
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
           checkIsChattingOrNot()
            
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func getMessage(notification: Notification)  {
        print("GetTTTTT")
        tbView.reloadData()
    }
    
    
    @IBAction func btnSendImage(_ sender: Any) {
        uploadImage()
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
    
    func sendMessage(_ message: Message) {
        
        SocketIOManager.sharedInstance.sendMessage(message:message)
        SocketIOManager.messages.append(message)
        
        print("Size of messages is \(SocketIOManager.messages.count)")
        
        tbView.beginUpdates()
        tbView.re.insertRows(at: [IndexPath(row: SocketIOManager.messages.count - 1, section: 0)], with: .automatic)
        tbView.endUpdates()
        
        tfChat.text = nil
        hideChatIcon(isChatting: false)
        
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkIsChattingOrNot()
    }
    
    func textViewDidChange(_ textView: UITextView) {
         placeholderLabel.isHidden = !textView.text.isEmpty
        checkIsChattingOrNot()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//         hideChatIcon(isChatting: false)
    }

    func hideChatIcon(isChatting:Bool){
        if isChatting {
            btnAddOutlet.isHidden = false
            imvPickImage.isHidden = true
        } else {
            btnAddOutlet.isHidden = true
            imvPickImage.isHidden = false
        }
        
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
            switch message.type {
            case "0":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightTableViewCell", for: indexPath) as! ChatRightTableViewCell
                cell.configLayout(messages: SocketIOManager.messages, index: SocketIOManager.messages.count - (indexPath.row + 1))
                cell.backgroundColor = UIColor.clear
                return cell
            case "1":
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightImageTableViewCell", for: indexPath) as! ChatRightImageTableViewCell
                    cell.alreadyShowTheImage = self
                cell.configLayout(messages: SocketIOManager.messages, index: SocketIOManager.messages.count - (indexPath.row + 1))
                cell.backgroundColor = UIColor.clear
                return cell
                
                
            default:
                break
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftTableViewCell", for: indexPath) as! ChatLeftTableViewCell
            cell.configLayout(messages: SocketIOManager.messages, index: SocketIOManager.messages.count - (indexPath.row + 1))
             cell.backgroundColor = UIColor.clear
            return cell
            
        }
        
       return tableView.dequeueReusableCell(withIdentifier: "ChatRightTableViewCell", for: indexPath)
    }
    
    
    
}

extension ChatViewController: AlreadyShowTheImage {
    func show() {
        
        print("Come here AlreadyShowTheImage")
        // dont need
//        let indexPath = IndexPath(item: SocketIOManager.messages.count - 1, section: 0)
//        tbView.reloadRows(at: [indexPath], with: .top)

    }
    
    func checkIsChattingOrNot(){
        if tfChat.text != "" {
            hideChatIcon(isChatting: true)
        } else {
            placeholderLabel.isHidden = false
            placeholderLabel.text = "Say Something..."
            hideChatIcon(isChatting: false)
        }
    }
    
    func makePlaceHolder(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "Say Something..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (tfChat.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        tfChat.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tfChat.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tfChat.text.isEmpty
    }
}

extension ChatViewController {
    
    func uploadImage(){
        let image = UIImage.init(named: "leftchat")
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "chatImage",fileName: "file.jpg", mimeType: "image/jpg")
        },
        to:"http://35.187.243.177:6789/upload")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
   
                })
                
                upload.responseJSON { response in
              
                    if let serverRes = Mapper<ServerResponse>().map(JSONObject: response.result.value) {
                        print("url = \(serverRes.urlImage)")
                        let message = Message()
                        message.receiveId = UserIdConfigure.leftId
                        message.sendId = UserIdConfigure.rightId
                        message.roomId = UserIdConfigure.roomId
                        message.content = serverRes.urlImage
                        message.type = "1"
                        self.sendMessage(message)
                    }
                    
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}

class ServerResponse: Mappable {
    
    
    var urlImage:String = ""

    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        urlImage <- map["urlImage"]
  
    }
    
    
}


class VerticallyCenteredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
}
