//
//  JoinPhotoPopup.swift
//  QClub
//
//  Created by SMR on 9/30/17.
//  Copyright © 2017 Dream. All rights reserved.
//

import UIKit

class JoinPhotoPopup: PopupView {
    
    var selectFromAlbum: (() -> ())?
    var takeAPhoto: (() -> ())?
    var deleteImage: (() -> ())?
    
    class func instanceFromNib() -> JoinPhotoPopup {
        let joinView = UINib(nibName: "JoinPhotoPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! JoinPhotoPopup
        joinView.popupFrame = CGRect.init(x: 20, y: (SCREEN_HEIGHT - 150)/2 , width: SCREEN_WIDTH - 40, height: 150)
        return joinView
    }

    @IBAction func deleteImage(_ sender: Any) {
        self.hide()
        if let deleteAction = self.deleteImage {
            deleteAction()
        }
    }
    
    @IBAction func selectFromAlbumTUI(_ sender: Any) {
        self.hide()
        if let selecAlbumAction = self.selectFromAlbum {
            selecAlbumAction()
        }
    }
    
    @IBAction func takeAPhotoTUI(_ sender: Any) {
        self.hide()
        if let takeAPhotoAction = self.takeAPhoto {
            takeAPhotoAction()
        }
    }
}
