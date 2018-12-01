//
//  ViewController.swift
//  CropViewControllerExample
//
//  Created by Tim Oliver on 18/11/17.
//  Copyright © 2017 Tim Oliver. All rights reserved.
//

import UIKit
import TOCropViewController
class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnChooseImage: UIButton!
    
    
    @IBAction func btnChooseImage(_ sender: Any) {
          self.pickImage(isLibrary: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
}

extension ViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cropVC = TOCropViewController.init(croppingStyle: .default, image: image )
            cropVC.delegate = self
            cropVC.aspectRatioPreset = .presetSquare
            cropVC.aspectRatioLockEnabled = true
            cropVC.resetAspectRatioEnabled = false
            cropVC.aspectRatioPickerButtonHidden = true
            picker.dismiss(animated: false) {
                self.present(cropVC, animated: false, completion: nil)
            }
        }
    }
}

extension ViewController : TOCropViewControllerDelegate {
    func pickImage(isLibrary: Bool) {

        let picker = UIImagePickerController()
        picker.sourceType = isLibrary ?  .photoLibrary : .camera
        picker.allowsEditing = false;
        picker.delegate = self;
        self.present(picker, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
 
            imgAvatar.image = image
        
        
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            
        })
}
}
