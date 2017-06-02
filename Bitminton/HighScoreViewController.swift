//
//  HighScoreViewController.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/23/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard



class scoreTableViewCell: UITableViewCell {
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var rankNumber: UILabel!
}

class HighScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var scoreTable: UITableView!
    
    
    var scoreArray = defaults.array(forKey: "scoreArray") as! [Int]
    var nameArray = defaults.array(forKey: "nameArray") as! [String]
    
    let tableCellidentifier = "scoreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scoreTable.delegate = self
        scoreTable.dataSource = self
        let swiftcolor = UIColor(red: 165/255, green: 222/255, blue: 255/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = swiftcolor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //maybe use if something is added to the table
        scoreArray = defaults.array(forKey: "scoreArray") as! [Int]
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoreTable.dequeueReusableCell(withIdentifier: tableCellidentifier, for: indexPath) as! scoreTableViewCell
        
        let row = indexPath.row
        var ranks: [String] = ["1.", "2.", "3.", "4.", "5.", "6.", "7.", "8.", "9.", "10.", "11.", "12.", "13."]
        
        cell.playerScoreLabel?.text = String(scoreArray[row])
        cell.rankNumber?.text = ranks[row]
        cell.playerNameLabel?.text = nameArray[row]
        
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
