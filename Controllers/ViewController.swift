//
//  ViewController.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 30/11/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController
{
    var locationManager: CLLocationManager?
      
    var forecast: Forecast?
    var backgroundImage: UIImage?
    @IBOutlet weak var loading: UILabel!
    
    var ok: Bool = false
    var ok2: Bool = false
    @IBOutlet weak var gotItButton: UIButton!
    @IBAction func gottButtonAction(_ sender: Any)
    {
        ok = true
        if (ok2)
        {
            self.performSegue(withIdentifier: "loaded", sender: nil)
        }

    }
    
    
    @IBOutlet weak var isLoading: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        isLoading.startAnimating()
        
        gotItButton.backgroundColor = UIColor.systemBlue
        gotItButton.layer.cornerRadius = 8
        gotItButton.tintColor = .white
        gotItButton.isHidden = true
        //gotItButton.layer.borderColor = UIColor.black.cgColor
        
        if locationManager == nil
        {
            locationManager = CLLocationManager()
        }
         locationManager!.delegate = self
         locationManager!.requestAlwaysAuthorization()
         locationManager!.desiredAccuracy = kCLLocationAccuracyKilometer
         locationManager!.requestLocation()
        //locationManager!.startUpdatingLocation()
    }
    
    
}
   

    // MARK: - Location Delegate

extension ViewController: CLLocationManagerDelegate
{
    // Getting location for coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
         manager.stopUpdatingLocation()
         manager.delegate = nil
    
        if locations.count == 0 { return }
    
        Data.shared.lastLocation = locations.first!
      
        Data.shared.initLocation()
        {response in
        }
        
            if (Data.shared.savedCities!.count != 0)
            {
                Data.shared.initData //TO-DO: - Dynamic implementation of the cells that automatically update with the value couldn't be completed for the deadline, so a simpler solution such as loading it all together was taken
                       { response in
                           self.isLoading.stopAnimating()
                           self.isLoading.isHidden = true
                           self.loading.text = "Loaded!"
                           self.gotItButton.isHidden = false
                           
                           self.ok2 = true
                           if(self.ok)
                           {
                               self.performSegue(withIdentifier: "loaded", sender: nil)
                           }
                       }
            }
            else
            {
                self.isLoading.stopAnimating()
                self.isLoading.isHidden = true
                self.loading.text = "Loaded!"
                self.gotItButton.isHidden = false
               
                self.ok2 = true
                if(self.ok)
                {
                    self.performSegue(withIdentifier: "loaded", sender: nil)
                }
            }
       

    
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Location manager did failed with error: \(error.localizedDescription)")
    }
}


