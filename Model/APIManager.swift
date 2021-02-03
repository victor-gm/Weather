//
//  APIManager.swift
//  WeatherApp 2.0
//
//  Created by Víctor Garrido Martínez on 28/11/2019.
//  Copyright © 2019 Víctor Garrido Martínez. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import ObjectMapper
import AlamofireImage
//import AlamofireObjectMapper

private let baseURLDarkSky = "https://api.darksky.net/forecast/a0d27dcbdb883e88258ec48bb2628c16/"
private let baseURLFlickrSearch = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=579057e982a8a4f55b012330c34eea5d&text="
private let baseURLFlickrImage = "https://www.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=579057e982a8a4f55b012330c34eea5d&photo_id="



//TO-DO Mirar si puedo mejorar la estructura
struct Weather: Mappable
{
    var summary:String?
    var icon:String?
    var temperatureMax:Double?
    var temperatureMin:Double?
    var time:Int?
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map)
    {
        summary         <- map["summary"]
        icon            <- map["icon"]
        temperatureMax  <- map["temperatureMax"]
        temperatureMin  <- map["temperatureMin"]
        time             <- map["time"]

    }
}

struct Forecast: Mappable
{
    var forecast: [Weather]?
    var city: String?
    
    init?(map: Map) {

    }
    
    mutating func mapping(map: Map)
    {
        forecast         <- map["daily.data"]
    }
    
}

struct Size: Mappable
{
    var label: String?
    var url: String?
    
    init?(map: Map)
    {

    }
       
   mutating func mapping(map: Map)
   {
       url               <- map["source"]
       label             <- map["label"]
   }
}

struct Photo: Mappable
{
    var id: String?
    var ispublic: Int?
    var Sizes: [Size]?
    
    init?(map: Map)
    {

    }
    
    mutating func mapping(map: Map)
    {
        id               <- map["id"]
        ispublic         <- map["ispublic"]
        Sizes             <- map["sizes.size"]
    }
    
}

struct Photos: Mappable
{
    var photos: [Photo]?
    
    init?(map: Map){}
    
    mutating func mapping(map: Map)
    {
        photos          <- map["photos.photo"]
    }
}


class APIManager
{
    static let shared = APIManager()

    init(){}
    

    
    //MARK: - Heavy Load Calls
    
    func requestPictureImage (location: String, callback: @escaping (_ data: UIImage) -> Void)
    {
        var URL = baseURLFlickrSearch + "\(location)&sort=relevance&format=json&nojsoncallback=1"
        URL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // Esplugues de LLobregat has spaces and crashes
        
        Alamofire.request(URL).validate().responseString // Search for city pictures
        { response in

            let photos = Photos(JSONString: response.value!)!

            let photoID = photos.photos![Int.random(in: 0 ..< 15)].id
            let URL = baseURLFlickrImage + "\(photoID!)&format=json&nojsoncallback=1"
           
            Alamofire.request(URL).validate().responseString //Search image URL for selected random picture ID
                { response in
                    let photo = Photo(JSONString: response.value!)
                    let photoURL = photo!.Sizes![photo!.Sizes!.count - 1].url! // Selecting biggest image URL possible
                    
                    Alamofire.request(photoURL, method: .get).responseImage // Request image
                        { response in
                            if let data = response.result.value
                            {
                                callback(data)
                            } else
                            {
                                print("Error loading image")
                            }
                        }
                }
        }
    }
    
    func requestWeatherForCoordinates(coordinates: CLLocation, location: String, callback: @escaping (_ data: Forecast) -> Void)
    {
        let URL = baseURLDarkSky + "\(coordinates.coordinate.latitude),\(coordinates.coordinate.latitude)?lang=en&units=si"
        
        Alamofire.request(URL).validate().responseString
            { response in
                var forecast = Forecast(JSONString: response.value!)!
                forecast.city = location
                callback(forecast)
            }
    }
}








