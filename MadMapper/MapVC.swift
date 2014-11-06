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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reminderAdded:", name: "ReminderAdded", object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        self.mapView.addGestureRecognizer(longPress)

        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        self.handleLocationManagerAuthorization()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func reminderAdded(notification: NSNotification) {
        if let geoRegion = notification.userInfo?["region"] as? CLCircularRegion {
            let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
            self.mapView.addOverlay(overlay)
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
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        let regionName = region.identifier
        println("Region entered: \(regionName)")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        let regionName = region.identifier
        println("Region exited: \(regionName)")
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
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let addReminderVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddReminderVC") as AddReminderVC
        addReminderVC.locationManager = self.locationManager
        addReminderVC.selectedAnnotation = view.annotation
        self.presentViewController(addReminderVC, animated: true, completion: nil)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
        return renderer
    }
}
