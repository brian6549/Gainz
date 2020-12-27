//
//  Networking.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/25/20.
//

import Foundation
import CoreLocation


class Networking {
    
    static func getRestaurants(location: CLLocation,completion: @escaping ([Restaurant]?) -> Void) {
        
        let headers = [
            "x-api-key": "bcfc229f8f26b4c7dde0ab3c50198dbc",
            "x-rapidapi-key": "5572612bd3msh5793d9769f17ff2p147d87jsn139c2347a4e8",
            "x-rapidapi-host": "us-restaurant-menus.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://us-restaurant-menus.p.rapidapi.com/v2/restaurants/distance?lat=\(location.coordinate.latitude)&minutes=10&mode=driving&lon=\(location.coordinate.longitude)&size=20&page=1&fullmenu=false")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
               // let httpResponse = response as? HTTPURLResponse
               // print(httpResponse)
                
                guard let JsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {
                    return
                }
                
                
            
                
              //  let decoded = try? JSONDecoder().decode(Restaurant.self, from: data!)
                
               // print(decoded)
                
             //   print(JsonData)
                
                if  let theArray = JsonData["data"] as? [Any] {
                    
                    var restaurants = [Restaurant]()
                    for i in 0..<theArray.count {
                        if let jsonData = theArray[i] as? [String:Any] {
                            
                            
                            
                            if let restaurant = Restaurant(dataDict: jsonData) {
                                restaurants.append(restaurant)
                            } //will send to a completion closure
                        }//will put this in the restaurant initializer
                    }
                   completion(restaurants)
                }
                
                print(JsonData["data"] as! [Any]) //turn into an array
                //this is just like firebase
                
                // this will do for now
                
                //to be put in restaurant initializer
                
          /*  let name = jsonString?["restaurant_name"] as? String
                 let phone = jsonString?["restaurant_phone"] as? String
                 let restaurant_website = jsonString?["restaurant_website"] as? String
                 let addressDict = jsonString?["address"] as? [String:String]
                 let address = addressDict?["formatted"]
                 let geo = jsonString?["geo"] as? [String:Double] */
                
                
         //       let testObject = try JSONDecoder().decode(Restaurant.self, from: theArray[0])
                //object
                
               
                
             //   let jsonData = jsonString.data(using: .utf8)!
            //    let user = try! JSONDecoder().decode(Restaurant.self, from: jsonData)
             //   print(user.last_name)
            }
        })

        dataTask.resume()
    }
    
    static func getParks(location: CLLocation,completion: @escaping ([Park]?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=parks&location=\(location.coordinate.latitude),\(location.coordinate.longitude)&radius=5000&key=AIzaSyBTFmszFHSDmgUZNua-r6wwISTr3V16ruY"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
        
                guard let JsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {
                    return
                }
                
                print(JsonData)
                
                if let theArray = JsonData["results"] as? [[String:Any]] {
                    var parks = [Park]()
                    for park in theArray {
                       // print(park["name"] as! String)
                        if let park = Park(dataDict: park) {
                            parks.append(park)
                        }
                    }
                    
                    //send to completion closure here
                    completion(parks)
                }
                
                //only need the park name and location
                
            }
        })

        dataTask.resume()
    }
    
    static func getGyms(location: CLLocation ,completion: @escaping ([Gym]?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=gyms&location=\(location.coordinate.latitude),\(location.coordinate.longitude)&radius=5000&key=AIzaSyBTFmszFHSDmgUZNua-r6wwISTr3V16ruY"
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
        
                guard let JsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {
                    return
                }
                
                print(JsonData)
                
                if let theArray = JsonData["results"] as? [[String:Any]] {
                    var gyms = [Gym]()
                    for gym in theArray {
                       // print(park["name"] as! String)
                        if let gym = Gym(dataDict: gym) {
                            gyms.append(gym)
                        }
                    }
                    
                    //send to completion closure here
                    completion(gyms)
                }
                
                //only need the park name and location
                
            }
        })

        dataTask.resume()
    }
        
}
