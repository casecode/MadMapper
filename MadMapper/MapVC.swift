//
//  MapVC.swift
//  MadMapper
//
//  Created by Casey R White on 11/4/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        self.mapView.addGestureRecognizer(longPress)

        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        self.handleLocationManagerAuthorization()
    }

    func handleLocationManagerAuthorization() {
        println("Authorization Status:")
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("Authorized")
            //self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        case .NotDetermined:
            println("Not Determined")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("Restricted")
        case .Denied:
            println("Denied")
        default:
            println("Default")
        }
    }
    
    func didLongPressMap(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(self.mapView)
            let touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            let annontation = MKPointAnnotation()
            annontation.coordinate = touchCoordinate
            annontation.title = "Add Reminder"
            self.mapView.addAnnotation(annontation)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Authorization Status Changed To:")
        
        switch status {
        case .Authorized:
            println("Authorized")
            //self.locationManager.startUpdatingLocation()
        default:
            println("Default")
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AddReminderAnnotation")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        let addReminderButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addReminderButton
        return annotationView
    }
}
