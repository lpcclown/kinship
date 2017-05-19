//
//  ViewController.swift
//  Detector
//
//  Created by Gregg Mojica on 8/21/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    @IBOutlet weak var personPic: UIImageView!
    
    @IBOutlet weak var selectFirstPhotoButton: UIButton!
    @IBOutlet weak var takeFirstPhotoButton: UIButton!
    @IBOutlet weak var selectSecondPhotoButton: UIButton!
    @IBOutlet weak var takeSecondPhotoButton: UIButton!
    @IBOutlet weak var compareResultButton: UIButton!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    
    var flag = "";
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectFirstPhoto(_ sender: Any) {
        flag = "firstPic";
        
        //remove previous detected face rectangle
        for view in firstImageView.subviews {
            view.removeFromSuperview()
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self;
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    
    @IBAction func takeFirstPhoto(_ sender: Any) {
        
        flag = "firstPic";
        //remove previous detected face rectangle
        for view in firstImageView.subviews {
            view.removeFromSuperview()
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self;
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func selectSecondPhoto(_ sender: Any) {
        flag = "secondPic";
        
        //remove previous detected face rectangle
        for view in secondImageView.subviews {
            view.removeFromSuperview()
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self;
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
 
    @IBAction func takeSecondPhoto(_ sender: Any) {
        
        flag = "secondPic";
        //remove previous detected face rectangle
        for view in secondImageView.subviews {
            view.removeFromSuperview()
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self;
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func comparResult(_ sender: Any) {
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: NSArray!){
        self.dismiss(animated: true, completion: { () -> Void in
        })
        if (flag == "firstPic"){
            firstImageView.image = image;
            detect()}
        else if (flag == "secondPic"){
            secondImageView.image = image;
            detect()}
    }
    
    
    
    func detect() {
        
        if (flag == "firstPic"){
            personPic = firstImageView;
        }
        else if (flag == "secondPic"){
            personPic = secondImageView;
        }
        
        guard let personciImage = CIImage(image: personPic.image!) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        // Convert Core Image Coordinate to UIView Coordinate
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            
            print("Found bounds are \(face.bounds)")
            
            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = personPic.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.red.cgColor
            faceBox.backgroundColor = UIColor.clear
            
            personPic.addSubview(faceBox)

            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
    }
    
}
