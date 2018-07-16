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
    
    @IBOutlet weak var targetUrlField: UITextField!
    @IBOutlet weak var bearerTokenField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults(suiteName: "group.io.cleverdevil.Indiepaper")!
        
        targetUrl = defaults.url(forKey: "targetURL")
        bearerToken = defaults.string(forKey: "bearerToken")
        
        targetUrlField.text = targetUrl?.absoluteString
        bearerTokenField.text = bearerToken
    }


}

