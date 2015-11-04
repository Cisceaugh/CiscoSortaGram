//
//  FilterService.swift
//  CiscoSortaGram
//
//  Created by Francisco Ragland Jr on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

    // MARK: Filter Service
class FilterService {
    //take in parameters and image to be changed
    private class func setupFilter(filterName: String, parameters: [String: AnyObject]?, image: UIImage) -> UIImage?{
        //make image a ciimage
        let image = CIImage(image: image)
        let filter: CIFilter
        
        if let parameters = parameters{
            filter = CIFilter(name: filterName, withInputParameters: parameters)!
        } else {
            filter = CIFilter(name: filterName)!
        }
        //put the image in the filter
        filter.setValue(image, forKey: kCIInputImageKey)
        
        //make GPU context
        let options = [kCIContextWorkingColorSpace: NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        //output image comes back from filter
        let outputImage = filter.outputImage
        let extent = outputImage?.extent
        
        //take snapshot of image
        let cgImage = gpuContext.createCGImage(outputImage!, fromRect: extent!)
        
        let finalImage = UIImage(CGImage: cgImage)
        
        return finalImage
        
    }
    
    // MARK: Filters
    
    class func applyVintageEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String)->Void) {
        
        let filterName = "CIPhotoEffectTransfer"
        let displayName = "Vintage"
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyBWEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String)->Void) {
        
        let filterName = "CIPhotoEffectMono"
        let displayName = "Black and White"
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
    
    class func applyChromeEffect(image: UIImage, completion: (filteredImage: UIImage?, name: String)->Void) {
        
        let filterName = "CIPhotoEffectChrome"
        let displayName = "Chrome"
        
        let finalImage = self.setupFilter(filterName, parameters: nil, image: image)
        
        NSOperationQueue.mainQueue().addOperationWithBlock{ () -> Void in
            completion(filteredImage: finalImage, name: displayName)
        }
    }
}
