//
//  Message.swift
//  ChooseImage
//
//  Created by Ambi on 12/1/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit
import ObjectMapper

struct MessageType {
    var text = "0"
    var image = "1"
    var icon = "2"
}

class Message : Mappable {
    
    var receiveId:String = ""
    var sendId:String = ""
    var roomId:String = ""
    var content:String = ""
    var type: String = "0"
    var date: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        receiveId <- map["reciveId"]
        receiveId <- map["sendId"]
        receiveId <- map["roomId"]
        receiveId <- map["content"]
        receiveId <- map["type"]
        receiveId <- map["date"]
    }
    
    

    
//    init(receiveId:String,sendId:String,roomId:String,content:String, type: MessageType,date: Date) {
//        self.receiveId = receiveId
//        self.sendId = sendId
//        self.roomId = roomId
//        self.content = content
//        self.type = type
//        self.date = date
//    }
    
    
}
