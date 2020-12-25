//
//  SettingsViewController.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/23/20.
//

import UIKit

class SettingsViewController: ViewController {
    
    var updateInfoDelegate:updateOnScreenInfoDelegate?
    
    var weight:Double {
        
        if let mass = LocalStorageService.loadMassHeightBMI()?[0] {
            return mass / 0.453592
        }
        
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         
         //get height
         
         if let height = LocalStorageService.loadMassHeightBMI()?[1] {
             self.height = height / 0.0254
         } else {
             self.height = 0
         }
         
         weightTextField.text = "\(weight)"
         
         heightTextField.text = "\(height!)"
         
     }
    
    
    @IBAction override func continueButtonTapped(_ sender: Any) {
        
        super.continueButtonTapped(self)
        
        self.dismiss(animated: true, completion: nil)
        
        updateInfoDelegate?.updateInfo()
        
    }
    
 
    
}
