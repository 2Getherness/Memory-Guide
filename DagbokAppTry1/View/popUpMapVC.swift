//
//  popUpMapVC.swift
//  DagbokAppTry1
//
//  Created by imran khan on 2018-02-13.
//  Copyright © 2018 imran khan. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class popUpMapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private var dbRef: DatabaseReference!
    private var dbHandler: DatabaseHandle!
    private var myLocation: CLLocation = CLLocation()
    
    var addressID: String = ""
    var noteID : String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var transportType: MKDirectionsTransportType = MKDirectionsTransportType.automobile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view?.backgroundColor = UIColor(white: 1, alpha: 0.75)
        mapView.layer.cornerRadius = 10
        mapView.layer.borderWidth = 2
        mapView.layer.borderColor = UIColor.brown.cgColor
        mapView.layer.masksToBounds = true
        
        CLGeocoder().geocodeAddressString(addressID, completionHandler: {(placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let annotation = MKPointAnnotation()
                
                
                if let restLocation = placemark.location {
                    annotation.coordinate = restLocation.coordinate
                    
                    self.mapView.addAnnotation(annotation)
                    let span = MKCoordinateSpanMake(0.005, 0.005)
                    let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        })
    }
    // Exiting from popUp and returning to Detail View
    @IBAction func exitFromPopUp (segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func closeMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
