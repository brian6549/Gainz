//
//  RestaurantTableViewCell.swift
//  Gainz
//
//  Created by Brian Arias Cano on 12/26/20.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var RestaurantNameLabel: UILabel!
    
    
    @IBOutlet weak var AddressLabel: UILabel!
    
    @IBOutlet weak var HoursLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        RestaurantNameLabel.adjustsFontSizeToFitWidth = true
        
        AddressLabel.adjustsFontSizeToFitWidth = true
        
        HoursLabel.adjustsFontSizeToFitWidth = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func setCell(for restaurant: Restaurant) {
        RestaurantNameLabel.text = restaurant.restaurant_name
        AddressLabel.text = restaurant.address
        HoursLabel.text = restaurant.hours
    }

}
