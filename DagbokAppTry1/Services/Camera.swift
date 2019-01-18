//
//  Camera.swift
//  DagbokAppTry1
//
//  Created by imran khan on 2018-02-14.
//  Copyright © 2018 imran khan. All rights reserved.
//

import Foundation
import UIKit

extension AddFormController {
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
