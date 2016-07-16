//
//  MonsterViewController.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/15/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit

class MonsterViewController: UIViewController {
    
    var monster: Monster!
    
    @IBOutlet weak var monsterImage: UIImageView!
    @IBOutlet weak var monsterName: UILabel!
    var monsterNameText: String!
    @IBOutlet weak var spotterName: UILabel!
    var spotterNameText: String!
    @IBOutlet weak var totalVotes: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upVotes: UILabel!
    var upVotesValue: Int!
    @IBOutlet weak var downVotes: UILabel!
    var downVotesValue: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.monsterImage.image = UIImage(named: monster.imageName)
        self.monsterName.text = monster.title
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})

    }
    
    @IBAction func handleUpVote(sender: AnyObject) {
        
    }

    @IBAction func handleDownVote(sender: AnyObject) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
