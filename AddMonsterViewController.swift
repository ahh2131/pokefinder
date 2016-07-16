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
    func sendValue(var value : String, search: Bool)
}

class AddMonsterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var monsterName: UITextField!
    var delegate:ModalViewControllerDelegate!
    var chosenMonster = String()
    @IBOutlet weak var monsterPicker: UIPickerView!
    var search = false
    @IBOutlet weak var submitButton: UIButton!
    var submitButtonText: String!
    @IBOutlet weak var monsterHeader: UILabel!
    var monsterHeaderText: String!
    
    @IBAction func cancelAdd(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.setTitle(submitButtonText, forState: .Normal)
        self.monsterHeader.text = self.monsterHeaderText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitMonster(sender: AnyObject) {
        // TODO: is there a better way here? If empty, it's because they are tagging first value in the picker.
        if self.chosenMonster.isEmpty {
            self.chosenMonster = Constants.orderedMonsters[0]
        }
        delegate?.sendValue(self.chosenMonster, search: self.search)
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.orderedMonsters.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Constants.orderedMonsters[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chosenMonster = Constants.orderedMonsters[row]
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
