//
//  ProfileViewController.swift
//  
//
//  Created by Andy Hadjigeorgiou on 7/15/16.
//
//

import UIKit
import SwiftyJSON
import Alamofire
import MapKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScore: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var monsters = [Monster]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // api
        self.userScore.text = ""
        self.userName.text = ""
        let prefs = NSUserDefaults.standardUserDefaults()

        if let name = prefs.stringForKey("name"){
            self.userName.text = name
        }
        getProfile()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        getProfile()
    }
    
    func getProfile() {
        Alamofire.request(.GET, "https://\(Constants.baseUrl).herokuapp.com/users/\(UIDevice.currentDevice().identifierForVendor!.UUIDString)", parameters: ["version": Constants.version])
            .response { request, response, data, error in
                var json = JSON(data: data!)
                NSLog(json.description)
                self.userName.text = json["user"]["name"].string
                var totalVotes = json["totalVotes"].int!
                self.userScore.text = String(totalVotes)
                if totalVotes >= 0 {
                    self.userScore.textColor = UIColor(red: 36.0/255, green: 164.0/255, blue: 83.0/255, alpha: 1.0)
                } else {
                    self.userScore.textColor = UIColor(red: 231.0/255, green: 43.0/255, blue: 30.0/255, alpha: 1.0)
                }
                var newMonsters = [Monster]()
                for (key,subJson) in json["monsters"] {
                    //Do something you want
                    let monster = Monster(id: Int(String(subJson["id"]))!,title: subJson["name"].string!,
                        locationName: "",
                        discipline: "",
                        //coordinate: self.currentLocation.coordinate)
                        coordinate: CLLocationCoordinate2DMake(Double(subJson["lat"].string!)!, Double(subJson["lng"].string!)!),
                        imageName: String(subJson["number"])+".png",
                        spotterName: self.userName.text!,
                        upVotes: Int(String(subJson["upVotes"]))!,
                        downVotes: Int(String(subJson["downVotes"]))!,
                        totalVotes: Int(String(subJson["totalVotes"]))!)
                    newMonsters.append(monster)
                }
                self.monsters = newMonsters
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monsters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MonsterTableViewCell", forIndexPath: indexPath) as! MonsterTableViewCell
        let monster = monsters[indexPath.row]
        cell.monsterName.text = monster.title
        cell.monsterImage.image = UIImage(named: monster.imageName)
        cell.monsterScore.text = String(monster.totalVotes)
        if monster.totalVotes >= 0 {
            cell.monsterScore.textColor = UIColor(red: 36.0/255, green: 164.0/255, blue: 83.0/255, alpha: 1.0)
        } else {
            cell.monsterScore.textColor = UIColor(red: 231.0/255, green: 43.0/255, blue: 30.0/255, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // remove the item from the data model
            hideMonster(self.monsters[indexPath.row].id)

            self.monsters.removeAtIndex(indexPath.row)
            
            // delete the table view row
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var monster = self.monsters[indexPath.row]
        let modalVC : MonsterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MonsterViewController") as! MonsterViewController
        modalVC.monster = monster
        self.presentViewController(modalVC, animated: true, completion: nil)
    }
    
    func hideMonster(id: Int) {
        Alamofire.request(.POST, "https://\(Constants.baseUrl).herokuapp.com/hide", parameters: ["monster_id": id,"version": Constants.version])
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
