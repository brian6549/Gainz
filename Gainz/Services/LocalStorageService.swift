//
//  LocalStorageService.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/19/20.
//

import Foundation

class LocalStorageService {
    
    ///save this info to local storage
    static func saveMassHeightBMI(mass: Double, height: Double, BMI: Double) {
        
        let userDefaults = UserDefaults.standard
        
        if var info = loadMassHeightBMI()  {
            info[0] = mass
            info[1] = height
            info[2] = BMI
            
            userDefaults.setValue(info, forKey: Names.userDefaultsNames.massWeightBMI)
            
            return
        }
        
        let info = [mass, height, BMI]
        
        userDefaults.setValue(info, forKey: Names.userDefaultsNames.massWeightBMI)
        
        
    }
    
    ///load this info from local storage
    static func loadMassHeightBMI() -> [Double]? {
        
        let userDefaults = UserDefaults.standard
        
       return userDefaults.value(forKey: Names.userDefaultsNames.massWeightBMI) as? [Double]
        
    }
    
    //helps for setup in the app delegate
   ///check if this is the initial setup
    static func isSettingUpForFirstTime() -> Bool {
        
        //if it's the initial setup then this value would be nil
        if let _ = loadMassHeightBMI() {
            return false
        }
        
        return true
        
    }
    
}
