//
//  DetailVCViewController.swift
//  DagbokAppTry1
//
//  Created by imran khan on 2018-02-06.
//  Copyright © 2018 imran khan. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation


class DetailVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placename: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var showMapButton: UIButton!
    private var ref: DatabaseReference!
    private var databaseH: DatabaseHandle!
    var noteID : String = ""
    
    var currentNote: ViewController.Notes!
    //    var locationManager: CLLocationManager!
    var myLocation: CLLocation = CLLocation()
    
    var currentLocation: ViewController.Notes!
    
    var addressString : String = ""
    var downloadedImage: UIImage? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        detailTextView.text = ""
        placename.text = ""
        
        activityIndiator(indicator: activityIndicator)
        showMapbutton(button: showMapButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        updateFromFirebase()
    }
    
    func showMapbutton(button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.layer.borderColor = UIColor.darkText.cgColor
        button.layer.masksToBounds = true
    }
    
    func activityIndiator(indicator: UIActivityIndicatorView) {
        indicator.color = UIColor.blue
        indicator.sizeThatFits(CGSize(width: 60, height: 60))
    }
    
    func updateFromFirebase() {
        ref = Database.database().reference()
        ref.child("Posts").child(noteID).observeSingleEvent(of: .value, with: { (snapshot) in
            //dump(snapshot.value)
            guard var title = self.titleLabel.text else { return }
            guard var detail = self.detailTextView.text else { return print("No details have been found!!!") }
            
            let value = snapshot.value as? NSDictionary
            title = value?["title"] as? String ?? ""
            detail = value?["detail"] as? String ?? ""
            
            if let imageUrl = value!["imageUrl"] as? String{
                
                //                let imageURL = value?["imageUrl"] as? String ?? ""
                DispatchQueue.global(qos: .background).async {
                    self.downloadImage(path: imageUrl)
                    
                    DispatchQueue.main.async {
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false
                            , block: { (timer) in
                                UIView.animate(withDuration: 1.0, animations: {
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                    
                                    self.titleLabel.text = title
                                    self.detailTextView.text = detail
                                    self.placename.text = self.addressString
                                    //                                    if let image = self.downloadedImage {
                                    //                                        self.imageView.image = image
                                    //                                    } else {
                                    //                                        print("No image can be shown")
                                    //                                    }
                                })
                        })
                    }
                }
            }
            
            if let placename = value?["placename"] as? NSDictionary {
                let latidute = placename["latitude"] as? Double ?? 0.0
                let longtidute = placename["longtitude"] as? Double ?? 0.0
                self.myLocation = CLLocation(latitude: latidute, longitude: longtidute)
            }
            self.findLocation()
        }) { (error) in
            print("***Error found*** \(error)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    func findLocation()  {
        let geocoder = CLGeocoder()
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(self.myLocation, completionHandler: { (placemarks, error) -> Void in
            
            if error == nil {
                //  let pm = placemarks! as [CLPlacemark]
                if let pm = placemarks?[0] {
                    print(pm.name ?? "")
                    let pm = placemarks![0]
                    if pm.subLocality != nil || pm.thoroughfare != nil || pm.locality != nil || pm.postalCode != nil || pm.country != nil {
                        self.addressString = pm.subLocality! + ", " + pm.thoroughfare! + ", " + "\n" + pm.locality! + ", " + pm.postalCode! + " " + pm.country! + ", "
                    }
                    // Showing address in textView
                    //self.placename.text = self.addressString
                }
            }
            else {
                if error != nil {
                    print("Error found whild CgeoCoding finding address")
                }
            }
        })
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
    }
    
    func downloadImage(path: String) {
        
        let imageRef = Storage.storage().reference(withPath: path)
        let downloadTask = imageRef.getData(maxSize: 5 * (1024*1024), completion:  { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.downloadedImage = image
                self.imageView.image = self.downloadedImage
            }else {
                if let error = error {
                    print("*** Error while downloading **** \(error.localizedDescription)")
                }
            }
        })
        //    downloadTask.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMap" {
            if let showMap = segue.destination as? popUpMapVC {
                    showMap.addressID = addressString
                    showMap.noteID = noteID
            }
        }
    }
}




//        downloadTask.observe(.progress) { (snapshot) in
//            print(snapshot.progress ?? "No more progress left")
//        }

//    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let localURL = documentsURL.appendingPathComponent("filename")
//
