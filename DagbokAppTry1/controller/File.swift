//
//  File.swift
//  DagbokAppTry1
//
//  Created by imran khan on 2018-02-15.
//  Copyright © 2018 imran khan. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension ViewController {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            print(indexPath.row)
            let storageRef = Storage.storage().reference()
            //            let currRest = restaurantArray[indexPath.row]
            let currNote = searchedString[indexPath.row].id
            let imageUrl = storageRef.child("Posts").child(currNote).child("imageUrl")
            imageUrl.delete(completion: { Error in
                if Error != nil {
                    print("Error while deleting image")
                }
            })
            Database.database().reference().child("Posts").child(currNote).removeValue { Error,error   in
                
                if error != nil {
                    print("****Error while deleting Post****")
                }
                
            }
            
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

