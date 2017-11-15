//
//  BusStop.swift
//  ATB WIDGET
//
//  Created by Nishes Joshi on 12/11/2017.
//  Copyright © 2017 Nishes Joshi. All rights reserved.
//
import Cocoa

struct BusStop : Codable {
    var nodeId: Int
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    var mobileCode: String = ""
    var mobileName: String
    var url: String
    var stopId: Int
    var description: String
}

struct BusStopResult: Codable {
    var stops: [BusStop]
}


enum Result<Value> {
    case success(Value)
    case failure(Error)
}

func getBusStops( completion: ((Result<[BusStop]>) -> Void)?) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "atbapi.tar.io"
    urlComponents.path = "/api/v1/busstops"
    guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
    
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
                let stops = try decoder.decode(BusStopResult.self, from: jsonData)
                completion?(.success(stops.stops))
            } catch {
                completion?(.failure(error))
            }
        }
    }
    
    task.resume()
}
