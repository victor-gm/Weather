//
//  TableViewController.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 29/11/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class TableViewController: UITableViewController
{
    
    //var forecast: Forecast?
    var savedForecast : savedForecast?
    var backgroundImage: UIImage?
    var index: Int?
    var total: Int?
    var city: String?
    
    var loaded: Bool = false
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("View Did Load",index!)
                
        if (index == 0)
        {
            city = Data.shared.lastLocationString
        }
        else
        {
            city = Data.shared.savedCities![index! - 1]
        }
        //savedForecast = nil
        if( Data.shared.savedForecasts.count - 1 >= index!)
        {
            savedForecast = Data.shared.savedForecasts[index!]
            backgroundImage = Data.shared.savedBackgrounds[index!].background
        }
        else
        {
            
        }
        print("after")

        //savedForecast = nil
        if savedForecast != nil
        {
          loaded = true
        }
        else {
            loaded = false
        }
        
        
        total = Data.shared.savedCities!.count + 1
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        pageControl.numberOfPages = total!
        pageControl.currentPage = index!
        
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.shared.savedForecasts[0].forecast.forecast!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("Table View", index)
        let color = UIColor.white
        var forecast: [Weather]?
        
        if(loaded)
        {
            forecast = savedForecast!.forecast.forecast!
        }


        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! TableViewMainCell
            
            cell.backgroundColor = .clear
            
            if (index == 0)
            {
                cell.locationIcon.isHidden = false
                cell.locationIcon.tintColor = color
            }
            
            if ( loaded)
            {
                let weatherImage = UIImage(named: (forecast![indexPath.row].icon)!)
                let weatherTintedImage = weatherImage?.withTintColor(color)
                cell.weatherIcon.image = weatherTintedImage
            }
            else
            {
                let weatherImage = UIImage(named: "clear-day")
                let weatherTintedImage = weatherImage?.withTintColor(color)
                cell.weatherIcon.image = weatherTintedImage
            }
        
            //cell.cityName.setTitle(savedForecast!.forecast.city, for: .normal)
            //cell.cityName.setTitle(Data.shared.savedCities![indexPath.row - 1], for: .normal)
            cell.cityName.setTitle(city, for: .normal)
           
            cell.cityName.setTitleColor(color, for: .normal)
            
            if (loaded)
            {
                cell.tempMin.text = "\(Int((forecast![indexPath.row].temperatureMin!)))º" // Is this a cast ??
                cell.tempMax.text = "\(Int((forecast![indexPath.row].temperatureMax!)))º"
                cell.weatherDescription.text = forecast![indexPath.row].summary
            }
            else
            {
                cell.tempMin.text = "*º" // Is this a cast ??
                cell.tempMax.text = "*º"
                cell.weatherDescription.text = "Updating..."
            }
          
            
            cell.tempMax.textColor = color
            cell.tempMin.textColor = color
            cell.weatherDescription.textColor = color
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            
            
            if ( loaded)
            {
                let weatherImage = UIImage(named: (forecast![indexPath.row].icon)!)
                let weatherTintedImage = weatherImage?.withTintColor(color)
                cell.weatherIcon.image = weatherTintedImage
            }
            else
            {
                let weatherImage = UIImage(named: "clear-day")
                let weatherTintedImage = weatherImage?.withTintColor(color)
                cell.weatherIcon.image = weatherTintedImage
            }
            cell.backgroundColor = .clear
            
            if (loaded)
            {
                cell.tempMin.text = "\(Int(((forecast?[indexPath.row].temperatureMin!)!)))º" // Is this a cast ??
                cell.tempMax.text = "\(Int((forecast![indexPath.row].temperatureMax!)))º"
            }else
            {
                cell.tempMin.text = "*º" // Is this a cast ??
                cell.tempMax.text = "*º"
            }
            cell.tempMax.textColor = color
            cell.tempMin.textColor = color
            
            //cell.weatherDescription.text = forecast[indexPath.row].summary
            
            let nextDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: Date()) // Each row represents + row of today. We add one day
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            let day = formatter.string(from: nextDate!)
            
            let dayTruncated = String(day.prefix(3))
            
            cell.day.text = dayTruncated
            cell.day.textColor = color
            
            return cell
        }

    }
    @objc func segue()
    {
        self.performSegue(withIdentifier: "cities", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        /*
        if segue.identifier == "cities"
        {
            if let destinationVC = segue.destination as? CityManagementTableViewController
            {
            }
        }*/
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        total = Data.shared.savedCities!.count + 1
        pageControl.numberOfPages = total!
        pageControl.currentPage = index!
        
        let imageView = UIImageView (image: backgroundImage)
        imageView.contentMode = .scaleAspectFill

        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        tintView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        imageView.addSubview(tintView)
        
        tableView.backgroundView = imageView
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

