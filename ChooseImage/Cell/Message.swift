//
//  Message.swift
//  ChooseImage
//
//  Created by Ambi on 12/1/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit

enum MessageType {
    case text
    case image
    case icon
}

class Message : NSObject {
    
    var receiveId:String = ""
    var sendId:String = ""
    var roomId:String = ""
    var content:String = ""
    var type:MessageType
    var date: Date
    
    init(receiveId:String,sendId:String,roomId:String,content:String, type: MessageType,date: Date) {
        self.receiveId = receiveId
        self.sendId = sendId
        self.roomId = roomId
        self.content = content
        self.type = type
        self.date = date
    }
    
    
}
