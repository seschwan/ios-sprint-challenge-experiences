//
//  CameraVC.swift
//  Experiences
//
//  Created by Seschwan on 9/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cameraPreviewView: CameraPreviewView!
    @IBOutlet weak var videoRecordBtn: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    // Variables
    var captureSession: AVCaptureSession!
    var recordOutput: AVCaptureMovieFileOutput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButtonSetup()
        captureSessionCreation()
        
    }
    func recordButtonSetup() {
           videoRecordBtn.layer.cornerRadius = videoRecordBtn.frame.height / 2
           videoRecordBtn.layer.cornerRadius = videoRecordBtn.frame.width / 2
           videoRecordBtn.layer.borderColor = UIColor.red.cgColor
           videoRecordBtn.layer.borderWidth = 1.0
       }
    
    func captureSessionCreation() {
        let captureSession = AVCaptureSession()
        // Creating an input.
        let videoDevice = self.bestCamera()
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput) else {
                fatalError()
        }
        captureSession.addInput(videoDeviceInput)
        
        let fileOutput = AVCaptureMovieFileOutput()
        guard captureSession.canAddOutput(fileOutput) else {
            fatalError()
        }
        
        captureSession.addOutput(fileOutput)
        self.recordOutput = fileOutput
        
        captureSession.sessionPreset = .hd1920x1080
        captureSession.commitConfiguration()
        
        self.captureSession = captureSession
        cameraPreviewView.videoPreviewLayer.session = captureSession
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    // Finding the best camera.
    private func bestCamera() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device")
        }
    }
    
    private func newRecordingURL() -> URL {
        let fm = FileManager.default
        let documents = try! fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        return
            documents.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
    }
    
    private func updateView() {
        guard isViewLoaded else { return }
        let isRecording = recordOutput?.isRecording ?? false
        
        if isRecording {
            videoRecordBtn.setImage(nil, for: .normal)
            videoRecordBtn.tintColor = .red
            videoRecordBtn.setTitle("Stop", for: .normal)
        } else {
            videoRecordBtn.setImage(UIImage(systemName: "video"), for: .normal)
            videoRecordBtn.setTitle(nil, for: .normal)
        }
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func recordBtnPressed(_ sender: UIButton) {
        // TODO Change the button when recording.
        if recordOutput.isRecording {
            recordOutput.stopRecording()
        } else {
            recordOutput.startRecording(to: self.newRecordingURL(), recordingDelegate: self)
        }
    }
    
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
extension CameraVC: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        defer { self.updateView() }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status != .authorized {
                NSLog("Please give Video Recorder access to your photo library")
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            }) { (success, error) in
                if let error = error {
                    NSLog("Error Saving video to photo library: \(error)")
                }
                
                if success {
                    DispatchQueue.main.async {
                        self.presentSuccessAlert()
                    }
                }
            }
        }
    }
    
    private func presentSuccessAlert() {
        let alert = UIAlertController(title: "Video Saved!", message: "Your video was successfully saved to your photo library", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Photos", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string: "photos-redirect://")!,
                                      options: [:], completionHandler: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

