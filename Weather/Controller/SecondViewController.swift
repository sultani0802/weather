//
//  SecondViewController.swift
//  Weather
//
//  Created by Haamed Sultani on 2018-09-16.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {

    
    // MARK: - IB Outlets
    @IBOutlet weak var newCityTextField: UITextField!
    
    
    // MARK: - IB Actions
    // This IBAction is called when the user wants to fetch the weather from the city they entered
    @IBAction func getWeatherPressed(_ sender: Any) {
        
        //1 Get the city name the user entered in the text field
        
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
    }
    
    
    // Go back to the first view controller
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
