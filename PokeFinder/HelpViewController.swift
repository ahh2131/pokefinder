//
//  HelpViewController.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/11/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate
{
    func sendSwitchValue(value: Bool)
}


class HelpViewController: UIViewController {
    
    @IBOutlet weak var switchButton: UISwitch!
    var delegate:SettingsViewControllerDelegate!
    var switchValue = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchButton.setOn(self.switchValue, animated: false)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.switchValue = switchButton.on
        delegate?.sendSwitchValue(self.switchValue)
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
