//
//  MapVC.swift
//  MadMapper
//
//  Created by Casey R White on 11/4/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
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
        println("Authorization status:")
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("Authorized")
            //self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
            self.addStoredRemindersToMap()
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
            self.addReminderAnnotationWithTitle("Add Reminder", atCoordinate: touchCoordinate)
        }
    }
    
    func addStoredRemindersToMap() {
        let fetchRequest = NSFetchRequest(entityName: "Reminder")
        var error: NSError? = nil
        if let reminders = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Reminder] {
            
            for reminder in reminders {
                let coordinate = reminder.coordinate()
                self.addReminderAnnotationWithTitle("Reminder set for \(reminder.name)", atCoordinate: coordinate)
                let geoRegion = CLCircularRegion(center: coordinate, radius: reminder.radius.doubleValue, identifier: reminder.name)
                self.addOverlayForGeoRegion(geoRegion)
            }
        }
    }
    
    func reminderAdded(notification: NSNotification) {
        if let geoRegion = notification.userInfo?["region"] as? CLCircularRegion {
            self.addOverlayForGeoRegion(geoRegion)
        }
    }
    
    func addReminderAnnotationWithTitle(title: String, atCoordinate coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        self.mapView.addAnnotation(annotation)
    }
    
    func addOverlayForGeoRegion(region: CLCircularRegion) {
        let overlay = MKCircle(centerCoordinate: region.center, radius: region.radius)
        self.mapView.addOverlay(overlay)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Authorization status changed to:")
        
        switch status {
        case .Authorized:
            println("Authorized")
            //self.locationManager.startUpdatingLocation()
            self.addStoredRemindersToMap()
        default:
            println("Default")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        let regionName = region.identifier
        println("Region entered: \(regionName)")
        
        if (UIApplication.sharedApplication().applicationState == UIApplicationState.Background) {
            let notification = UILocalNotification()
            notification.alertAction = "Monitored region entered."
            notification.alertBody = "REMINDER - You have entered the following monitored region: \(regionName)."
            notification.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        let regionName = region.identifier
        println("Region exited: \(regionName)")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.last as? CLLocation {
            println("Current location: lat \(location.coordinate.latitude), long \(location.coordinate.longitude)")
            
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ReminderAnnotation")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        if annotation.title == "Add Reminder" {
            let addReminderButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
            annotationView.rightCalloutAccessoryView = addReminderButton
        }
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let addReminderVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddReminderVC") as AddReminderVC
        addReminderVC.locationManager = self.locationManager
        addReminderVC.selectedAnnotationView = view
        self.presentViewController(addReminderVC, animated: true, completion: nil)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.blueColor().colorWithAlphaComponent(0.2)
        return renderer
    }
}
