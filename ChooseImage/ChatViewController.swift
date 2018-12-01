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
    var data = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        tfChat.autocorrectionType = .no
        
        tbView.dataSource = self
        tbView.delegate = self
        tbView.re.delegate = self
        
        
        tbView.register(UINib(nibName: "ChatRightTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRightTableViewCell")
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

  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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

    @IBAction func btnAdd(_ sender: Any) {
        data.append(Message(name: tfChat.text!))
        tbView.beginUpdates()
        tbView.re.insertRows(at: [IndexPath(row: data.count - 1, section: 0)], with: .automatic)
        tbView.endUpdates()
        tfChat.text = nil
    }
    
    func addImages()  {
        images.append(UIImage(named: "23")!)
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRightTableViewCell", for: indexPath) as! ChatRightTableViewCell
       let message = data[data.count - (indexPath.row + 1)]
        print("~~> \(data.count)  \(indexPath.row)  \(data.count - (indexPath.row + 1))")
        
        cell.configLayout(messages: data, index: data.count - (indexPath.row + 1))
        
        return cell
    }
    
    
    
}
