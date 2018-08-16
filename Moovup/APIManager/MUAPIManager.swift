//
//  MUAPIManager.swift
//  Moovup
//
//  Created by Vishwa Bharath on 13/08/18.
//  Copyright © 2018 ViswaBharathD. All rights reserved.
//

import Foundation
typealias PeopleJSON = [String: Any]

class MUAPIManager: NSObject {
    
    private let session: URLSession!
    let baseURL = "http://www.json-generator.com"
    static let sharedInstance = MUAPIManager(session:URLSession.shared)
    static let methodPath = "/api/json/get"
    static let endpoint = "/cfdlYqzrfS"
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getSamplePeopleData( onSuccess: @escaping([PeopleJSON]?) -> Void, onFailure: @escaping(Error) -> Void){
        
        let url : String = baseURL + MUAPIManager.methodPath + MUAPIManager.endpoint
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if error != nil {
                print("Error: \(String(describing: error))")
                onFailure(error!)
            } else {
                guard let unwrappedDAta = data else { print("Error unwrapping data"); return }
                
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: unwrappedDAta, options: [])
                    let successdict = responseJSON as! [PeopleJSON]
                      onSuccess(successdict)
                } catch {
                    print(error)
                    onFailure(error)
                }
            }
        })
     
        task.resume()
    }
}
