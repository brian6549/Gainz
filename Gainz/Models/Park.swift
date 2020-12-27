//
//  Park.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/26/20.
//

import Foundation

struct Park {
    var name: String?
    var location:[String:Double]?
    
    init?(dataDict: [String:Any]) {
        
        let name = dataDict["name"] as? String
        self.name = name
        
        let geometry = dataDict["geometry"] as? [String:Any]
        let location = geometry?["location"] as? [String:Double]
        self.location = location
        
        guard self.name != nil || self.location != nil else {
            return nil
        }
        
    }
    
}
