//
//  MapVC.swift
//  Experiences
//
//  Created by Seschwan on 9/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSegmentPicker: UISegmentedControl!
    
    let locationHelper = LocationHelper()
    
    let experienceController = ExperienceController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        locationHelper.requestAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        let experiences = experienceController.experiences
        mapView.addAnnotations(experiences)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToNewExperience" {
            let destVC = segue.destination as! NewExperienceVC
            destVC.experienceController = experienceController
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ToNewExperience", sender: sender)
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        mapView.mapType = MKMapType(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
    
    
    
    
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        annotationView.glyphTintColor = .red
        annotationView.canShowCallout = true
        
        return annotationView
    }
}

