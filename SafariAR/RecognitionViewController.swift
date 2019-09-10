//
//  RecognitionViewController.swift
//  SafariAR
//
//  Created by Thor Remiendo on 31/08/2019.
//  Copyright © 2019 ZET. All rights reserved.
//

import UIKit
import CoreML
import Vision

class RecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var myPhoto: UIImageView!
    
    //var selectedImage = CIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            myPhoto.contentMode = .scaleToFill
            myPhoto.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        
        detectImageContent()
    }
    
    
    func detectImageContent(){
        lblResult.text = "Processing"
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("Failed to load model")
        }
        //create vision request
        let request = VNCoreMLRequest(model: model) {[weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
                else{
                    fatalError("Unexpected Results")
            }
            DispatchQueue.main.async { [weak self] in
                self?.lblResult.text = "\(topResult.identifier) with \(Int(topResult.confidence * 100))% confidence)"
            }
        }
        guard let ciImage = CIImage(image: self.myPhoto.image!)
            else { fatalError("Cant create CIImage from UIImage") }
        //Run the MobileNet
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global().async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
}
