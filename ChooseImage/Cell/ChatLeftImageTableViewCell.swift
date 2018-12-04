//
//  ChatRightImageTableViewCell.swift
//  ChooseImage
//
//  Created by Fullname on 12/3/18.
//  Copyright © 2018 Ambi. All rights reserved.
//

import UIKit
import Kingfisher



class ChatLeftImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var width: NSLayoutConstraint!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var imvThumb: UIImageView!
    var alreadyShowTheImage:AlreadyShowTheImage? = nil
    var imgageUrl = "https://cdn.pixabay.com/photo/2017/10/05/06/46/asia-2818562_960_720.jpg"
    override func awakeFromNib() {
        
        super.awakeFromNib()
        imvThumb.layer.cornerRadius = 8
        imvThumb.layer.masksToBounds = true
        //        showImage()
    }
    
    func configLayout(messages:[Message], index:Int){
        imgageUrl = messages[index].content
        showImage()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func showImage()  {
        if imgageUrl == "" { return }
        imvThumb.isHidden = true
        let url = URL(string: imgageUrl)!
        let screenSize: CGRect = UIScreen.main.bounds
        imvThumb.kf.setImage(with: url,
                             placeholder: nil,
                             options: [.transition(ImageTransition.fade(0))],
                             progressBlock: { receivedSize, totalSize in
                                
        },
                             completionHandler: { image, error, cacheType, imageURL in
                                self.imvThumb.isHidden = false
                                let height = image?.size.height
                                let width = image?.size.width
                                
                                self.width.constant = screenSize.width*0.5
                                self.height.constant = (screenSize.width*0.5*height!)/width!
                                self.alreadyShowTheImage?.show()
        })
    }
    
    
}
