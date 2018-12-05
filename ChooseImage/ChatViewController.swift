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
import IQKeyboardManagerSwift
import TOCropViewController
class ChatViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    
    
    
    
    @IBOutlet weak var tfChat: VerticallyCenteredTextView!
    
    @IBOutlet var rootView: UIView!
    
    
    @IBOutlet weak var imvCamera: UIButton!
    @IBOutlet weak var imvPickImage: UIButton!
    @IBOutlet weak var btnAddOutlet: UIButton!
    @IBOutlet weak var tbView: UITableView!
    
    @IBOutlet weak var imvScrollDown: UIImageView!
    @IBOutlet weak var headerView: UIView!
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
        tbView.register(UINib(nibName: "ChatLeftImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatLeftImageTableViewCell")
        
        
        
        
        
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
        
        //        tbView.scrollToRow(at: <#T##IndexPath#>, at: <#T##UITableViewScrollPosition#>, animated: <#T##Bool#>)
        
        //        self.view.backgroundColor = UIColor.hexStringToUIColor(hex: "F4F4F4")
        //
        //        self.tbView.backgroundColor = UIColor.hexStringToUIColor(hex: "F4F4F4")
        
        //        let backgroundImage = UIImage(named: "bg3")
        //        let imageView = UIImageView(image: backgroundImage)
        //        self.tbView.backgroundView = imageView
        //        tbView.bounds = view.frame.insetBy(dx: 10.0, dy: 50.0)
        
        //        headerView.backgroundColor = UIColor.clear
        rootView.backgroundColor = UIColor.clear
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg12")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        makePlaceHolder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: Notification.Name("getMessage"), object: nil)
        
        
        
        //         IQKeyboardManager.shared.enable = true
        
        
        
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
            
            print("1 ~~~> \(self.rootView.frame.origin.y)")
            keyboardHeight = keyboardSize.height
            if self.rootView.frame.origin.y == 80{
                self.rootView.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc final func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("2 ~~~> \(self.rootView.frame.origin.y)")
            checkIsChattingOrNot(text: tfChat.text)
            scrollToBottom()
            if self.rootView.frame.origin.y != 80{
                self.rootView.frame.origin.y += keyboardSize.height
                
            }
        }
    }
    
    func getMessage(notification: Notification)  {
        print("GetTTTTT")
        tbView.reloadData()
    }
    
    
    @IBAction func btnSendImage(_ sender: Any) {
        //         let joinPU = JoinPhotoPopup.instanceFromNib()
        //        joinPU.animationType = .upDown
        //        joinPU.show()
        self.pickImage(isLibrary: true)
    }
    
    @IBAction func btnSendImageByCamera(_ sender: Any) {
         self.pickImage(isLibrary: false)
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
        hideChatIcon(isChatting: false, text: "")
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        checkIsChattingOrNot(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //         hideChatIcon(isChatting: false)
    }
    
    func hideChatIcon(isChatting:Bool, text:String){
        if isChatting {
            btnAddOutlet.isHidden = false
            imvPickImage.isHidden = true
            imvCamera.isHidden = true
            if text.count == 1 {
                btnAddOutlet.animationScale(uiview: btnAddOutlet)
            }
            
        } else {
            btnAddOutlet.isHidden = true
            imvPickImage.isHidden = false
            imvCamera.isHidden = false
            imvPickImage.animationScale(uiview: imvPickImage)
            imvCamera.animationScale(uiview: imvCamera)
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
            // Left
            switch message.type {
            case "0":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftTableViewCell", for: indexPath) as! ChatLeftTableViewCell
                cell.configLayout(messages: SocketIOManager.messages, index: SocketIOManager.messages.count - (indexPath.row + 1))
                cell.backgroundColor = UIColor.clear
                return cell
            case "1":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatLeftImageTableViewCell", for: indexPath) as! ChatLeftImageTableViewCell
                cell.configLayout(messages: SocketIOManager.messages, index: SocketIOManager.messages.count - (indexPath.row + 1))
                cell.backgroundColor = UIColor.clear
                return cell
            default:
                break
            }
            
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "ChatRightTableViewCell", for: indexPath)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if targetContentOffset.pointee.y > 100 {
            imvScrollDown.isHidden = false
            imvScrollDown.animationScale(uiview: imvScrollDown)
        } else {
            imvScrollDown.isHidden = true
            
        }
        
    }
    
    
    
}

extension ChatViewController: AlreadyShowTheImage {
    func show() {
        
        print("Come here AlreadyShowTheImage")
        // dont need
        //        let indexPath = IndexPath(item: SocketIOManager.messages.count - 1, section: 0)
        //        tbView.reloadRows(at: [indexPath], with: .top)
        
    }
    
    func checkIsChattingOrNot(text:String){
        if tfChat.text != "" {
            hideChatIcon(isChatting: true, text: text)
        } else {
            placeholderLabel.isHidden = false
            placeholderLabel.text = "Messages"
            hideChatIcon(isChatting: false,text: text)
        }
    }
    
    func makePlaceHolder(){
        placeholderLabel = UILabel()
        placeholderLabel.text = "Messages"
        //        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (tfChat.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        tfChat.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tfChat.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !tfChat.text.isEmpty
    }
}

extension ChatViewController {
    
    func uploadImage(image:UIImage){
        //        let image = UIImage.init(named: "ava")
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        
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
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if SocketIOManager.messages.count > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tbView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }    
        }
    }
}

extension ChatViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cropVC = TOCropViewController.init(croppingStyle: .default, image: image )
            cropVC.delegate = self
            cropVC.aspectRatioPreset = .presetSquare
            cropVC.aspectRatioLockEnabled = true
            cropVC.resetAspectRatioEnabled = false
            cropVC.aspectRatioPickerButtonHidden = true
            picker.dismiss(animated: false) {
                self.present(cropVC, animated: false, completion: nil)
            }
        }
    }
}

extension ChatViewController : TOCropViewControllerDelegate {
    func pickImage(isLibrary: Bool) {
        
        let picker = UIImagePickerController()
        picker.sourceType = isLibrary ?  .photoLibrary : .camera
        picker.allowsEditing = false;
        picker.delegate = self;
        self.present(picker, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        
        uploadImage(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
        
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            
        })
    }
}

extension UIView {
    
    func animationScale(uiview:UIView)  {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        uiview.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            uiview.transform = CGAffineTransform.identity
                        }
        })
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
