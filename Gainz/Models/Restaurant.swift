//
//  Restaurant.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/25/20.
//

import Foundation

///the object for a restaurant
struct Restaurant: Codable {
    
    var restaurant_name:String?
    var restaurant_phone: String?
    var restaurant_website:String?
    var address:String?
    var geo: [String:Double]?
    var hours:String?
    
    //failable initializer
    init?(dataDict:[String:Any]) {
        
        let name = dataDict["restaurant_name"] as? String
        self.restaurant_name = name
        let phone = dataDict["restaurant_phone"] as? String
        self.restaurant_phone = phone
        let restaurant_website = dataDict["restaurant_website"] as? String
        self.restaurant_website = restaurant_website
        let addressDict = dataDict["address"] as? [String:String]
        let address = addressDict?["formatted"]
        self.address = address
        let geo = dataDict["geo"] as? [String:Double]
        self.geo = geo
        let hours = dataDict["hours"] as? String
        self.hours = hours
        
        guard restaurant_name != nil && restaurant_phone != nil && self.address != nil && geo != nil else {
            return nil
        }
    }

}
