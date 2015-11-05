//
//  API.swift
//  CiscoSortaGram
//
//  Created by Francisco Ragland Jr on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class API {
    
    class func uploadImage(image: UIImage, completion: (success: Bool) -> ()) {
        
        if let imageData = UIImageJPEGRepresentation(image, 0.7) {
            
            let imageFile = PFFile(name: "image", data: imageData)
            let status = PFObject(className: "Status")
            status["image"] = imageFile
            
            status.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    completion(success: success)
                } else {
                    completion(success: false)
                }
            })
        }
        
    }
    
}
