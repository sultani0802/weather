//
//  ViewController.swift
//  Weather
//
//  Created by Haamed Sultani on 2018-09-16.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import CoreLocation // Allows us to use the GPS on our iPhone
import Alamofire // Allows use to make Networking requests
import SwiftyJSON // Makes handling JSON objects easier

class ViewController: UIViewController, CLLocationManagerDelegate, SecondViewDelegate {
    
    // MARK: - Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "2327e118b839d3e9f1d1318fc1f8adf2" // Required to make API calls to OpenWeatherMap
    
    // MARK: - Instance Variables
    var locationManager: CLLocationManager = CLLocationManager() // Object required to use GPS
    var weatherDataModel: WeatherDataModel = WeatherDataModel()
    
    // MARK: - IB Outlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var currentCityLabel: UILabel!
    
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCityLabel.adjustsFontSizeToFitWidth = true // Shrink the size of the text if it doesn't fit
        
        locationManager.delegate = self // This class is the delegate for GPS library
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Accuracy for the GPS
        locationManager.requestWhenInUseAuthorization() // Ask the user to allow us to use their location but only when the app is in use
        locationManager.startUpdatingLocation() // Start looking for the GPS coordinates of the iPhone
    }
    
    
    //MARK: - Networking
    // Called by the location manager delegate method locationManager(didUpdateLocation) below
    func getWeatherData(url: String, parameters: [String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Request to OWM was successfully sent.")
                let weatherJSON : JSON = JSON(response.result.value!) // Create local version of JSON from OpenWeatherMap
                
                // Created a switch statement to handle the different response codes from OpeNWeatherMap
                switch weatherJSON["cod"].intValue {
                case 200: // Success
                    print("Retrieved weather data successfuly.")
                    self.updateWeatherData(json: weatherJSON) // Pass the data to the method that will handle the JSON object returned
                case 401: // Invalid API key
                    print("API key is invalid")
                    self.displayErrorMessage(myMessage: "Contact developer(error: \(weatherJSON["cod"].intValue))")
                default: // Default case for error handling
                    print("Error:")
                    self.displayErrorMessage(myMessage: "Contact developer(error: \(weatherJSON["cod"].intValue))")
                }
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.displayErrorMessage(myMessage: "Could not connect to weather server.")
            }
        }
    }
    
    
    
    //MARK: - JSON Parsing
    // Called by getWeatherData() above
    func updateWeatherData(json: JSON){
        if let temperature = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int(temperature - 273.15) // subtracting 273.15 to convert from kelvin to celcius
            weatherDataModel.city = json["name"].string! // Grab the city from the JSON
            weatherDataModel.condition = json["weather"][0]["id"].intValue // Grab the code for the condition in that city
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition) // Set the weather icon's image filename according to the condition code
            
            updateUIWithWeatherData() // Update the UI
        } else {
            self.displayErrorMessage(myMessage: "Weather unavailable (Error: \(json["cod"].stringValue))") // Tell the user that we couldn't retrieve the weather information
        }
    }
    
    
    
    
    //MARK: - UI Updates
    // Called by updateWeatherData() above
    func updateUIWithWeatherData() {
        currentCityLabel.text = weatherDataModel.city // Set the city
        temperatureLabel.text = "\(String(weatherDataModel.temperature))℃" // Set the temperature
        weatherIconImageView.image = UIImage(named: weatherDataModel.weatherIconName) // Update the condition
    }
    
    func displayErrorMessage(myMessage: String) {
        let alert = UIAlertController(title: "Error", message: myMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Location Manager Delegate Methods
    // This method is called whenever the GPS receives a new location
    // These locations are saved in the "locations" array and apends them to the end of the array
    // The last location in the array is generally the most accurate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last // Grab the newest location
        
        if let currentLocation = location {
            if currentLocation.horizontalAccuracy > 0 { // Check if the range of the GPS accuracy is valid (below 0 is an invalid value)
                locationManager.stopUpdatingLocation() // Stop updating to conserve battery
                locationManager.delegate = nil // Set the delegate to nil so that we don't get multiple requests being made to the endpoint while the stopUpdatingLocation() method finishes
                
                let longitude = String(currentLocation.coordinate.longitude)
                let latitude = String(currentLocation.coordinate.latitude)
                
                let params : [String : String] = ["lon" : longitude, "lat" : latitude, "appid" : APP_ID]
                
                getWeatherData(url: WEATHER_URL, parameters: params)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error) // Print error to the console
        
        displayErrorMessage(myMessage: "Weather unavailable (Error: \(error))") // Tell the user that we couldn't retrieve the weather information
        
    }
    
    // MARK: - Second View Delegate Methods
    // This method is automatically called when the user hits the "Fetch Weather" button
    func userEnteredNewCity(city: String) {
        let params : [String : String] = ["q": city, "appid": APP_ID] // Create the parameters for GET request
        getWeatherData(url: WEATHER_URL, parameters: params) // GET the weather data
    }
    
    //MARK: - Second View Delegate methods
    //Write the userEnteredANewCityName Delegate method here:
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondView" {
            let destinationVC = segue.destination as! SecondViewController // Initialize the VC that we are switching to
            
            destinationVC.delegate = self // Set the destination VC's delegate we are going to this View Controller
        }
    }
}


