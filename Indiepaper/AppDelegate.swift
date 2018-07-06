//
//  AppDelegate.swift
//  Indiepaper
//
//  Created by Jonathan LaCour on 7/3/18.
//  Copyright © 2018 Jonathan LaCour. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var logoView: NSImageView!
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var targetURLField: NSTextField!
    @IBOutlet weak var bearerTokenField: NSTextField!

    @IBAction func targetURLUpdated(_ sender: Any) {
        let defaults = UserDefaults(suiteName: "io.cleverdevil.Indiepaper.SharedPreferences")!
        defaults.set(targetURLField.stringValue, forKey: "targetURL")
    }

    @IBAction func bearerTokenUpdated(_ sender: Any) {
        let defaults = UserDefaults(suiteName: "io.cleverdevil.Indiepaper.SharedPreferences")!
        defaults.set(bearerTokenField.stringValue, forKey: "bearerToken")
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let defaults = UserDefaults(suiteName: "io.cleverdevil.Indiepaper.SharedPreferences")!
        
        defaults.set(targetURLField.stringValue, forKey: "targetURL")
        defaults.set(bearerTokenField.stringValue, forKey: "bearerToken")
        
        showConfirmation()
    }
    
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        // register URL handler
        let aem = NSAppleEventManager.shared();
        aem.setEventHandler(
            self,
            andSelector: #selector(handleURL(event:replyEvent:)),
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.logoView.image = NSImage(named: NSImage.Name("AppIcon"))
        
        let defaults = UserDefaults(suiteName: "io.cleverdevil.Indiepaper.SharedPreferences")!

        let targetURL = defaults.value(forKey: "targetURL")
        let bearerToken = defaults.value(forKey: "bearerToken")
        
        if ((targetURL != nil) && (bearerToken != nil)) {
            targetURLField.stringValue = defaults.value(forKey: "targetURL") as! String
            bearerTokenField.stringValue = defaults.value(forKey: "bearerToken") as! String
        }
    }
    
    @objc func handleURL(event: NSAppleEventDescriptor, replyEvent: NSAppleEventDescriptor) {
        // Handle URL's for configuration of the format:
        //
        //     indiepaper://configure?micropubTargetURL=XXX&bearerToken=YYY
        //
        // Eventually, we could support additional URL options, but only configuration for now.
        
        let defaults = UserDefaults(suiteName: "io.cleverdevil.Indiepaper.SharedPreferences")!

        let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue!
        let url = URL(string: urlString!)!
        
        var foundTargetURL = false
        var foundToken = false
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                if (item.name == "micropubTargetURL") {
                    foundTargetURL = true
                    targetURLField.stringValue = item.value!
                    defaults.set(targetURLField.stringValue, forKey: "targetURL")
                } else if (item.name == "bearerToken") {
                    foundToken = true
                    bearerTokenField.stringValue = item.value!
                    defaults.set(bearerTokenField.stringValue, forKey: "bearerToken")
                }
            }
        }
        
        if (foundTargetURL && foundToken) {
            showConfirmation()
        }
    }
    
    private func showConfirmation() {
        let alert = NSAlert()
        alert.messageText = "Settings Saved"
        alert.informativeText = "You should now have a \"Send to Indiepaper\" option available from sharing menus throughout macOS. You may now quit Indiepaper!"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
}

