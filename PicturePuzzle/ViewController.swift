//
//  ViewController.swift
//  PicturePuzzle
//
//  Created by mcalapatapu on 06/06/16.
//  Copyright © 2016 epam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var originalImageView: UIImageView!
    var imagesArray = [CGImageRef]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ShuffleTheImages(generateImagesFromImageView())
    }
    @IBOutlet weak var imagesContainerView: UIView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func testImageRect()
    {
        let cgimg = originalImageView.image!.CGImage!
        print(CGImageGetHeight(cgimg));
        print(CGImageGetWidth(cgimg));
    }
    
    func generateImagesFromImageView()->[CGImageRef]
    {
        //testImageRect()
        let cgimg = originalImageView.image!.CGImage!
        let imageHeight:CGFloat = CGFloat(CGImageGetHeight(cgimg))
        let imageWidth:CGFloat = CGFloat(CGImageGetWidth(cgimg))
        var x:CGFloat = 0.0, y:CGFloat = 0.0 , oW:CGFloat = imageWidth/3.0, oH:CGFloat = imageHeight/3.0;
        
        
        for index in 0..<9
        {
            print(index)
        let image = CGImageCreateWithImageInRect(originalImageView.image!.CGImage, CGRect(x: x, y: y, width: oW, height: oH))
            
            x = x+oW
            if x >= imageWidth
            {
                x = 0
                y = y+oH
            }
            
            imagesArray.append(image!)
            
                }
        return imagesArray.shuffle()
    }
    
    func ShuffleTheImages(randomImages:[CGImageRef])
    {
        
        var pX:CGFloat = 0.0, pY:CGFloat = 0.0, pW:CGFloat = imagesContainerView.frame.size.width/3.0 - 1.2, pH:CGFloat = imagesContainerView.frame.size.height/3.0 - 1.2
        
        
        for index in 0..<9
        {
        
        let imageView = UIImageView(frame: CGRectMake(pX, pY, pW, pH))
        
        let partOfImage = UIImage(CGImage: randomImages[index])
        imageView.image = partOfImage
        imageView.userInteractionEnabled = true
        imageView.contentMode = .ScaleToFill
            let panGesture = UIPanGestureRecognizer(target: self, action: Selector("dragPicture:"))
        imageView.addGestureRecognizer(panGesture)
        imagesContainerView.addSubview(imageView)
        
        pX = pX+pW+1.2
        if pX >= imagesContainerView.frame.size.width
        {
            pX = 0
            pY = pY+pH+1.2
        }
        }

    }
    
    
    func dragPicture(recognizer:UIPanGestureRecognizer)
    {
        print("Inside PanGesture Method")
        
        let touchPoint =  recognizer.locationInView(imagesContainerView)
        let width = recognizer.view?.frame.size.width
        let height = recognizer.view?.frame.size.height
        print(touchPoint)
        if touchPoint.x - (width!/2) > 0 && touchPoint.x + (width!/2) < imagesContainerView.frame.size.width && touchPoint.y - (height!/2) > 0 && touchPoint.y + (height!/2) < imagesContainerView.frame.size.height
        {
            
            print("Inside if")
            let actualCenter = recognizer.view?.center
            recognizer.view?.center = touchPoint
            imagesContainerView.bringSubviewToFront((recognizer.view)!)
            if(recognizer.state == .Ended)
            {
                for imgView in imagesContainerView.subviews {
                    if CGRectContainsPoint(imgView.frame, touchPoint) {
                        let tempFrame = imgView.frame
                        imgView.frame = (recognizer.view?.frame)!
                        recognizer.view?.frame = tempFrame
                    }
                }
            }
        }
    }
}
extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

