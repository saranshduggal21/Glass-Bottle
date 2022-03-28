//
//  ViewController.swift
//  Glass Bottle
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var userImageSelected: UIImageView!
    let objectImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objectImagePicker.delegate = self //Setting this class as the DELEGATE of the UIImagePickerController object.
        
    }
    

//MARK: - Camera Button Pressed Function
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        
    //Presenting camera + photo library choosing options in an alert form (ACTIONSHEET -> A sheet of actions (buttons, etc.)).
        
        let alert = UIAlertController(title: "Choose Picture", message: "Either take a photo or choose one from camera roll.", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { UIAlertAction in
            self.objectImagePicker.allowsEditing = true
            self.objectImagePicker.sourceType = .camera
            
            self.present(self.objectImagePicker, animated: true, completion: nil)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { UIAlertAction in
            self.objectImagePicker.allowsEditing = true
            self.objectImagePicker.sourceType = .photoLibrary
            self.present(self.objectImagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
//MARK: - UIImagePickerControllerDelegate Protocol Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { //"imagePicked" can be NIL if user doesn't pick an image so its being optionally binded.
    
            userImageSelected.contentMode = .scaleAspectFit
            userImageSelected.image = imagePicked
            
            guard let coreImage = CIImage(image: imagePicked) else { //Converting UIImage -> CIImage (Core Image image)
                fatalError("Unable to convert image selected into a CIImage.")
            }
            
            textDetection(selectedImage: coreImage)
        }
        
        objectImagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //This tells the delegate that the user CANCELLED their action of picking an image/taking a photo.
        dismiss(animated: true, completion: nil)
    }
    
    
//MARK: - Processing Barcode and Getting Results
    
    func textDetection(selectedImage image: CIImage) {
        do {
            
            //Image Handler -> Specifying the image that we want to classify.
            let imageHandler = VNImageRequestHandler(ciImage: image)
            
            //Image Request -> Requesting Vision to classify text
            let request = VNDetectBarcodesRequest { vnrequest, error in //Performing a Barcode Recognition request using Vision.
                let mlResults = vnrequest.results as? [VNBarcodeObservation] //Processing image and getting the results in the form of [VNBarcodeObservation]
                
                if let classifiedBarcode = mlResults?.first?.payloadStringValue {
                    //"classifiedBarcode" refers to the string value that represents the barcode payload (barcode number, QR code decrypter, driver license info, etc.).
                    
                    DispatchQueue.main.async {
                        self.navigationItem.title = classifiedBarcode
                    }
                }
            }
            
            //Performing & Processing Request
            try imageHandler.perform([request])
            
        }
        catch {
            print(error.localizedDescription)
        }
        
        
        
    }
}

