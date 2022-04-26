//
//  ViewController.swift
//  Glass Bottle
//
//  Created by Saransh Duggal on 2022-02-27.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BarcodeAPIDelegate, IngredientAPIDelegate {
    
    @IBOutlet weak var userImageSelected: UIImageView!
    let objectImagePicker = UIImagePickerController()
    
    var barcodeAPIManager = BarcodeAPIManager()
    var ingredientAPIManager = IngredientsAPIManager()
    var userProductName = " "
    var ingredientsAPIURL = " "

//MARK: - BarcodeAPIDelegate Method
    func barcodeAPIData(parsedData data: BarcodeAPIModel) -> String {
        self.userProductName = data.productName
        ingredientsAPIURL = "https://skincare-api.herokuapp.com/product?q=\(userProductName)" //Link to Ingredients API JSON Data for scanned product.
        guard let finalURL = ingredientsAPIURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            fatalError("Unable to convert Ingredients API URL.")
        }
        self.ingredientAPIManager.getIngredientList(api: finalURL)
        print("The product name is \(self.userProductName)")
        print("Ingredient API URL: \(self.ingredientsAPIURL)")
        return ingredientsAPIURL
    }
    
//MARK: - IngredientAPIDelegate Method
    func ingredientAPIData(parsedData data: [String]) {
        print("Saransh")
        let userProductIngredients = data
        print("IngredientsAPIDelegate Method")
        print(userProductIngredients)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectImagePicker.delegate = self //Setting this class as the DELEGATE of the UIImagePickerController object.
        barcodeAPIManager.delegate = self
        ingredientAPIManager.delegate = self
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
            
            barcodeDetection(selectedImage: coreImage)
        }
        
        objectImagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //This tells the delegate that the user CANCELLED their action of picking an image/taking a photo.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Processing Barcode and Getting Product Results
    
    func barcodeDetection(selectedImage image: CIImage) {
        do {
            
            //Image Handler -> Specifying the image that we want to classify.
            let imageHandler = VNImageRequestHandler(ciImage: image)
            
            //Image Request -> Requesting Vision to classify text
            let request = VNDetectBarcodesRequest { vnrequest, error in //Performing a Barcode Recognition request using Vision.
                let mlResults = vnrequest.results as? [VNBarcodeObservation] //Processing image and getting the results in the form of [VNBarcodeObservation]
                
                if let classifiedBarcode = mlResults?.first?.payloadStringValue {
                    //"classifiedBarcode" refers to the string value that represents the barcode payload (barcode number, QR code decrypter, driver license info, etc.).
                    
            //MARK: - Requesting Product Data from Barcode API
                    
                    let barcodeAPIURL = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(classifiedBarcode)" //Link to Barcode API JSON Data for scanned product.
                    print("Barcode URL Ready")
                    
                    self.barcodeAPIManager.getProductData(using: barcodeAPIURL)
                    
                        DispatchQueue.main.async {
                            
                            
                            
                            
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

