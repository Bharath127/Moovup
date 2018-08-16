//
//  MUDataStore.swift
//  Moovup
//
//  Created by Vishwa Bharath on 14/08/18.
//  Copyright © 2018 ViswaBharathD. All rights reserved.
//

import Foundation
import SQLite3

final class MUDataStore {

    static let sharedInstance = MUDataStore()
    fileprivate init() {}
    var db: OpaquePointer?
    var peopleData: [MUPersonData] = []
 
    func getPeopleData(completion: @escaping () -> Void) {
        
        MUAPIManager.sharedInstance.getSamplePeopleData(onSuccess: { (peoplejson) in
            let feed = peoplejson
            print(feed ?? "")
            if let results = feed
            {
                self.peopleData = Array()
                for dict in results {
                    let facilitiesName = MUPersonData(dictionary: dict)
                    self.peopleData.append(facilitiesName)
                }
            }
            completion()

         }) { (error) in
            completion()
         }
        }
    }
