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
        
        //take imageData NSData as 0.7 bitmap of image
        if let imageData = UIImageJPEGRepresentation(image, 0.7) {
            
            //set data with name "image" = to imageFile PFFile
            let imageFile = PFFile(name: "image", data: imageData)
            
            //make status from PFObject with class name status
            let status = PFObject(className: "Image")
            
            //assign status at key "image" with imageFile
            status["image"] = imageFile
            
            
            //perform save, if save, completion true, if not, completion false
            status.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    completion(success: success)
                    print("upload success")
                } else {
                    completion(success: false)
                }
            })
        }
        
    }
    

    
}
