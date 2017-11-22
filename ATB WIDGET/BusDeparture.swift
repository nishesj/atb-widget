//
//  BusDeparture.swift
//  ATB WIDGET
//
//  Created by Nishes Joshi on 12/11/2017.
//  Copyright © 2017 Nishes Joshi. All rights reserved.
//

import Foundation


struct Departure : Codable {
    var line: String?
    var registeredDepartureTime: String?
    var scheduledDepartureTime: String?
    var destination: String?
    var isRealtimeData = false
}

struct DepartureResponse : Codable {
    var busStop: BusStop?
    var url: String
    var isGoingTowardsCentrum: BooleanLiteralType
    var departures: [Departure]
}


func getBusDeparture( for busstop: BusStop, completion: ((Result<DepartureResponse>) -> Void)?) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "atbapi.tar.io"
    urlComponents.path = "/api/v1/departures/" + String(busstop.nodeId)
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
    print (urlComponents.url)
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        DispatchQueue.main.async {
            guard responseError == nil else {
                completion?(.failure(responseError!))
                return
            }
            
            guard let jsonData = responseData else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
                return
            }
            
            // Now we have jsonData, Data representation of the JSON returned to us
            // from our URLRequest...
            
            // Create an instance of JSONDecoder to decode the JSON data to our
            // Codable struct
            let decoder = JSONDecoder()
            
            do {
                var departures = try decoder.decode(DepartureResponse.self, from: jsonData)
                departures.busStop = busstop
                completion?(.success(departures))
            } catch {
                completion?(.failure(error))
            }
        }
    }
    
    task.resume()
}
