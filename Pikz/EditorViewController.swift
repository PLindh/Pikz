//
//  EditorViewController.swift
//  Pikz
//
//  Created by Plindh on 4/13/17.
//  Copyright © 2017 JPJ. All rights reserved.
//

import UIKit
import CoreImage

class EditorViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SHViewControllerDelegate {
    
    @IBOutlet var pinchLabel: UILabel!
    @IBOutlet var pinchButton: UIButton!
    @IBOutlet var pinchView: UIView!
    @IBOutlet var pinchImage: UIImageView!


    @IBOutlet var theImage: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewSize: UIView!
    
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    
    
    var originalImage : UIImage!
  
     var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinchButton.isEnabled = false
        pinchButton.alpha = 0.0
        pinchLabel.alpha = 0.0
        pinchImage.alpha = 0.0
        //--- ScrollView Configuration ---
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
     
        self.scrollView.contentMode = .scaleAspectFit//
        self.theImage.sizeToFit()
        self.scrollView.contentSize = CGSize(width: self.theImage.frame.size.width, height: self.theImage.frame.size.height)
        
        let imageViewSize = self.theImage.bounds.size
        let scrollViewSize = self.scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        let minZoomScale = min(widthScale, heightScale)
        self.scrollView.minimumZoomScale = minZoomScale
        self.scrollView.zoomScale = minZoomScale
        self.scrollView.contentSize = theImage.bounds.size//
        
      var  image = theImage.image
        theImage.bounds = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        scrollView.contentSize = (image?.size)!
        
        red = (0.0/255.0)
        green = (0.0/255.0)
        blue = (0.0/255.0)
        
        setZoomScale()
        //---------------------------------
    }
    
    //Camera and Save Button
    
    //---------------------------------------------------------------------
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return theImage
    }
    
    func setZoomScale() {
        let imageViewSize = theImage.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 0.1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onCameraRollTapped(_ sender: UIButton) {
        let pkcrviewUI = UIImagePickerController()
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            pkcrviewUI.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pkcrviewUI.allowsEditing = false
            pkcrviewUI.delegate = self
            [self .present(pkcrviewUI, animated: true , completion: nil)]
        }
    }
    
    @IBAction func imageFilterButtonTapped(_ sneder : UIButton){
        let imageToBeFiltered = theImage.image!
        originalImage = theImage.image!
        let vc = SHViewController(image: imageToBeFiltered)
        vc.delegate = self
        self.present(vc, animated:true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            theImage.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            theImage.image = image
        } else {
            theImage.image = nil
        }
    }
    
   
    @IBAction func onSaveTapped(_ sender: UIButton) {
        screenShotMethod()
        let alert = UIAlertView(title: "Nice!",
                                message: "Your image has been saved to your photos",
                                delegate: nil,
                                cancelButtonTitle: "Ok")
        alert.show()
    }
    
    //Tools
    
    //--------------------------------------------------------------------------------
    @IBAction func onFilterToolTapped(_ sender: UIButton) {
        //API
    }
    //--------------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------------
    @IBAction func onCropToolTapped(_ sender: UIButton) {
        pinchButton.alpha = 1.0
        pinchLabel.alpha = 1.0
        pinchImage.alpha = 1.0
        pinchView.alpha = 0.8
        
        pinchButton.isEnabled = true
    }
    
    @IBAction func onPinchButtonTapped(_ sender: UIButton) {
        pinchButton.alpha = 0.0
        pinchLabel.alpha = 0.0
        pinchView.alpha = 0.0
        pinchImage.alpha = 0.0
        pinchButton.isEnabled = false
    }
//--------------------------------------------------------------------------------
    
    func shViewControllerImageDidFilter(image: UIImage) {
        // Filtered image will be returned here.
        theImage.image  = image
    }
    
    func shViewControllerDidCancel() {
        // This will be called when you cancel filtering the image.
        theImage.image = originalImage
    }
    
    func screenShotMethod() {
        let size = CGSize(width: 375, height: 375)
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        viewSize.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    
}

