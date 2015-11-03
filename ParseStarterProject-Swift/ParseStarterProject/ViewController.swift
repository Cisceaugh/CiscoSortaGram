/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

//test comment

import UIKit
import Parse

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBAction func imageViewButtonPressed(sender: UIButton) {
//        var imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = PFObject(className: "Status")
        object["text"] = "Flamingo"
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            print("Hello Flamingo")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkForCamera() -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            // say stuff in here that you want to happen if the camera is available
            
            
            
            
            
            
            return true
        } else {
            return false
        }
    }
    
    func displayActionController(){
        
    }
}

