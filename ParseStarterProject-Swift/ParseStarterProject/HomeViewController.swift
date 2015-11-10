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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: Properties
    
    var filterFunctions = [FilterService.applyVintageEffect, FilterService.applyChromeEffect, FilterService.applyBWEffect]
    var filteredImageInstances = [FilteredImagePreviewCollectionViewCell]()
    
    //MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterPreviewCollectionView: UICollectionView!
    
    //MARK: IBActions
    
    @IBAction func imageViewButtonPressed(sender: UIButton) {
        checkForCamera()
    }
    
    @IBAction func filterButtonPressed(sender: UIButton) {
        print("Filtration success")
        //safety for image
        if let _ = self.imageView.image {
        presentFilterAlert()
        }
    }
    
    @IBAction func uploadImage(sender: UIButton) {
        if let _ = self.imageView.image {

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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Functions
    
        //MARK: Alert related functions
    func noImageToUploadAlert() {
        let alertController = UIAlertController(title: "", message: "Whoops, no image to upload!", preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default) { (alert) -> Void in
        }
        
        alertController.addAction(okButton)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func presentUploadAlert() {
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
    
    //presents the action controller (called when there is a camera)
    func presentActionController() {
        
        //capture an alert controller init w/ my message and an alert style
        let actionController = UIAlertController(title: "", message: "Camera or Library?", preferredStyle:.Alert)
        
        //camera button
        let cameraAction = UIAlertAction(title: "Camera", style:.Default) {(alert) -> Void in
            
            //make action for presenting Camera
            self.presentImagePickerFor(.Camera)
        }
        //make action for presenting PhotoLibrary
        let photoLibrary = UIAlertAction(title: "Photo Library", style:.Default) {(alert) -> Void in
            self.presentImagePickerFor(.PhotoLibrary)
        }
        //cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style:.Destructive, handler: nil)
        
        //add actions
        actionController.addAction(cameraAction)
        actionController.addAction(photoLibrary)
        actionController.addAction(cancelAction)
        
        //present this view on whatever is calling this func with our actionController
        self.presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    //presents image picker for the source type passed in
    func presentImagePickerFor(sourceType: UIImagePickerControllerSourceType) {
        //capture UIImagePickerController
        let imagePickerController = UIImagePickerController()
        //set its source type to that which is passed into this function
        imagePickerController.sourceType = sourceType
        //make this VC the delegate object of this UIImagePickerController
        imagePickerController.delegate = self
        //present this PickerController
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        self.filterPreviewCollectionView.reloadData()
    }
    
    //MARK: CollectionView datasource functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterFunctions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filteredImagePreview", forIndexPath: indexPath) as! FilteredImagePreviewCollectionViewCell
        
        let filter = filterFunctions[indexPath.row]
        if let image = imageView.image {
            filter(image, completion: {(filteredImage, filterName) -> Void in
                cell.filteredImage.image = filteredImage
            })
        }
        
        
        print(cell)
        return cell
    }
    
    //MARK: CollectionView delegate functions
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        filterFunctions[indexPath.row](self.imageView.image!, completion: { (filteredImage, name) -> Void in
            if let filteredImage = filteredImage {
                self.imageView.image = filteredImage
            }
        })
    }
}

