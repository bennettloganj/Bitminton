//
//  HighScoreViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/23/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var scoreTable: UITableView!
    
    
    var scoreArray = defaults.array(forKey: "scoreArray") as! [Int]
    let tableCellidentifier = "scoreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scoreTable.delegate = self
        scoreTable.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //maybe use if something is added to the table
        scoreArray = defaults.array(forKey: "scoreArray") as! [Int]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoreTable.dequeueReusableCell(withIdentifier: tableCellidentifier, for: indexPath)
        
        let row = indexPath.row
        cell.textLabel?.text = String(scoreArray[row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scoreTable.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print(String(scoreArray[row]))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
