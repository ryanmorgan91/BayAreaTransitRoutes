//
//  SelectLocationsViewController.swift
//  TransitRoutes
//
//  Created by Ryan MORGAN on 3/30/19.
//  Copyright © 2019 Ryan MORGAN. All rights reserved.
//

import UIKit
import CoreLocation

extension SelectLocationsViewController: CLLocationManagerDelegate {
    // Conforms to CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {return}
        
        userLocationManager.startUpdatingLocation()
        authorizationStatus = true
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        userLocationManager.stopUpdatingLocation()
        authorizationStatus = false
    }
}

class SelectLocationsViewController: UIViewController {
    
    private let userLocationManager = CLLocationManager()
    var authorizationStatus: Bool = false
    var origin: String = ""
    var destination: String = ""
    
    @IBOutlet weak var customOriginButton: UIButton!
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    
    var customOrigin: Bool = true {
        // Bool variable is used to enable / disable current location features for the user.
        didSet {
            originTextField.isHidden = !customOrigin
            if customOrigin {
                customOriginButton.setTitle("Use Current Location", for: .normal)
            } else {
                customOriginButton.setTitle("Enter Custom Origin", for: .normal)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLocationManager.delegate = self
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        userLocationManager.distanceFilter = 5
        userLocationManager.requestWhenInUseAuthorization()
        
        getDirectionsButton.setTitle("Get Directions", for: .normal)
        getDirectionsButton.layer.cornerRadius = 12
        getDirectionsButton.backgroundColor = .blue
        getDirectionsButton.titleLabel?.textColor = .white
        
        customOriginButton.layer.cornerRadius = 12
        customOriginButton.backgroundColor = .white
        customOriginButton.setTitle("Use Current Location", for: .normal)
        originTextField.isHidden = false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Enables / disables segue based on whether origin and destination exists.
        
        guard identifier == "RoutesSegue" else {return false}
        var performSegue: Bool = false
        if destinationTextField.text != "" {
            if !customOrigin && authorizationStatus {
                if userLocationManager.location == nil {
                    let alert = UIAlertController(title: "Error", message: "Could not retrieve your location", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    present(alert, animated: true)
                } else {
                    performSegue = true
                }
            } else if originTextField.text != "" {
                performSegue = true
            }
        }
        return performSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "RoutesSegue" else {return}
        let destinationViewController = segue.destination as! RoutesTableViewController
        
        if !customOrigin && authorizationStatus {
            guard let latitude = userLocationManager.location?.coordinate.latitude else {return }
            guard let longitude = userLocationManager.location?.coordinate.longitude else {return}
            self.origin = "\(latitude),\(longitude)"
        } else {
            self.origin = originTextField.text ?? ""
        }
    
        destination = destinationTextField.text ?? ""
        destinationViewController.origin = origin
        destinationViewController.destination = destination
    }

    @IBAction func originButtonTapped(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            authorizationStatus = true
        }
        customOrigin = !customOrigin
    }

}
