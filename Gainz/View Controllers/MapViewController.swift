//
//  MapViewController.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/26/20.
//

import UIKit
import MapKit

enum DestinationType {case park, gym}

class MapViewController: UIViewController {

    let initialLocation = CLLocation(latitude: 40.68919, longitude: -73.992378)
    
    @IBOutlet private var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    var location: CLLocation?

    var parks = [Park]()
    var gyms = [Gym]()
    
    var destinationType: DestinationType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // guard let location = locationManager.location?.coordinate else { return }
        
        mapView.delegate = self
        
        
        mapView.centerToLocation(location ?? initialLocation)
        
        let region = MKCoordinateRegion(
            center: location?.coordinate ?? initialLocation.coordinate,
                 latitudinalMeters: 7000,
                 longitudinalMeters: 7000)
               mapView.setCameraBoundary(
                 MKMapView.CameraBoundary(coordinateRegion: region),
                 animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 18000)
           mapView.setCameraZoomRange(zoomRange, animated: true)
        
        if destinationType == .park {
            
            Networking.getParks(location: location ?? initialLocation) { (parks) in
                   
                    if let parks = parks {
                        self.parks = parks
                        DispatchQueue.main.async {
                            self.testMap()
                        }
                    }
                    
                }
        } else {
            Networking.getGyms(location: locationManager.location ?? initialLocation) { (gyms) in
               
                if let gyms = gyms {
                    self.gyms = gyms
                    DispatchQueue.main.async {
                        self.testMap()
                    }
                }
                
            }
        }
    
    }
    
    func testMap() {
        
        if destinationType == .park {
            for park in parks {
                       let annotations = MKPointAnnotation()
                       annotations.title = park.name
                       annotations.coordinate = CLLocationCoordinate2D(latitude: park.location!["lat"]!, longitude: park.location!["lng"]!)
                      
                           self.mapView.addAnnotation(annotations)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                       
                   }
        } else {
            for gym in gyms {
                       let annotations = MKPointAnnotation()
                       annotations.title = gym.name
                       annotations.coordinate = CLLocationCoordinate2D(latitude: gym.location!["lat"]!, longitude: gym.location!["lng"]!)
                      
                           self.mapView.addAnnotation(annotations)
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                       
                   }
        }
        
        mapView.showAnnotations(mapView.annotations, animated: true)
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
    regionRadius: CLLocationDistance = 5000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}


extension MapViewController: MKMapViewDelegate {
    func mapView(
      _ mapView: MKMapView,
      viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
      // 2
    
      // 3
      let identifier = "annotation"
      var view: MKMarkerAnnotationView
      // 4
      if let dequeuedView = mapView.dequeueReusableAnnotationView(
        withIdentifier: identifier) as? MKMarkerAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
      } else {
        // 5
        view = MKMarkerAnnotationView(
          annotation: annotation,
          reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
      }
      return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let urlString = "maps://?saddr=\(location!.coordinate.latitude),\(location!.coordinate.longitude)&daddr=\(view.annotation?.coordinate.latitude ?? 0.0),\(view.annotation?.coordinate.longitude ?? 0.0)&dirfgl=c"
        
        let url = URL(string: urlString)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
  }

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}


