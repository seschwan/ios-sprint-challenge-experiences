//
//  NewExperienceVC.swift
//  Experiences
//
//  Created by Seschwan on 9/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class NewExperienceVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    var originalImage: UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        recordBtn.layer.cornerRadius = 6
        
        
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { NSLog("The photo library isn't available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    

    // MARK: - Actions
    
    @IBAction func addImageBtnPressed(_ sender: UIButton) {
        self.presentImagePickerController()
    
    }
    
    @IBAction func recordBtnPressed(_ sender: UIButton) {
        
    }
}

extension NewExperienceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //self.originalImage = image
            imageView.image = image
            addImageBtn.isHidden = true
            addImageBtn.isEnabled = false
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
