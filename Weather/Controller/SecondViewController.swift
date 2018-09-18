//
//  SecondViewController.swift
//  Weather
//
//  Created by Haamed Sultani on 2018-09-16.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit


protocol SecondViewDelegate {
    func userEnteredNewCity (city: String)
}

class SecondViewController: UIViewController {

    
    // MARK: - IB Outlets
    @IBOutlet weak var newCityTextField: UITextField!
    
    var delegate : SecondViewDelegate? // Creating our reference to the instantiated protocol
    
    
    // MARK: - IB Actions
    // This IBAction is called when the user wants to fetch the weather from the city they entered when they click "Fetch Weather"
    @IBAction func getWeatherPressed(_ sender: Any) {
        
        let newCity = newCityTextField.text! // Grab the city the user entered
        delegate?.userEnteredNewCity(city: newCity) // If this delegate is not nil, pass the city the user entered to the method that is being handled by the delegate (which is ViewController.swift)         
        self.dismiss(animated: true, completion: nil) // Dismiss this view controller
    }
    
    
    // Go back to the first view controller
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
