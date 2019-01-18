//
//  Annotation.swift
//  huber
//
//  Created by Igor-Macbook Pro on 17/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import MapKit

class Annotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name : String = String()
    var car : String = String()
    
    
    init(name : String, car : String, coords : CLLocationCoordinate2D) {
        self.coordinate = coords
        self.name = name
        self.car = car
        super.init()
    }
}
