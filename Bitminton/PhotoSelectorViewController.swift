//
//  PhotoSelectorViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/30/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit
import CoreData

class PhotoSelectorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var currentImage: UIImageView!
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    }
    
    
    /*
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        currentImage.image = image
        self.dismiss(animated: true, completion: nil);
    }
 */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            currentImage.contentMode = .scaleAspectFit
            let image = self.fixOrientation(img: pickedImage)
            currentImage.image = image.circleMasked
            
        }
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let imageData = UIImagePNGRepresentation(currentImage.image!.circleMasked!)! as NSData
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity =  NSEntityDescription.insertNewObject(forEntityName: "Birdie", into: context) as! Birdie
        entity.birdieImage = imageData
        
        do{
            try context.save()
        } catch {
            print("Failed to save")
        }
        
        self.performSegue(withIdentifier: "backToBirdiesSegue", sender: self)
    }
    
    
    @IBAction func CameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func PhotoLibraryButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //stuff
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
