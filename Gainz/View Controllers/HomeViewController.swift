//
//  HomeViewController.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/19/20.
//

import UIKit

//will eventually make into a profile but this works for now

protocol updateOnScreenInfoDelegate {
    func updateInfo()
}

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var BMILabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var statLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var seeRestaurantsButton: UIButton!
    
    @IBOutlet weak var seeParksButton: UIButton!
    
    @IBOutlet weak var seeGymsButton: UIButton!
    
    
    let BMI = LocalStorageService.loadMassHeightBMI()?[2] ?? 0
    
    var weight:Double {
        
        if let mass = LocalStorageService.loadMassHeightBMI()?[0] {
            return mass / 0.453592
        }
        
        return 0
    }
    
    var weightStat: weightStatus  {
        
        get {
            if BMI < 18.5 {
                return .underWeight
            } else if BMI > 18.5 && BMI < 24.9 {
                return .normal
            } else {
                return .overWeight
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //check BMI values here
        //should make an enum for this
        weightLabel.text = "\(round(weight * 10) / 10) lb"
        
        BMILabel.text = "BMI: \(round(BMI * 10) / 10)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        switch weightStat {
        case .underWeight:
            statLabel.text = "You are currently under weight. \n\n You deserve a meal. Take a look at restaurants nearby: "
            
            seeParksButton.alpha = 0
            seeGymsButton.alpha = 0
            
        case .overWeight:
            statLabel.text = "You are currently over weight. \n\n It's okay, there are places nearby to help you be active."
            
            //want to try and swap stuff in the stack view
            
            let restaurants = stackView.subviews[0]
            
            stackView.removeArrangedSubview(restaurants)
            
            restaurants.removeFromSuperview()
            
            stackView.addSubview(seeRestaurantsButton)
            
            stackView.addArrangedSubview(seeRestaurantsButton)
            
            seeRestaurantsButton.updateConstraints()
            
            stackView.updateConstraints()
            
        default:
            statLabel.text = "You are currently at a healthy weight. \n\n Don't slack off! Eat healthy and get active."
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.updateInfoDelegate = self
        }
    }
    
    
    //for underweight people only recommend restaurants(add a food scanner to count calories possibly)
    
    //for overweight people recommend parks and gyms
    
    
    @IBAction func seeRestaurantsTapped(_ sender: Any) {
        
        print("tapped")
        
        
    }
    
    
    @IBAction func seeParksTapped(_ sender: Any) {
        //performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
    @IBAction func seeGymsTapped(_ sender: Any) {
    }
    
}

extension HomeViewController: updateOnScreenInfoDelegate {
    
    func updateInfo() {
        weightLabel.text = "\(round(((LocalStorageService.loadMassHeightBMI()?[0] ?? 0) / 0.453592 ) * 10) / 10 )"
        
        BMILabel.text = "\(round((LocalStorageService.loadMassHeightBMI()?[2] ?? 0) * 10) / 10)"
        
       let newBMI = LocalStorageService.loadMassHeightBMI()?[2] ?? 0
        
        var updatedWeightStat:weightStatus {
            if newBMI < 18.5 {
                return .underWeight
            } else if newBMI > 18.5 && newBMI < 24.9 {
                return .normal
            } else {
                return .overWeight
            }
        }
        
        switch updatedWeightStat {
        case .underWeight:
            statLabel.text = "You are currently under weight. \n\n You deserve a meal. Take a look at restaurants nearby: "
            
            if seeParksButton.superview != nil && seeGymsButton.superview != nil  {
                            
                            seeParksButton.alpha = 0
                            seeGymsButton.alpha = 0

            }
            
            seeRestaurantsButton.updateConstraints()
            
            stackView.updateConstraints()
            
            
        case .overWeight:
            statLabel.text = "You are currently over weight. \n\n It's okay, there are places nearby to help you be active."
            
            //want to try and swap stuff in the stack view
            
            let restaurants = stackView.subviews[0]
            
            stackView.removeArrangedSubview(restaurants)
            
            restaurants.removeFromSuperview()
            
            stackView.addSubview(seeRestaurantsButton)
            
            stackView.addArrangedSubview(seeRestaurantsButton)
            
            seeRestaurantsButton.updateConstraints()
            
            stackView.updateConstraints()
            
        default:
            statLabel.text = "You are currently at a healthy weight. \n\n Don't slack off! Eat healthy and get active."
        }
        
    }
    
}
