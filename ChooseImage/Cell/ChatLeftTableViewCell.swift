//
//  ChatLeftTableViewCell.swift
//  ChooseImage
//
//  Created by Ambi on 12/1/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit

class ChatLeftTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imvAva: UIImageView!
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
         imvAva.layer.cornerRadius = imvAva.frame.height/2
         imvAva.clipsToBounds = true
        
        lbMessage.layer.cornerRadius = 8
        lbMessage.layer.masksToBounds = true
        
        lbMessage.backgroundColor =   hexStringToUIColor(hex: "C0D6E4")
        lbMessage.layer.borderColor = UIColor.gray.cgColor
        lbMessage.layer.borderWidth = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configLayout(messages: [Message], index:Int) {
        let message = messages[index]
        switch message.type {
        case "0":
            lbMessage.text = message.content
            
            break
        default:
            break
        }
        
        if index != 0 && messages[index - 1].sendId == UserIdConfigure.leftId {
            imvAva.isHidden = true
        } else {
            imvAva.isHidden = false
        }
        
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
