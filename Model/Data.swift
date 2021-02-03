//
//  Data.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 03/12/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

struct savedBackground
{
    var background : UIImage?
    var index : Int?
    
    init (background: UIImage, index: Int)
    {
        self.background = background
        self.index = index
    }
}

struct savedForecast
{
     var forecast: Forecast
     var index : Int?
    
    init (forecast:Forecast, index: Int)
    {
        self.forecast = forecast
        self.index = index
    }
}

class Data
{
    static let shared = Data()
    var lastLocation: CLLocation?
    var lastLocationString: String?
    
    var savedCities: [String]?
    var savedBackgrounds = [savedBackground]()
    var savedForecasts = [savedForecast]()
    
    var deletedCities = [String?]()
    var addedCities = [String?]()
       
    
    private init()
    {
        //print("Init Data")
        savedCities = getfromLocal()
        if savedCities != nil{}
        else
        {
            //savedCities  = ["Formentera","Kingston Upon Thames", "Cienfuegos"]
            savedCities = ["Barcelona"]
            saveToLocal(savedCities!)
        }
        
    }
    
    
    
    // MARK: - Callback Hell
    func initLocation(callback: @escaping (_ data: Bool) -> Void) // callback
    {
        // We save location Forecasts
       getLocationName(location: lastLocation!)
       { response in
           self.lastLocationString = response
           self.requestData(coordinates: self.lastLocation!, locationName: response, index: 0) // Saving Location
           { response in
                callback(true)
                //self.initData()
           }
        }
    }
    
    func initData(callback: @escaping (_ data: Bool) -> Void)
    {
        var completedCounter = 0
        // Save saved cities
        for (i,cityName) in savedCities!.enumerated()
        {
            CLGeocoder().geocodeAddressString(cityName)
            { placemarks,error  in
                self.requestData(coordinates: (placemarks?.first?.location)!, locationName: cityName,index: i + 1)
                {response in
                    completedCounter = completedCounter + 1
                    self.sortInfo()
                    if(completedCounter == self.savedCities!.count)
                    {
                        print("Done!")
                        print("________________________________________________________________")
                        callback(true)
                        //self.sortInfo()
                    }
                }
            }
         }
    }
    
    func deleteData(index: Int)
    {
        deletedCities.append(Data.shared.savedCities![index])
        savedCities!.remove(at: index)
        saveToLocal(savedCities!)

        /*for i in savedForecasts.enumerated()
        {
            
        }
        
        for (i, savedBackground) in savedBackgrounds.enumerated()
        {
        }*/
        
    }
    
    func updateData (cityName: String, callback: @escaping (_ data: Bool) -> Void)
    {
        //savedCities = Data.shared.getfromLocal()
        addedCities.append(cityName)
        savedCities!.append(cityName)
        Data.shared.saveToLocal(savedCities!)
        savedCities = getfromLocal()
        
        CLGeocoder().geocodeAddressString(savedCities![savedCities!.count - 1])
        { placemarks,error  in
            self.requestData(coordinates: (placemarks?.first?.location)!, locationName: self.savedCities![self.savedCities!.count - 1],index: self.savedCities!.count  )
            {response in
                
                print("________________________________________________________________________________")
                print("City to Update: ", self.savedCities![self.savedCities!.count - 1])
                print("________________________________________________________________________________")
                self.sortInfo()
                callback(true)
            }
        }
    }
    func sortInfo ()
       {
           //print ("Sorting Info")
           savedBackgrounds.sort { (first, second) -> Bool in
               return first.index! < second.index!
           }
           
           savedForecasts.sort { (first,second) -> Bool in
               return first.index! < second.index!
           }
       }
    //MARK: - API Calls
     func requestData(coordinates: CLLocation, locationName: String, index: Int,callback: @escaping (_ data: Bool) -> Void)
        {

            APIManager.shared.requestPictureImage(location: locationName)
            {response in
             let saved = savedBackground(background: response, index: index)
             Data.shared.savedBackgrounds.append(saved)
             
                APIManager.shared.requestWeatherForCoordinates(coordinates: coordinates, location: locationName )
                { response in
                 let saved = savedForecast(forecast: response, index: index)
                 Data.shared.savedForecasts.append(saved)
                print("________________________________________________________")
                 print("Request data for ",locationName, "in index", index, "loaded")
                 print("________________________________________________________")
                 callback (true)
                }
            }
        }
    
   // MARK: - SaveTo Local Stuff
    func saveToLocal(_ savedCities: [String])
       {
           let userDefaults = UserDefaults.standard
           userDefaults.set(savedCities, forKey: "savedCities")
           userDefaults.synchronize()
       }

       func getfromLocal() -> [String]?
       {
           let userDefaults = UserDefaults.standard
           if let cities = userDefaults.object(forKey: "savedCities") as? [String] {
               return cities
           }
           return nil
       }
    
        // MARK: - Helpers
        
    func getLocationName (location: CLLocation, callback: @escaping (_ data: String) -> Void)
    {
        CLGeocoder().reverseGeocodeLocation(location)
        { (placemarks, error) in
            if (error == nil)
            {
                callback(placemarks![0].locality!)
            }
            else
            {
                callback ("Name not found for this city" )
            }
        }
    }
}

    

