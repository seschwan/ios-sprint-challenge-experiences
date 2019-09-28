//
//  CameraPreviewView.swift
//  Experiences
//
//  Created by Seschwan on 9/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // Convenience Wrapper
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

}
