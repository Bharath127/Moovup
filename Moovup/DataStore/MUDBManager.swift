//
//  MUDBManager.swift
//  Moovup
//
//  Created by Vishwa Bharath on 15/08/18.
//  Copyright © 2018 ViswaBharathD. All rights reserved.
//

import Foundation
import SQLite3

struct MUDBManager {
    
    var db: OpaquePointer?
    static let sharedInstance = MUDBManager()
   
    fileprivate init() {
        checkAndCreateDB()
    }
    
    // ** check And Create database

    mutating func checkAndCreateDB () {
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MUPeopleDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS People (id INTEGER PRIMARY KEY AUTOINCREMENT, personEmail TEXT, latitude DOUBLE, longitude DOUBLE, personName TEXT, personID TEXT, personpicture TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }

    // ** get People data from database

     func getPeople(onSuccess: @escaping ([MUPersonData]) -> Void) {
 
        let queryString = "SELECT * FROM People"
        var peopleList:Array<MUPersonData> = []
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){

            let email        = String(cString: sqlite3_column_text(stmt, 1))
            let latitude     = sqlite3_column_double(stmt, 2);
            let longitude    = sqlite3_column_double(stmt, 3);
            let name         = String(cString: sqlite3_column_text(stmt, 4))
            let personID     = String(cString: sqlite3_column_text(stmt, 5))
            let picture      = String(cString: sqlite3_column_text(stmt, 6))
            let location     = MULocation(latitude: NSNumber(value:latitude), longitude: NSNumber(value:longitude))
            peopleList.append(MUPersonData(id: personID, name: name, picture: picture, email: email, location: location))
        }
        
        onSuccess(peopleList)

    }
    
    // ** check if Record already Exists

    func checkRecordExists(personId:String) -> Bool {
        
        let pid = personId

        let queryString = String(format: "SELECT * FROM People where personID = '%@'", pid)
                                 
        var stmt:OpaquePointer?
        var isexist:Bool = false
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{ 
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return  isexist
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let personSavedID = String(cString: sqlite3_column_text(stmt, 5))
            if personSavedID == personId {
                isexist = true
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("failure inserting people: \(errmsg)")
                 }
                return isexist
            }
         }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting people: \(errmsg)")
        }

        return isexist
    }
    
    // ** Insert People data
    
    func savePeople(people:Array<MUPersonData>) {
        
        var stmt: OpaquePointer?
        for person in people {
            
             let personID = person._id
             let exists = checkRecordExists(personId: personID!)
           
            if !exists
            {
                
                 let queryString = "INSERT INTO People (personEmail,latitude,longitude,personName,personID,personpicture) VALUES (?,?,?,?,?,?)"
                if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) == SQLITE_OK {
 
                    if sqlite3_bind_text(stmt, 1, (person.email! as NSString).utf8String, -1, nil) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure binding name: \(errmsg)")
                        return
                    }
 
                    if sqlite3_bind_double(stmt, 2, Double(truncating: person.location.latitude)) != SQLITE_OK {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure binding latitude: \(errmsg)")
                        return
                    }
                    
                    if sqlite3_bind_double(stmt, 3, Double(truncating: person.location.longitude)) != SQLITE_OK {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure binding longitude: \(errmsg)")
                        return
                    }
                    
                    if sqlite3_bind_text(stmt, 4, (person.name! as NSString).utf8String, -1, nil) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure binding email: \(errmsg)")
                        return
                    }
                    
                    if sqlite3_bind_text(stmt, 5, (personID! as NSString).utf8String, -1, nil) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure binding _id: \(errmsg)")
                        return
                    }
                    
                    if sqlite3_bind_text(stmt, 6, (person.picture! as NSString).utf8String, -1, nil) != SQLITE_OK{
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failur binding picture: \(errmsg)")
                        return
                     }
                    
                    if sqlite3_step(stmt) != SQLITE_DONE {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("failure inserting people: \(errmsg)")
                        return
                    }
                    
                 }else{
                    
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("error preparing insert: \(errmsg)")
                    return
                 }
             }
 
        }
     }
    
}
