//
//  RepresentativeController.swift
//  Representative
//
//  Created by Jackson Tubbs on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class RepresentativeController {
    
    static var baseURL = URL(string: "http://whoismyrepresentative.com/getall_reps_bystate.php")
    
    static func searchRepresentatives(forState state: String, completion: @escaping ([Representative]?) -> Void) {
        
        guard let baseURL = baseURL else {return}
        
        // Creates a Query Item for the request
        let stateQueryItem = URLQueryItem(name: "state", value: state)
        let getDataAsJSONQueryItem = URLQueryItem(name: "output", value: "json")
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [stateQueryItem,getDataAsJSONQueryItem]
        
        guard let requestURL = components?.url else {completion(nil); return}
        print(requestURL.absoluteString)
        
        // Starts the request with our url aboce
        URLSession.shared.dataTask(with: requestURL) { (data, urlResponse, error) in
            
            // Error handling
            if let error = error {
                print("Error at \(#function) \(error) \(error.localizedDescription) \n Response Code: \(urlResponse.debugDescription)")
                completion(nil)
                return
            }
            
            // Check to make sure that the data is there
            guard let data = data,
                // Convert the data to .utf8
                let temporaryData = String(data: data, encoding: .ascii),
                let formattedData = temporaryData.data(using: .utf8) else {completion(nil); return}
            
            let decoder = JSONDecoder()
            
            do {
                // Try and decode the data into an array of dictionaries
                let representatives = try decoder.decode([String: [Representative]].self, from: formattedData)
                let arrayOfReps = representatives["results"]
                
                if let arrayOfReps = arrayOfReps {
                    completion(arrayOfReps)
                }
                
            } catch {
                print("Error at \(#function) \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            
        }.resume()
    }
    
}
