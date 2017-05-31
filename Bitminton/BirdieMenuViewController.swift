//
//  BirdieMenuViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/24/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit
import CoreData


class birdieImage: NSManagedObject {
    
    @NSManaged var images: [UIImage]
    
}

class BirdieCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var birdieImage: UIImageView!
    
    
}

class BirdieMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var birdieCollection: UICollectionView!
    
    var birdieImages: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        birdieCollection.delegate = self
        birdieCollection.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        let swiftcolor = UIColor(red: 165/255, green: 222/255, blue: 255/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = swiftcolor
            
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Birdie")
            
        do{
            birdieImages = try context.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print("Failed to fetch")
        }
            
        print("Size of the fetched birdieImages Array \(birdieImages.count)" )
        
        let cellSize = CGSize(width:100 , height:100)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        birdieCollection.setCollectionViewLayout(layout, animated: true)
        
        birdieCollection.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return birdieImages.count
        
        
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Birdie")
        
        //learn to fetch
        do{
            birdieImages = try context.fetch(fetchRequest) as! [NSManagedObject]
        }
        catch{
            print("failed to fetch")
        }
        
        let birdieObject = birdieImages[indexPath.row]
        let birdieData = birdieObject.value(forKey: "birdieImage") as! NSData
        
        let birdieImage = UIImage(data: birdieData as Data, scale: 1.0)
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "birdieCell", for: indexPath as IndexPath) as! BirdieCollectionViewCell
        cell.birdieImage.image = birdieImage
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        let cell = collectionView.cellForItem(at: indexPath) as! BirdieCollectionViewCell
        let selectedImage = cell.birdieImage.image
        let selectedImageData: NSData = UIImageJPEGRepresentation(selectedImage!, 1.0)! as NSData
        
        let newImage = UIImage(named: "NewBirdie")
        let newImageData: NSData = UIImageJPEGRepresentation(newImage!, 1.0)! as NSData
        
        if selectedImageData .isEqual(to: newImageData as Data) {
            //perform segue to screen for new image adding
            self.performSegue(withIdentifier: "SelectAPhoto", sender: self)
        }
        else {
            //let user use selected birdie in gameplay
            
            defaults.set(selectedImageData, forKey: "currentPlayBirdie")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveImage(image: Data){
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Birdie", in: managedContext)!
        
        //entity.setValue(image, forKey: "birdieImage"\i)
        
        do {
            try managedContext.save()
            //birdieImages.append(birdie)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        /*
        let newImage = UIImage(named: "NewBirdie")
        let defaultImage = UIImage(named: "PlainBirdieYellow")
        let defaultImageData: NSData = UIImageJPEGRepresentation(defaultImage!, 1.0) as! NSData
        let newImageData: NSData = UIImageJPEGRepresentation(newImage!, 1.0) as! NSData
        
        let entity =  NSEntityDescription.insertNewObject(forEntityName: "Birdie", into: context)
        //entity.birdieImage1 = newImageData
        entity.setValue(newImageData, forKey: "birdieImage2")
        entity.setValue(defaultImageData, forKey: "birdieImage1")
 */
        
    }
    
    
    
}
//https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift
