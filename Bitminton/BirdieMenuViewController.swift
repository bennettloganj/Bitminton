//
//  BirdieMenuViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/24/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit
import CoreData

class BirdieCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var birdieImage: UIImageView!
    
    
}

class BirdieMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var birdieCollection: UICollectionView!
    
    var birdieImages: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let swiftcolor = UIColor(red: 165/255, green: 222/255, blue: 255/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = swiftcolor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let birdie = birdieImages[indexPath.row]
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "birdieCollectionCell", for: indexPath as IndexPath) as! BirdieCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.birdieImage.image = birdie.value(forKey: "birdieImage") as? UIImage
        //
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveImage(image: Data){
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Birdie", in: managedContext)!
        
        let birdie = NSManagedObject(entity: entity, insertInto: managedContext)
        
        birdie.setValue(image, forKeyPath: "birdieImage")
        
        do {
            try managedContext.save()
            birdieImages.append(birdie)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
}
//https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift
