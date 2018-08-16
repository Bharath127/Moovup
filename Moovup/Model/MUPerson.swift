//
//  MUPerson.swift
//  Moovup
//
//  Created by Vishwa Bharath on 14/08/18.
//  Copyright © 2018 ViswaBharathD. All rights reserved.
//

import Foundation

struct MUPersonData {
    var name: String?
    var email: String?
    var _id: String?
    var picture: String?
    
    var location:MULocation
    init(dictionary: PeopleJSON) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self._id = dictionary["_id"] as? String
        self.picture = dictionary["picture"] as? String
        self.location = MULocation(dictionary: dictionary["location"] as! PeopleJSON)
    }
    
    init(id: String?, name: String?, picture: String?, email:String?, location:MULocation){
        self._id = id
        self.name = name
        self.email = email
        self.picture = picture
        self.location = location
    }
}

struct MULocation {
    var latitude: NSNumber
    var longitude: NSNumber
 
    init(dictionary: PeopleJSON) {
        self.latitude = dictionary["latitude"] as! NSNumber
        self.longitude = dictionary["longitude"] as! NSNumber
    }
    
    init(latitude: NSNumber?, longitude: NSNumber?) {
        self.latitude = latitude!
        self.longitude = longitude!
    }
}
