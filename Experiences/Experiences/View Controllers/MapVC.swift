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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    // MARK: - Actions
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        mapView.mapType = MKMapType(rawValue: UInt(sender.selectedSegmentIndex)) ?? .standard
    }
    
    
}

