//
//  ImageResizer.swift
//  CiscoSortaGram
//
//  Created by Francisco Ragland Jr on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

    //Class function for resizing the image
extension UIImage{
    class func resizeImage(image: UIImage, size: CGSize) -> UIImage{
        
        UIGraphicsBeginImageContext(size)
        
        image.drawInRect(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
