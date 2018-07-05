//
//  ShareViewController.swift
//  Send to Indiepaper
//
//  Created by Jonathan LaCour on 7/3/18.
//  Copyright © 2018 Jonathan LaCour. All rights reserved.
//

import Cocoa

class ShareViewController: NSViewController {

    @IBOutlet var targetURL: NSTextField!
    @IBOutlet var bearerToken: NSTextField!
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ShareViewController")
    }

    override func loadView() {
        super.loadView()
    }
    
    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }

    @IBAction func send(_ sender: AnyObject?) {
        self.didSelectPost()
    }
    
    func sendToIndiepaper(url: String, destinationURL: String, bearerToken: String) {
        let indiepaperURL = URL(string: "https://indiepaper.cleverdevil.io/")!
        
        var request = URLRequest(url: indiepaperURL)
        request.httpMethod = "POST"
        
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(destinationURL, forHTTPHeaderField: "mp-destination")
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "url=" + url
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error!)")
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                NSLog("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
        }
        task.resume()
    }
    
    func didSelectPost() {
        let defaults = UserDefaults(suiteName: "io.cleverdevil.Indiepaper.SharedPreferences")!
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first as? NSItemProvider {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                            let targetURL = defaults.value(forKey: "targetURL") as! String
                            let bearerToken = defaults.value(forKey: "bearerToken") as! String
                            self.sendToIndiepaper(url: shareURL.absoluteString!, destinationURL: targetURL, bearerToken: bearerToken)
                        }
                        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                    })
                }
            }
        }
    }
    
}
