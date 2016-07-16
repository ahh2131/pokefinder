//
//  ViewController.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/10/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, ModalViewControllerDelegate, CLLocationManagerDelegate, UISearchBarDelegate, SettingsViewControllerDelegate {
    var Monsters = [Monster]()
    var searchedMonster = [Monster]()
    var searchedMonsterName = String()
    var recentMonsters = [Monster]()
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = false
    var switchValue = false
    var ratedSwitchValue = false
    var uuid = String()
    var name = String()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func displayAllMonsters() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(self.Monsters)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            displayAllMonsters()
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if ((searchBar.text?.isEmpty) != nil) {
            if (self.searchedMonsterName.isEmpty) {
                searchBar.endEditing(true)
                let modalVC : AddMonsterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddMonsterViewController") as! AddMonsterViewController
                modalVC.search = true
                modalVC.delegate=self
                modalVC.monsterHeaderText="Looking for a monster?"
                modalVC.submitButtonText = "Search"
                self.presentViewController(modalVC, animated: true, completion: nil)
            } else {
                self.searchedMonsterName = ""
            }
        }
        return false
    }
    
    func searchMonster(name: String) {
        if (!name.isEmpty) {
            Alamofire.request(.GET, "https://\(Constants.baseUrl).herokuapp.com/search/\(name)?lat=\(self.currentLocation.coordinate.latitude)&lng=\(self.currentLocation.coordinate.longitude)&recent=\(self.switchValue)")
                .response { request, response, data, error in
                    self.searchedMonster = []
                    var json = JSON(data: data!)
                    for (key,subJson):(String, JSON) in json {
                        //Do something you want
                        let monster = Monster(id: Int(String(subJson["id"]))!,title: subJson["name"].string!,
                            locationName: "",
                            discipline: "",
                            //coordinate: self.currentLocation.coordinate)
                            coordinate: CLLocationCoordinate2DMake(Double(subJson["lat"].string!)!, Double(subJson["lng"].string!)!),
                            imageName: String(subJson["number"])+".png",
                            spotterName: subJson["spotterName"].string!,
                            upVotes: Int(String(subJson["upVotes"]))!,
                            downVotes: Int(String(subJson["downVotes"]))!)
                        self.searchedMonster.append(monster)
                    }
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(self.searchedMonster)
            }
        }
    }
    
    func sendValue(value: String, search: Bool) {
        // allows us to use add monster view controller for both adding and searching
        if search {
            self.searchedMonsterName = value
            self.searchBar.text = value
            searchMonster(value)
            searchBar.endEditing(true)
            
        } else {
            centerMapOnLocation(self.currentLocation)
            let monster = Monster(id: getPokemonNumber(value),
                                  title: value,
                                  locationName: "",
                                  discipline: "",
                                  coordinate: self.currentLocation.coordinate,
                                  imageName: (getPokemonNumber(value).description) + ".png",
                                  spotterName: "",
                                  upVotes: 0,
                                  downVotes: 0)
            mapView.addAnnotation(monster)
            // make api call to tell server to add a pin
            let parameters = [
                "monster": [
                    "name": value,
                    "lat": self.currentLocation.coordinate.latitude,
                    "lng": self.currentLocation.coordinate.longitude
                ],
                "uuid": self.uuid
            ]
            Alamofire.request(.POST, "https://\(Constants.baseUrl).herokuapp.com/monsters", parameters: parameters as! [String : AnyObject])
            
            //getMonsters(true)
        }
    }
    
    func getPokemonNumber(name: String) -> Int {
        var index = Constants.monsters.indexOf(name)
        if index >= 31 {
            index = index! + 2
        } else {
            index = index! + 1
        }
        return index!
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let location = newLocation 
        self.currentLocation = location
        if (!self.initialLocation) {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            self.getMonsters(true)
            self.mapView.setRegion(region, animated: true)
            self.initialLocation = true
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
        showNameAlert()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMake(location.coordinate, mapView.region.span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uuid = UIDevice.currentDevice().identifierForVendor!.UUIDString
        mapView.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        getMonsters(true)
        checkLocationAuthorizationStatus()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        showNameAlert()

    }
    
    func showNameAlert() {
        let prefs = NSUserDefaults.standardUserDefaults()
        if let name = prefs.stringForKey("name"){
            self.name = name
        }else{
            var inputTextField: UITextField?
            let passwordPrompt = UIAlertController(title: "Welcome to PokeFinder", message: "Please enter your Pokemon GO username so we can get started.", preferredStyle: UIAlertControllerStyle.Alert)
            passwordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                // Now do whatever you want with inputTextField (remember to unwrap the optional)
                if (inputTextField?.text == "" || inputTextField?.text!.characters.count > 16) {
                    self.showNameAlert()
                } else {
                    self.name = (inputTextField?.text)!
                    prefs.setValue(self.name, forKey: "name")
                    Alamofire.request(.POST, "https://\(Constants.baseUrl).herokuapp.com/users", parameters: ["user": ["name": self.name, "uuid": self.uuid]])
                }
            }))
            passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Name"
                textField.secureTextEntry = false
                inputTextField = textField
            })
            
            presentViewController(passwordPrompt, animated: true, completion: nil)

        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchBar.endEditing(true)
    }

    @IBAction func settingsButton(sender: AnyObject) {
        let modalVC : HelpViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
        modalVC.switchValue = self.switchValue
        modalVC.ratedSwitchValue = self.ratedSwitchValue
        modalVC.delegate=self;
        self.presentViewController(modalVC, animated: true, completion: nil)
    }
    
    func sendSwitchValue(value: Bool, type: String) {
        if type == "recent" {
            self.switchValue = value
        } else {
            self.ratedSwitchValue = value
        }
        
        getMonsters(true)
    }
    
    @IBAction func addMonsterButton(sender: AnyObject) {
        let modalVC : AddMonsterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddMonsterViewController") as! AddMonsterViewController

        modalVC.delegate=self;
        modalVC.submitButtonText = "Add"
        modalVC.monsterHeaderText = "Found a monster? Add it!"

        self.presentViewController(modalVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleProfileButton(sender: AnyObject) {
        let modalVC : ProfileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        
       // modalVC.delegate=self;
        self.presentViewController(modalVC, animated: true, completion: nil)
    }
    
    @IBAction func handleCenterButton(sender: AnyObject) {
        centerMapOnLocation(self.currentLocation)
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        // api call
        getMonsters(true)
    }
    
    func getMonsters(reload: Bool) {
        if (reload || self.Monsters.count == 0) {
            NSLog(Constants.baseUrl);
            Alamofire.request(.GET, "https://\(Constants.baseUrl).herokuapp.com", parameters: ["lat": self.currentLocation.coordinate.latitude, "lng": self.currentLocation.coordinate.longitude, "recent": self.switchValue.description, "uuid": self.uuid, "rated": self.ratedSwitchValue])
                .response { request, response, data, error in
                    var json = JSON(data: data!)
                    for (key,subJson):(String, JSON) in json {
                        //Do something you want
                        let monster = Monster(id: subJson["id"].intValue,title: subJson["name"].string!,
                            locationName: "",
                            discipline: "",
                            //coordinate: self.currentLocation.coordinate)
                            coordinate: CLLocationCoordinate2DMake(Double(subJson["lat"].string!)!, Double(subJson["lng"].string!)!),
                            imageName: String(subJson["number"])+".png",
                            spotterName: subJson["spotterName"].string!,
                            upVotes: subJson["upVotes"].intValue,
                            downVotes: subJson["downVotes"].intValue)
                        if (self.switchValue) {
                            self.recentMonsters.append(monster)
                        } else {
                            self.Monsters.append(monster)
                        }
                    }
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    if (self.switchValue) {
                        self.mapView.addAnnotations(self.recentMonsters)
                    } else {
                        self.mapView.addAnnotations(self.Monsters)

                    }
            }
        }
    }

}

