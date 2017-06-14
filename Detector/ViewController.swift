//
//  ViewController.swift
//  Detector
//
//  Created by Gregg Mojica on 8/21/16.
//  Copyright © 2016 Gregg Mojica. All rights reserved.
//

import UIKit
import CoreImage
import MobileCoreServices

extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

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
        
        createRequest(userid: "abc", password: "password", email: "mail@cc.edu")
        
    }
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The NSURLRequest that was created
    
    func createRequest(userid: String, password: String, email: String) {
        let parameters = [
            "user_id"  : userid,
            "email"    : email,
            "password" : password]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: "http://104.55.84.205/index.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        let imageData = UIImageJPEGRepresentation(firstImageView.image!, 1)
        if (imageData == nil) {print("tttttttt")}
        request.httpBody = createBody(with: parameters, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            print (response!)
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    func createBody(with parameters: [String: String]?, filePathKey: String, imageDataKey: NSData, boundary: String) -> NSData {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        
        //let url = URL(fileURLWithPath: path)
        let filename = "user-profile.JPG"
        //let data = try Data(contentsOf: url)
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        //body.append(String(data:imageDataKey as Data, encoding: String.Encoding.utf8)!)
        body.append(imageDataKey.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue: 0)))
        body.append("\r\n")
        
        body.append("--\(boundary)--\r\n")
        print(body)
        return body as NSData
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeType(for path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
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
