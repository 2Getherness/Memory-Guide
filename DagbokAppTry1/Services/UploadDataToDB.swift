//
//  UploadDataToDB.swift
//  DagbokAppTry1
//
//  Created by imran khan on 2018-02-14.
//  Copyright © 2018 imran khan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices
import CoreLocation

extension AddFormController {
    
    
    
    func uploadDataToDatabase() {
        
        ref = Database.database().reference()
        let latitude = myLocation.coordinate.latitude
        let longitude = myLocation.coordinate.longitude
        
        let locationValues = ["latitude": latitude, "longtitude": longitude]
        
        if titleField.text != "" && titleField.text != titleField.placeholder && detailField.text != "" && detailField.text != detailField.placeholder {
            
            let currentTime = getCurrentDate()
            
            // that every image should have a unique id
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("\(imageName).jpg")
            
            if let image = self.imageView.image {
                if let uploadImageData = UIImageJPEGRepresentation(image, 0.7) {
                    let uploadTask = storageRef.putData(uploadImageData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error ?? "error hittat")
                        }
                        let values : [String: Any] = ["title": self.titleField.text ?? "", "detail": self.detailField.text ?? "", "imageUrl": "\(imageName).jpg", "placename": locationValues, "time": currentTime]
                        //                    let values : [String: Any] = ["title": self.titleField.text ?? "", "detail": self.detailField.text ?? "", "imageUrl": "\(imageName).jpg"]
                        self.saveInDatabase(values: values as [String : AnyObject])
                        
                    })
                    uploadTask.observe(.progress) { (snapshot) in
                        print(snapshot.progress ?? "No more progress")
                    }
                    uploadTask.resume()
                }
            }else {
                
                let values : [String: Any] = ["title": self.titleField.text ?? "", "detail": self.detailField.text ?? "", "placename": locationValues, "time": currentTime ]
                self.saveInDatabase(values: values as [String : AnyObject])
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func getCurrentDate() -> String {
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        print(dateString)
        return dateString
    }
    
    private func saveInDatabase(values: [String: AnyObject])  {
        let firRef = Database.database().reference().child("Posts").childByAutoId()
        firRef.updateChildValues(values, withCompletionBlock: {
            (err, firRefFromURL) in
            if err != nil {
                print(err ?? "error occured while saving values to database")
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}
