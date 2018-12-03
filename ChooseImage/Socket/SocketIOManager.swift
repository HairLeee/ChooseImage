//
//  SocketIOManager.swift
//  RSAMobile
//
//  Created by Tcsytems on 11/27/18.
//  Copyright © 2018 TCSVN. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
   // for swift 4
//    var manager = SocketManager(socketURL: URL(string: "http://10.1.5.91:6789")!)
    //    var manager = SocketManager(socketURL: URL(string: "http://35.187.243.177:6789")!)
//    lazy var socket = manager.defaultSocket
    
    
    //for swift3
    lazy var socket = SocketIOClient(socketURL: URL(string: "http://10.1.5.161:6789")!)
//    lazy var socket = SocketIOClient(socketURL: URL(string: "http://35.187.243.177:6789")!)
    static var messages = [Message]()
    override init() {
        super.init()
        
        socket.on("sendMessage") { (dataArray, socketAck) -> Void in
            let stringData = dataArray[0] as! String
            let data = stringData.data(using: .utf8)!
            
           
            let jsonArray = try! JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [[String:Any]]
            
             print("data = \(jsonArray![0])")
            if jsonArray?.count == 1 {
                // Everytime you have got a new message !
                let message = Message()
                message.receiveId = jsonArray![0]["reciveId"] as! String
                message.sendId = jsonArray![0]["sendId"] as! String
                message.roomId = jsonArray![0]["roomId"] as! String
                message.content = jsonArray![0]["content"] as! String
                message.type = jsonArray![0]["type"] as! String
                  SocketIOManager.messages.append(message)
                   NotificationCenter.default.post(name: Notification.Name("getMessage"), object:nil)
                
                
//                if let message = Message(JSON: jsonArray![0]) {
//                     SocketIOManager.messages.append(message)
//                       NotificationCenter.default.post(name: Notification.Name("getMessage"), object:nil)
//                }
    
            } else {
                // Come here just 1 times - the first time enter the room
                for json in jsonArray! {
                    if let message = Message(JSON: json){
                        if message.sendId != UserIdConfigure.rightId {
                            SocketIOManager.messages.append(message)
                        }
                        
                    }
                }
                
                  NotificationCenter.default.post(name: Notification.Name("getAllMessage"), object:nil)
            }
       
           
        }

        socket.on("connect") { (dataArray, socketAck) -> Void in
            print("-------connect-------")
        }
    }
    
    //Date to milliseconds
    func currentTimeInMiliseconds() -> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    func connection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendMessage(message:Message) {
        let dicData = ["roomId" : message.roomId, "sendId" : message.sendId,"reciveId" : message.receiveId,"content" : message.content, "type": message.type]
        socket.emit("sendMessage", dicData)
    }
    
    func getListMessage(roomId: String) {
        let dicData = ["roomId" : roomId]
        socket.emit("getListMessage", dicData)
    }
    
}
