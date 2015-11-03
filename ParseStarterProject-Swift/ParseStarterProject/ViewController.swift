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
            presentActionController()
            
            
            
            
            
            return true
        } else {
            //say stuff in here that you want to happen if the camera is NOT available
            
            
            
            return false
        }
    }
        //presents the action controller
    func presentActionController(){
        let actionController = UIAlertController(title: "", message: "Camera or Library?", preferredStyle:.Alert)
        
        let cameraAction = UIAlertAction(title: "", style:.Default) {(alert) -> Void in
            self.presentImagePickerFor(.Camera)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style:.Default) {(alert) -> Void in
            self.presentImagePickerFor(.PhotoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style:.Destructive, handler: nil)
        
        actionController.addAction(cameraAction)
        actionController.addAction(photoLibrary)
        actionController.addAction(cancelAction)
        
        self.presentViewController(actionController, animated: true, completion: nil)

    }
    
    func presentImagePickerFor(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

