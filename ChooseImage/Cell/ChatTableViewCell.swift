//
//  ChatTableViewCell.swift
//  ChooseImage
//
//  Created by Ambi on 12/1/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configLayout(index:String){
        lbName.text = index
    }
    
}
