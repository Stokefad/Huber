//
//  MapViewVC.swift
//  huber
//
//  Created by Igor-Macbook Pro on 13/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseFirestore
import FirebaseAuth

class MapViewVC : UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var leftBar: UIView!
    let manager = CLLocationManager()

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var leftBarConstraing: NSLayoutConstraint!
    
    var users : [User] = [User]()
    
    var currentUser : String = String()
    var otherUsers : [User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersOnMap()
        
        leftBarConstraing.constant = -240
        
        let button = UIButton(frame: CGRect(x: 10, y: 50, width: 50, height: 50))
        button.backgroundColor = UIColor.red
        button.addTarget(self, action: #selector(sideBarButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(sideBarSwipe(sender:)))
        leftSwipe.direction = .left
        leftBar.addGestureRecognizer(leftSwipe)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: manager.location?.coordinate.latitude ?? 30, longitude: manager.location?.coordinate.longitude ?? 30), latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if currentUser != "" {
            loginButton.titleLabel?.text = "LogOut"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            mapView.centerCoordinate.latitude = location.coordinate.latitude
            mapView.centerCoordinate.longitude = location.coordinate.longitude
            if currentUser != "" {
                
                let user = User()
                user.email = currentUser
                user.latitude = location.coordinate.latitude
                user.longtitude = location.coordinate.longitude
                saveUserCoords(user: user)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error \(error)")
    }
    
    
    @IBAction func sideBarButtonPressed(sender : UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.leftBarConstraing.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func sideBarSwipe(sender : UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.leftBarConstraing.constant = -240
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if currentUser != "" {
            do {
                try Auth.auth().signOut()
            }
            catch {
                print("Problems with sign out occured \(error)")
            }
        }
        else {
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
    }
    
    @IBAction func accountButtonPressed(_ sender: UIButton) {
        
    }
    
    
    private func saveUserCoords(user : User) {
        let db = Firestore.firestore()
        
        db.collection("users").document(user.email).setData([
            "email" : user.email,
            "longtitude" : user.longtitude,
            "latitude" : user.latitude
        ], merge: true) { (error) in
            if error != nil {
                print("Error with saving occured \(String(describing: error))")
            }
        }
    }
    
    private func retrieveUsersCoords() {
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (snapshot, error) in
            if let dbSnap = snapshot {
                for item in dbSnap.documents {
                    
                    let user = User()
                    user.email = item["email"] as! String
                    user.latitude = item["latitude"] as! Double
                    user.longtitude = item["longtitude"] as! Double
                    user.name = item["name"] as! String
                    
                    self.users.append(user)
                }
            }
        }
    }
    
    private func usersOnMap() {
        let annotation = Annotation(name: "Hey", car: "Lambo", coords: CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!))
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView.glyphText = "Lambo"
        
        mapView.addAnnotation(annotation)
    }
}
