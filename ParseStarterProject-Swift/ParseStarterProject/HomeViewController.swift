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
        checkForCamera()
        
        
    }
    
    @IBAction func filterButtonPressed(sender: UIButton) {
        print("Filtration success")
        if self.imageView.image != nil {
        presentFilterAlert()
        }
    }
    
    @IBAction func uploadImage(sender: UIButton) {
        if let _ = self.imageView.image{

        sender.enabled = false
        let newImage = ImageResizer.resizeImage(self.imageView.image!, size: CGSize(width: 600, height: 600))
        print(newImage?.size)
        API.uploadImage(newImage!) { (success) -> () in
            self.presentUploadAlert()
            sender.enabled = true
            }
        } else {
            noImageToUploadAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let object = PFObject(className: "Status")
//        object["text"] = "Flamingo"
//        object.saveInBackgroundWithBlock { (success, error) -> Void in
//            print("Hello Flamingo")
//        
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Functions
    
    func noImageToUploadAlert(){
        let alertController = UIAlertController(title: "", message: "Whoops, no image to upload!", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default) { (alert) -> Void in
        }
        
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func presentUploadAlert(){
        let alertController = UIAlertController(title: "", message: "Image successfully uploaded", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default) { (alert) -> Void in

        }
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true) { () -> Void in
            ImageResizer.resizeImage(self.imageView.image!, size: CGSize(width: 0.7, height: 0.7))
            
        }
    }
    
    func presentFilterAlert() {
        
        let alertController = UIAlertController(title: "Filters", message: "Pick a filter", preferredStyle: .ActionSheet)
        
        let vintageFilterAction = UIAlertAction(title: "Vintage", style: .Default, handler: { (alert) -> Void in
            FilterService.applyVintageEffect(self.imageView.image!, completion: { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage{
                    self.imageView.image = filteredImage
                }
            })
        })
        
        let BWFilterAction = UIAlertAction(title: "Black and White", style: .Default, handler: { (alert) -> Void in
            FilterService.applyBWEffect(self.imageView.image!, completion: { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage{
                    self.imageView.image = filteredImage
                }
            })
        })
        let chromeFilterAction = UIAlertAction(title: "Chrome", style: .Default, handler: { (alert) -> Void in
            FilterService.applyChromeEffect(self.imageView.image!, completion: { (filteredImage, name) -> Void in
                if let filteredImage = filteredImage{
                    self.imageView.image = filteredImage
                }
            })
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(vintageFilterAction)
        alertController.addAction(BWFilterAction)
        alertController.addAction(chromeFilterAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    
    func checkForCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            // say stuff in here that you want to happen if the camera is available
            self.presentActionController()

        } else {
            //say stuff in here that you want to happen if the camera is NOT available
            self.presentImagePickerFor(.PhotoLibrary)
           
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
