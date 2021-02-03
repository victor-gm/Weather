//
//  TableViewCell.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 29/11/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import UIKit

class TableViewMainCell: UITableViewCell {
        
    
    @IBOutlet weak var cityName: UIButton!
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    
    @IBAction func citiesPressed(_ sender: Any){}
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    

}
