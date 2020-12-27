//
//  MapViewController.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/26/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let initialLocation = CLLocation(latitude: 40.68919, longitude: -73.992378)
    
    @IBOutlet private var mapView: MKMapView!
    
    var parks = [Park]()
    var gyms = [Gym]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        mapView.centerToLocation(initialLocation)
        
        Networking.getParks { (parks) in
           
            if let parks = parks {
                self.parks = parks
                DispatchQueue.main.async {
                    self.testMap()
                }
            }
            
        }

    
    }
    
    func testMap() {
        
        for park in parks {
            let annotations = MKPointAnnotation()
            annotations.title = park.name
            annotations.coordinate = CLLocationCoordinate2D(latitude: park.location!["lat"]!, longitude: park.location!["lng"]!)
            mapView.addAnnotation(annotations)
            
        }
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}


extension MapViewController: MKMapViewDelegate {
    
}
