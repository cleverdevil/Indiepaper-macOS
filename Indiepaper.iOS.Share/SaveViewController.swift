//
//  SaveViewController.swift
//  Indiepaper.iOS.Share
//
//  Created by Edward Hinkle on 7/10/18.
//  Copyright © 2018 Jonathan LaCour. All rights reserved.
//

import UIKit
import MobileCoreServices

class SaveViewController: UIViewController {
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var modalView: UIView!
    private var modalCenterPosition: CGFloat? = nil
    private var urlToSave: URL? = nil
    private var targetUrl: URL? = nil
    private var bearerToken: String? = nil
    
    @IBAction func cancelTapped(_ sender: Any) {
        let originalTransform = modalView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.2, y: 0.2)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.25,
           animations: { [weak self] in
                self?.modalView.alpha = 0
                self?.modalView.transform = scaledAndTranslatedTransform
            },
           completion: { [weak self] _ in self?.extensionContext!.cancelRequest(withError: NSError(domain: "io.indiepaper", code: 1))
            })
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let originalTransform = modalView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.2, y: 0.2)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.25,
           animations: { [weak self] in
                self?.modalView.alpha = 0
                self?.modalView.transform = scaledAndTranslatedTransform
            },
           completion: { [weak self] _ in self?.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
            })
    }
    
    func completeSave() {
        DispatchQueue.main.async { [weak self] in
            if let url = self?.urlToSave {
                self?.urlLabel.text = " Saved \(url.absoluteString)"
//                let originalTransform = self?.modalView.transform
//                let scaledTransform = originalTransform?.scaledBy(x: 0.2, y: 0.2)
//                let scaledAndTranslatedTransform = scaledTransform?.translatedBy(x: 0.1, y: 0.1)
                
                UIView.animate(withDuration: 0.25,
                   delay: 2,
                   animations: { [weak self] in
                        self?.modalView.alpha = 0
//                        if scaledAndTranslatedTransform != nil {
//                            self?.modalView.transform = scaledAndTranslatedTransform!
//                        }
                    },
                   completion: { [weak self] _ in
                    var request = URLRequest(url: URL(string: "https://indiepaper.io")!)
                        request.httpMethod = "POST"
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(self?.bearerToken! ?? "")", forHTTPHeaderField: "Authorization")
                        request.setValue(self?.targetUrl!.absoluteString, forHTTPHeaderField: "x-indiepaper-destination")
                        request.httpBody = "url=\(url.absoluteString)".data(using: .utf8, allowLossyConversion: false)
                    
                        // set up the session
                        let config = URLSessionConfiguration.default
                        let session = URLSession(configuration: config)
                    
                        let task = session.dataTask(with: request) { (data, response, error) in
                            // check for any errors
                            guard error == nil else {
                                print("error sending POST)")
                                print(error ?? "No error present")
                                return
                            }
                            
                            if let httpResponse = response as? HTTPURLResponse {
                                if httpResponse.statusCode == 200 {
                                    self?.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                                }
                            }
                        }
                    
                        task.resume()
                    })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults(suiteName: "group.io.cleverdevil.Indiepaper")!
        targetUrl = defaults.url(forKey: "targetURL")
        bearerToken = defaults.string(forKey: "bearerToken")
        
        guard targetUrl != nil, bearerToken != nil else {
            print("NO TARGET URL OR BEARER TOKEN")
            // TODO: ERROR! No Target Url or Bearer Token
            return
        }
        
        let extensionItems = extensionContext?.inputItems as! [NSExtensionItem]
        let itemProvider = extensionItems.first?.attachments?.first as! NSItemProvider
//        let propertyList = String(kUTTypePropertyList)
        let plainText = String(kUTTypePlainText)
        let urlAttachment = String(kUTTypeURL)
        
        DispatchQueue.global(qos: .background).async {
//            if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
//                itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
//                    guard let dictionary = item as? NSDictionary else { return }
//                    OperationQueue.main.addOperation {
//                        print();
//                        if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
//                            let urlString = results["URL"] as? String,
//                            let itemUrl = URLComponents(string: urlString){
//                            self.shareUrl(url: itemUrl)
//                        }
//                    }
//                })
//            } else if itemProvider.hasItemConformingToTypeIdentifier(plainText) {

            if itemProvider.hasItemConformingToTypeIdentifier(plainText) {
                itemProvider.loadItem(forTypeIdentifier: plainText, options: nil, completionHandler: { [weak self] (item, error) -> Void in
                    if let itemString = item as? String,
                        let itemUrl = URL(string: itemString) {
                        self?.urlToSave = itemUrl
                        self?.completeSave()
                    }
                })
            } else if itemProvider.hasItemConformingToTypeIdentifier(urlAttachment) {
                itemProvider.loadItem(forTypeIdentifier: urlAttachment, options: nil, completionHandler: { [weak self] (item, error) -> Void in
                    if let itemUrl = item as? URL {
                        self?.urlToSave = itemUrl
                        self?.completeSave()
                    }
                })
            } else {
                print("error")
                //            print(extensionItems?.first?.attachments)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        modalView.alpha = 0
        view.backgroundColor?.withAlphaComponent(0)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.modalView.alpha = 1
            self?.view.backgroundColor?.withAlphaComponent(0.2)
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
