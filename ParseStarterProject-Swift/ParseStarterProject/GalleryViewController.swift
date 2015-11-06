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
    
    var statuses = [PFObject]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className: "Image")
        query.findObjectsInBackgroundWithBlock {(objects, error) -> Void in
            
            if error == nil {
                
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
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        
        let status = self.statuses[indexPath.row]
        if let imageFile = status["image"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if let image = UIImage(data: data!) {
                    cell.imageView.image = image
                }
            })
        }
        
        return cell
    }
}
