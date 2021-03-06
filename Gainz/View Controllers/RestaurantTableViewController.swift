//
//  RestaurantTableViewController.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/26/20.
//

import UIKit
import CoreLocation

class RestaurantTableViewController: UITableViewController {

    var restaurants = [Restaurant]()
    
    var locationManager:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.e(location: <#CLLocation#>)ditButtonItem
        
        Networking.getRestaurants(location: locationManager ?? CLLocation(latitude: 74, longitude: 120)) { (restaurants) in
            if let restaurants = restaurants {
                self.restaurants = restaurants
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                }
                
            }
        }
        
    }
    
    //need action sheet
    
    func showActionSheet(row: Int) {
        
        let restaurant = restaurants[row]
        
        let actionSheet = UIAlertController(title: restaurant.restaurant_name, message: restaurant.hours, preferredStyle: .actionSheet)
        
        let directionsAction = UIAlertAction(title: "Get Directions", style: .default) {_ in
            let urlString = "maps://?saddr=\(self.locationManager!.coordinate.latitude),\(self.locationManager!.coordinate.longitude)&daddr=\(restaurant.geo!["lat"] ?? 74),\(restaurant.geo!["lon"] ?? 122)&dirfgl=c"
            
            let url = URL(string: urlString)!
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        actionSheet.addAction(directionsAction)
        if restaurant.restaurant_phone != "" {
            let callAction = UIAlertAction(title: "Call", style: .default) { (action) in
                        
                var restaurantPhone =  restaurant.restaurant_phone?.replacingOccurrences(of: " ", with: "")
                
                restaurantPhone = restaurantPhone?.replacingOccurrences(of: ")", with: "")
                restaurantPhone = restaurantPhone?.replacingOccurrences(of: "(", with: "")
                restaurantPhone = restaurantPhone?.replacingOccurrences(of: "-", with: "")
                        
                if let url = URL(string: "tel://\(restaurantPhone ?? "")") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    
                    }
                    
                    actionSheet.addAction(callAction)
        }
        
        
        if restaurant.restaurant_website != "" {
            let websiteAction = UIAlertAction(title: "Website", style: .default) { (action) in
                       if let url = URL(string: restaurant.restaurant_website!) {
                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
                       }
                   }
                   
                   actionSheet.addAction(websiteAction)
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        actionSheet.addAction(dismissAction)
       
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    //just show the hours in the action sheet
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantTableViewCell

        // Configure the cell...
        cell.setCell(for: restaurants[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActionSheet(row: indexPath.row)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
