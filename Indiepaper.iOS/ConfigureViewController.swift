//
//  ConfigureViewController.swift
//  Indiepaper.iOS
//
//  Created by Edward Hinkle on 7/10/18.
//  Copyright © 2018 Jonathan LaCour. All rights reserved.
//

import UIKit

class ConfigureViewController: UIViewController {

    @IBOutlet weak var domainUrl: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleText: UILabel!
    
    @IBAction func loginTapped(_ sender: Any) {
        if let meUrl = domainUrl.text, let openUrl = URL(string: "https://indiepaper.io/indieauth?me=\(meUrl)"),
            UIApplication.shared.canOpenURL(openUrl) {
            UIApplication.shared.open(openUrl)
        }
    }
    
    @IBAction func manualTapped(_ sender: Any) {
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults(suiteName: "group.software.studioh.indiepaper")!
        
        if defaults.url(forKey: "targetURL") != nil, defaults.string(forKey: "bearerToken") != nil {
            cancelButton.isHidden = false
            titleText.text = "Configure"
        } else {
            cancelButton.isHidden = true
            titleText.text = "Introducing IndiePaper"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
