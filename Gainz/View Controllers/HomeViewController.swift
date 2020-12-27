//
//  HomeViewController.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/19/20.
//

import UIKit
import CoreLocation

//will eventually make into a profile but this works for now

protocol updateOnScreenInfoDelegate {
    func updateInfo()
}
///main view controller
class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var BMILabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var statLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var seeRestaurantsButton: UIButton!
    
    @IBOutlet weak var seeParksButton: UIButton!
    
    @IBOutlet weak var seeGymsButton: UIButton!
    
    let locationManager = CLLocationManager()
    var location:CLLocation?
    
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
    
    var destinationType:DestinationType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        checkLocationServices()
        checkAuthorizationForLocation()
        
        //check BMI values here
        //should make an enum for this
        weightLabel.text = "\(round(weight * 10) / 10) lb"
        
        BMILabel.text = "BMI: \(round(BMI * 10) / 10)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       // locationManager.requestAlwaysAuthorization()
       // locationManager.requestWhenInUseAuthorization()
        
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
        } else if let mapVC = segue.destination as? MapViewController {
            mapVC.destinationType = self.destinationType
            mapVC.location = self.locationManager.location
        } else if let restaurantVC = segue.destination as? RestaurantTableViewController {
            restaurantVC.locationManager = self.locationManager.location
        }
    }
    
    
    //for underweight people only recommend restaurants(add a food scanner to count calories possibly)
    
    //for overweight people recommend parks and gyms
    
    
    @IBAction func seeRestaurantsTapped(_ sender: Any) {
        
       
        
        
    }
    
    
    @IBAction func seeParksTapped(_ sender: Any) {
        destinationType = .park
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    @IBAction func seeGymsTapped(_ sender: Any) {
        destinationType = .gym
        performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    private func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            // Here we must tell user how to turn on location on device
            let alert = UIAlertController(title: "Error", message: "Turn on location services for better accuracy", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            return
        }
            
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func checkAuthorizationForLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
         
            
            locationManager.startUpdatingLocation()
            
            break
        case .denied:
            // Here we must tell user how to turn on location on device
            let alert = UIAlertController(title: "Error", message: "Turn on location services for better accuracy", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
                // Here we must tell user that the app is not authorize to use location services
            let alert = UIAlertController(title: "Error", message: "This app is not authorized to use location services", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            break
        @unknown default:
            break
        }
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

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
       // print(location?.coordinate)
    }
}
