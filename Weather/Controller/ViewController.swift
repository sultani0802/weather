//
//  ViewController.swift
//  Weather
//
//  Created by Haamed Sultani on 2018-09-16.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import CoreLocation // Allows us to use the GPS on our iPhone

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "f6f749e921fd7189db37b44ab0d7b273" // Required to make API calls to OpenWeatherMap
    
    // MARK: - Instance Variables
    var locationManager: CLLocationManager = CLLocationManager() // Object required to use GPS
    
    // MARK: - IB Outlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var currentCityLabel: UILabel!
    
    
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self // This class is the delegate for GPS library
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Accuracy for the GPS
        locationManager.requestWhenInUseAuthorization() // Ask the user to allow us to use their location but only when the app is in use
        locationManager.startUpdatingLocation() // Start looking for the GPS coordinates of the iPhone
    }

    
    //MARK: - Networking
    //Write the getWeatherData method here:
    
    
    
    
    
    
    
    //MARK: - JSON Parsing
    //Write the updateWeatherData method here:
    
    
    
    
    
    //MARK: - UI Updates
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    // This method is called whenever the GPS receives a new location
    // These locations are saved in the "locations" array and apends them to the end of the array
    // The last location in the array is generally the most accurate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last // Grab the newest location
        
        if let currentLocation = location {
            if currentLocation.horizontalAccuracy > 0 { // Check if the range of the GPS accuracy is valid (below 0 is an invalid value)
                locationManager.stopUpdatingLocation() // Stop updating to conserve battery
                print(currentLocation)
                
                print("logitude = \(currentLocation.coordinate.longitude), latitude = \(currentLocation.coordinate.latitude)")
                
                let longitude = String(currentLocation.coordinate.longitude)
                let latitude = String(currentLocation.coordinate.latitude)
                
                let params : [String : String] = ["lon" : longitude, "lat" : latitude, "appid" : APP_ID]
                
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // Print error to the console
        
        currentCityLabel.text = "Location unavailable" // Show the user we can't find their location
    }
    
    
    //MARK: - Change City Delegate methods
    //Write the userEnteredANewCityName Delegate method here:
    //Write the PrepareForSegue Method here
}


