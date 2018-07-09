//
//  ViewController.swift
//  Indiepaper.iOS
//
//  Created by Edward Hinkle on 7/9/18.
//  Copyright © 2018 Jonathan LaCour. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var targetUrl: URL? = nil
    var bearerToken: String? = nil
    
    @IBOutlet weak var configureButton: UIButton!
    @IBOutlet weak var targetUrlField: UITextField!
    @IBOutlet weak var bearerTokenField: UITextField!
    
    @IBAction func openConfiguration(_ sender: Any) {
        if let openUrl = URL(string: "https://www.indiepaper.io#indieauth"),
            UIApplication.shared.canOpenURL(openUrl) {
            UIApplication.shared.open(openUrl)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        targetUrl = defaults.url(forKey: "targetURL")
        bearerToken = defaults.string(forKey: "bearerToken")
        
        targetUrlField.text = targetUrl?.absoluteString
        bearerTokenField.text = bearerToken
        
        if targetUrl != nil, bearerToken != nil {
            configureButton.isHidden = true
            print("Configure button should be hidden")
        } else {
            configureButton.isHidden = false
            print("Configure button should be visible")
        }
    }


}

