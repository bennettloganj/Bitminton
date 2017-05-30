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
    
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
        birdieCollection!.collectionViewLayout = layout
    }
    
    
}
//https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift
