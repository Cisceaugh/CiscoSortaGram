//
//  GalleryViewController.swift
//  CiscoSortaGram
//
//  Created by Francisco Ragland Jr on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //An array of what will be displayed in collectionView
    var statuses = [PFObject]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()
        print(self.statuses.count)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set instance of query with image name to query
        let query = PFQuery(className: "Image")
        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            
            
            //safety check
            if error == nil {
                
                //go in and add whats in objects array to statuses
                for object in objects! {
                    self.statuses.append(object)
                }
                
            } else {
                // handle the error
                print("Something went wrong")
            }
            
            print(self.statuses.count)

        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //how many items per section?
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses.count
    }
    
    //what goes inside of each cell?
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //get a cell from UICollection view but cast it as my CollectionViewCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        //pull out an object at indexPath.row of my statuses array
        let status = self.statuses[indexPath.row]
        
        //safety check to make sure status is a PFFile at image key from Parse
        if let imageFile = status["image"] as? PFFile {
            
            //go get the data from Parse
            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                //check if data we have can be image
                if let image = UIImage(data: data!) {
                    //set newfound image to our imageView
                    cell.imageView.image = image
                }
            })
        }
        
        return cell
    }
}
