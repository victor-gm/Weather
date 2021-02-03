//
//  CitiesTableViewCell.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 02/12/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
