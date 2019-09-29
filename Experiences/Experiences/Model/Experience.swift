//
//  Experience.swift
//  Experiences
//
//  Created by Seschwan on 9/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    let image: Data
    let audio: URL
    let video: URL
    
    init(coordinate: CLLocationCoordinate2D, title: String, image: Data, audio: URL, video: URL) {
        (self.coordinate,
         self.title,
         self.image,
         self.audio,
         self.video) = (coordinate,
                        title,
                        image,
                        audio,
                        video)
    }
}
