//
//  ExperienceController.swift
//  Experiences
//
//  Created by Seschwan on 9/28/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreLocation

class ExperienceController {
    var experiences = [Experience]()
    
    func createNewExperience(userLocation: CLLocationCoordinate2D, title: String, image: Data, audio: URL, video: URL) {
        let experience = Experience(coordinate: userLocation, title: title, image: image, audio: audio, video: video)
        
        experiences.append(experience)
    }
}
