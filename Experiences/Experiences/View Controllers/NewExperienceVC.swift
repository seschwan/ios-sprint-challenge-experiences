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

class NewExperienceVC: UIViewController, RecorderDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    
    var originalImage: UIImage? {
        didSet {
            updateImage()
            //imageView.image = self.originalImage
        }
    }
    
    var experienceController: ExperienceController?
    
    // Audio
    lazy private var recorder = Recorder()
    var audioURL: URL?
    
    // Image
    private let filter = CIFilter(name: "CIColorControls")!
    private let context = CIContext(options: nil)
    var imageData: Data?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordBtn.layer.cornerRadius = 6
        recorder.delegate = self
        titleTextField.delegate = self
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
    
    
    private func image(byFiltering image: UIImage) -> UIImage? {
        // UIImage > CGImage > CIImage
        guard let cgImage = image.cgImage else { return image }
        let ciImage = CIImage(cgImage: cgImage)
        
        // Set Values on Filter
        filter.setValue(ciImage, forKey: "inputImage")
        filter.setValue(-0.5, forKey: "inputSaturation")
        filter.setValue(0.1, forKey: "inputBrightness")
        filter.setValue(1, forKey: "inputContrast")
        
        // CIImage > CGImage > UIImage
        guard let outputCIImage = filter.outputImage else { return image }
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return image }
        
        let filteredImage = UIImage(cgImage: outputCGImage)
        
        imageData = filteredImage.jpegData(compressionQuality: 1)
        
        return filteredImage
    }
    
    // Updating the imageView.
    private func updateImage() {
        if let filteredImage = originalImage {
            imageView.image = self.image(byFiltering: filteredImage)
        } else {
            imageView.image = nil
        }
    }
    
    
    // MARK: - Actions
    
    // Image
    @IBAction func addImageBtnPressed(_ sender: UIButton) {
        self.presentImagePickerController()
        
    }
    
    // Audio
    @IBAction func recordBtnPressed(_ sender: UIButton) {
        recorder.toggleRecording()
        audioURL = recorder.currentFile
        //recorderDidChangeState(recorder)
        
    }
    
    func recorderDidChangeState(_ recorder: Recorder) {
        if recorder.isRecording {
            recordBtn.setTitle("Stop", for: .normal)
        } else {
            recordBtn.setTitle("Record", for: .normal)
        }
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCameraVC" {
            guard let destinationVC = segue.destination as? CameraVC else { return }
            
            destinationVC.experienceController = experienceController
            destinationVC.audioURL = audioURL
            destinationVC.imageData = imageData
            destinationVC.postTitle = titleTextField.text
            
        }
    }
}

// MARK: - PickerControlDelegate
extension NewExperienceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.originalImage = image
            //imageView.image = image
            addImageBtn.isHidden = true
            addImageBtn.isEnabled = false
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextFieldDelegate
extension NewExperienceVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}
