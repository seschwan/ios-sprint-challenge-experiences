//
//  Experience.swift
//  Experiences
//
//  Created by Seschwan on 9/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import MapKit

struct Experience {
    let userLocation: CLLocationCoordinate2D
    var title: String
    let image: URL
    let audio: URL
    let video: URL
    
    init(userLocation: CLLocationCoordinate2D, title: String, image: URL, audio: URL, video: URL) {
        (self.userLocation,
         self.title,
         self.image,
         self.audio,
         self.video) = (userLocation,
                        title,
                        image,
                        audio,
                        video)
    }
}
