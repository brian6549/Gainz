//
//  ViewController.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/17/20.
//

import UIKit

//need the BMI formula  + this is the inital screen so I will need a flag for it.

//enetr your height label should be a picker

//initial view controller
class ViewController: UIViewController {
    
    
    @IBOutlet weak var weightTextField: UITextField!
    
    
  
    @IBOutlet weak var heightTextField: UITextField!
    
    
    @IBOutlet weak var BMILabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var mass: Double?
    var height: Double?
    
    var BMI:Double  {
        
        get {
            
            guard mass != nil && height != nil else {
                return 0.0
            }
            
            if mass == 0 || height == 0 {
                return 0.0
            }
            //BMI
            return mass! / (height! * height!)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueButton.layer.cornerRadius = 10
        
        //dismiss keyboard by tapping anywhere
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        
        view.addGestureRecognizer(tapGestureRec)
        
    }
    
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        guard !(weightTextField.text!.isEmpty) || !(heightTextField.text!.isEmpty) else  {
            return
        }
        
         mass = Double(weightTextField.text!)! * 0.453592
        
        height = Double(heightTextField.text!)! * 0.0254 // convert to meters
        
        //need to save this stuff to local storage
    
        //continue to the next screen
        
        //will pass BMI to the next screen
        
            //need enumeration for the different categories
        
        //don't waste time, after this just go to the initial screen
        
    }
    
   @objc func dismissKeyBoard() {
    self.view.endEditing(true)
    
   }
    
}
        


