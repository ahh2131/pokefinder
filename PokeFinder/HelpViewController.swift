//
//  HelpViewController.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/11/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit
import Alamofire
import AirshipKit

protocol SettingsViewControllerDelegate
{
    func sendSwitchValue(value: Bool, type: String)
}


class HelpViewController: UIViewController, ModalViewControllerDelegate {
    
    @IBOutlet weak var switchButton: UISwitch!
    var delegate:SettingsViewControllerDelegate!
    var switchValue = false
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBOutlet weak var monster1: UILabel!
    @IBOutlet weak var monster2: UILabel!
    @IBOutlet weak var monster3: UILabel!
    @IBOutlet weak var ratedSwitch: UISwitch!
    var ratedSwitchValue = false
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var selectedButton = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.switchButton.setOn(self.switchValue, animated: false)
        let prefs = NSUserDefaults.standardUserDefaults()
        if prefs.boolForKey("notification") {
            toggleMonsterChoices(true)
            self.notificationSwitch.setOn(true, animated: false)
        } else {
            toggleMonsterChoices(false)
            self.notificationSwitch.setOn(false, animated: false)
        }

        self.ratedSwitch.setOn(self.ratedSwitchValue, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleNotificationSwitch(sender: AnyObject) {
        let prefs = NSUserDefaults.standardUserDefaults()

        toggleMonsterChoices(notificationSwitch.on)
        if notificationSwitch.on {
            // enable notifications (api call)
            UAirship.push().userPushNotificationsEnabled = true
            var channelID = prefs.valueForKey("channelID") as? String
            if (channelID == nil) {
                prefs.setValue(UAirship.push().channelID, forKey: "channelID")
                channelID = UAirship.push().channelID
                Alamofire.request(.POST, "https://\(Constants.baseUrl).herokuapp.com/update_channel_id", parameters: ["version": Constants.version, "uuid": UIDevice.currentDevice().identifierForVendor!.UUIDString, "channel_id": channelID!])
            }
        } else {
            // disable notifications (api call)
            Alamofire.request(.POST, "https://\(Constants.baseUrl).herokuapp.com/remove_notifications", parameters: ["version": Constants.version, "uuid": UIDevice.currentDevice().identifierForVendor!.UUIDString])
        }
    }
    
    func sendValue(value: String, search: Bool) {
        // send to api
        let prefs = NSUserDefaults.standardUserDefaults()
        NSLog(selectedButton.description)
        var oldMonster = ""
        if selectedButton == 0 {
            oldMonster = monster1.text!
            prefs.setValue(value, forKey: "monster1")
            monster1.text = value
        } else if selectedButton == 1 {
            oldMonster = monster2.text!
            prefs.setValue(value, forKey: "monster2")
            monster2.text = value
        } else if selectedButton == 2 {
            oldMonster = monster3.text!
            prefs.setValue(value, forKey: "monster3")
            monster3.text = value
        }
        // api call with old monster and new monster
        Alamofire.request(.POST, "https://\(Constants.baseUrl).herokuapp.com/replace_notification", parameters: ["version": Constants.version, "uuid": UIDevice.currentDevice().identifierForVendor!.UUIDString, "remove": oldMonster, "add": value])
    }
    
    @IBAction func handleButton1(sender: AnyObject) {
        selectedButton = 0
        sendToAddMonsterView()
    }
    
    @IBAction func handleButton2(sender: AnyObject) {
        selectedButton = 1
        sendToAddMonsterView()
    }
    
    @IBAction func handleButton3(sender: AnyObject) {
        selectedButton = 2
        sendToAddMonsterView()
    }
    
    func sendToAddMonsterView()
    {
        let modalVC : AddMonsterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddMonsterViewController") as! AddMonsterViewController
        
        modalVC.submitButtonText = "Choose"
        modalVC.monsterHeaderText = "Get a notification when it's nearby!"
        modalVC.delegate = self
        self.presentViewController(modalVC, animated: true, completion: nil)
    }
    
    func toggleMonsterChoices(on: Bool) {
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setBool(on, forKey: "notification")
        if on {
            if let monster1Name = prefs.valueForKey("monster1") as? String {
                self.monster1.text = monster1Name
            }
            if let monster2Name = prefs.valueForKey("monster2") as? String {
                self.monster2.text = monster2Name
            }
            if let monster3Name = prefs.valueForKey("monster3") as? String {
                self.monster3.text = monster3Name
            }
            
            monster1.enabled = true
            monster2.enabled = true
            monster3.enabled = true
            button1.enabled = true
            button2.enabled = true
            button3.enabled = true
            
        } else {
            // call to api to remove all
            prefs.removeObjectForKey("monster1")
            prefs.removeObjectForKey("monster2")
            prefs.removeObjectForKey("monster3")
            monster1.text = "Monster 1"
            monster2.text = "Monster 2"
            monster3.text = "Monster 3"
            monster1.enabled = false
            monster2.enabled = false
            monster3.enabled = false
            button1.enabled = false
            button2.enabled = false
            button3.enabled = false
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.ratedSwitchValue = ratedSwitch.on
        delegate?.sendSwitchValue(self.ratedSwitchValue, type: "rated")
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
