//
//  PhotoSelectorViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/30/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController {

    
    
    @IBAction func CameraButton(_ sender: UIButton) {
        
    }
    
    @IBAction func PhotoLibraryButton(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var currentImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
