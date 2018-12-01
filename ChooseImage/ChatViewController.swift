//
//  ChatViewController.swift
//  ChooseImage
//
//  Created by Ambi on 12/1/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit
import ReverseExtension
class ChatViewController: UIViewController {

    
    
   
    @IBOutlet weak var tfChat: UITextField!
    @IBOutlet weak var tbView: UITableView!
    var data = [Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.dataSource = self
        tbView.delegate = self
        tbView.re.delegate = self
        
        
        tbView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
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

    @IBAction func btnAdd(_ sender: Any) {
        data.append(Message(name: tfChat.text!))
        tbView.beginUpdates()
        tbView.re.insertRows(at: [IndexPath(row: data.count - 1, section: 0)], with: .automatic)
        tbView.endUpdates()
        tfChat.text = nil
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
       let message = data[data.count - (indexPath.row + 1)]
        print("~~> \(data.count)  \(indexPath.row)  \(data.count - (indexPath.row + 1))")
        
        cell.configLayout(index: message.name)
        
        return cell
    }
    
    
    
}
