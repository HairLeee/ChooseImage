//
//  PopupView.swift
//  QClub
//
//  Created by SMR on 9/30/17.
//  Copyright © 2017 Dream. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum AnimationType: Int {
    case alpha = 1
    case upDown = 2
}

class PopupView: UIView {
    var backgroundView : UIView?
    var popupFrame: CGRect?
    var animationType = AnimationType.alpha
    var isHandleKeyboard = false
    var isEnableTouchOutsideToDissmiss = true
    
    func show(){
        
        //BackgroundView
        backgroundView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        backgroundView?.isUserInteractionEnabled = true
        backgroundView?.backgroundColor = UIColor.black
        backgroundView?.alpha = 0.0
        
        if isEnableTouchOutsideToDissmiss {
            let gesture = UITapGestureRecognizer.init(target: self, action: #selector(hide))
            backgroundView?.addGestureRecognizer(gesture)
        }
        
        //Self Frame
        switch animationType {
        case .alpha:
            if let frame = popupFrame {
                self.frame = frame
            }
            self.alpha = 0
        case .upDown:
            if var frame = popupFrame {
                frame.origin.y += SCREEN_HEIGHT
                self.frame = frame
            }
        }

//        IQKeyboardManager.shared.enable = false
        if isHandleKeyboard {
            addKeyboardNotification()
        }
        
        //Add subview
        UIApplication.shared.keyWindow?.addSubview(backgroundView!)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        //Animation
        UIView.animate(withDuration: 0.3) {
            switch self.animationType {
            case .alpha:
                self.backgroundView?.alpha = 0.7
                self.alpha = 1
            case .upDown:
                self.backgroundView?.alpha = 0.7
                if let frame = self.popupFrame {
                    self.frame = frame
                }
            }
        }
    }

    @objc func hide() {
//        IQKeyboardManager.shared.enable = true
        UIView.animate(withDuration: 0.3, animations: {
            switch self.animationType {
            case .alpha:
                self.backgroundView?.alpha = 0.0
                self.alpha = 0.0
            case .upDown:
                self.backgroundView?.alpha = 0.0
                if var frame = self.popupFrame {
                    frame.origin.y += SCREEN_HEIGHT
                    self.frame = frame
                }
            }
        }) { (finished) in
            self.backgroundView?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustForKeyboard(notification: notification, isShow: true)
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(notification: notification, isShow: false)
    }
    
    func adjustForKeyboard(notification: NSNotification, isShow: Bool) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.frame.origin.y = (popupFrame?.origin.y)!
            } else {
                self.frame.origin.y = (popupFrame?.origin.y)! - (endFrame?.size.height)!/2
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0.3),
                           options: animationCurve,
                           animations: { self.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

