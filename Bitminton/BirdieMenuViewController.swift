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

class BirdieMenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var birdieCollection: UICollectionView!
    
    var birdieImages: [NSManagedObject] = []
    
    var currentBirdieIndex: Int = 1
    var lastBirdieIndex: Int = 0
    
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
        
        let cellSize = CGSize(width:120 , height:120)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        birdieCollection.setCollectionViewLayout(layout, animated: true)
        
        birdieCollection.reloadData()
        
        currentBirdieIndex = defaults.integer(forKey: "currentBirdieIndex")
        
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
        let swiftcolor = UIColor(red: 165/255, green: 222/255, blue: 255/255, alpha: 1.0)
        let colorClear = UIColor.clear
        
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
        
        cell.birdieImage.image = birdieImage?.circleMasked
        
        cell.birdieImage.layer.borderWidth=1.0
        cell.birdieImage.layer.masksToBounds = false
        cell.birdieImage.layer.borderColor = UIColor.white.cgColor
        cell.birdieImage.layer.cornerRadius = cell.birdieImage.frame.size.height/2
        cell.birdieImage.clipsToBounds = true
        
        
        cell.birdieImage.layer.shadowColor = swiftcolor.cgColor
        cell.birdieImage.layer.shadowOpacity = 1
        cell.birdieImage.layer.shadowOffset = CGSize(width: -12, height: -12)
        cell.birdieImage.layer.shadowRadius = 7
        cell.birdieImage.layer.borderWidth = 3
        cell.birdieImage.layer.borderColor = colorClear.cgColor
        cell.birdieImage.layer.masksToBounds = true
        cell.birdieImage.layer.shadowPath = UIBezierPath(roundedRect: cell.birdieImage.frame, cornerRadius: 50).cgPath
        
        
        
        if indexPath.item == currentBirdieIndex{
            cell.birdieImage.layer.masksToBounds = false
            cell.birdieImage.layer.borderColor = swiftcolor.cgColor
        }else{
            cell.birdieImage.layer.borderColor = colorClear.cgColor
            cell.birdieImage.layer.masksToBounds = true
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 100, height: 100)
        return size
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        let cell = collectionView.cellForItem(at: indexPath) as! BirdieCollectionViewCell
        let selectedImage = cell.birdieImage.image
        let selectedImageData: NSData = UIImageJPEGRepresentation(selectedImage!, 1.0)! as NSData
        let swiftcolor = UIColor(red: 165/255, green: 222/255, blue: 255/255, alpha: 1.0)
        
        lastBirdieIndex = currentBirdieIndex
        
        if indexPath.item == 0 {
            //perform segue to screen for new image adding
            self.performSegue(withIdentifier: "SelectAPhoto", sender: self)
        }
        else {
            //let user use selected birdie in gameplay
            
            
            defaults.set(selectedImageData, forKey: "currentPlayBirdie")
            defaults.set(indexPath.item, forKey: "currentBirdieIndex")
            currentBirdieIndex = indexPath.item
            
            if indexPath.item == currentBirdieIndex {
                cell.birdieImage.layer.masksToBounds = false
                cell.birdieImage.layer.borderColor = swiftcolor.cgColor
            }
        }
        
        birdieCollection.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
//https://turbofuture.com/cell-phones/Access-Photo-Camera-and-Library-in-Swift
