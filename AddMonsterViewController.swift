//
//  AddMonsterViewController.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/10/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate
{
    func sendValue(var value : String)
}

class AddMonsterViewController: UIViewController {

    @IBOutlet weak var monsterName: UITextField!
    var delegate:ModalViewControllerDelegate!

    @IBAction func cancelAdd(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitMonster(sender: AnyObject) {
        delegate?.sendValue(self.monsterName.text!)
        NSLog(self.monsterName.text!)
        self.dismissViewControllerAnimated(true, completion: {})
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
