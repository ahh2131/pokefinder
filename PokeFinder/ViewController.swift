//
//  ViewController.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/10/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, ModalViewControllerDelegate {
    var Monsters = [Monster]()
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    let regionRadius: CLLocationDistance = 1000
    @IBOutlet weak var mapView: MKMapView!
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func sendValue(value: String) {
        centerMapOnLocation(self.currentLocation)
        let monster = Monster(title: value,
                               locationName: "Waikiki Gateway Park",
                               discipline: "Sculpture",
                               coordinate: self.currentLocation.coordinate)
        mapView.addAnnotation(monster)
        // make api call to tell server to add a pin
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        self.currentLocation = location
        NSLog(location.description)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
        mapView.delegate = self
        loadInitialData()
        mapView.addAnnotations(Monsters)

       // mapView.addAnnotation(Monster)
        locationManager.startUpdatingLocation()

    }

    @IBAction func addMonsterButton(sender: AnyObject) {
        let modalVC : AddMonsterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddMonsterViewController") as! AddMonsterViewController

        modalVC.delegate=self;
        self.presentViewController(modalVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleCenterButton(sender: AnyObject) {
        centerMapOnLocation(self.currentLocation)
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        // api call
    }
    
    func loadInitialData() {
        // api call
        // 1
        let fileName = NSBundle.mainBundle().pathForResource("PublicArt", ofType: "json");
        //    var readError : NSError?
        var data: NSData?
        do {
            data = try NSData(contentsOfFile: fileName!, options: NSDataReadingOptions(rawValue: 0))
        } catch _ {
            data = nil
        }
        
        // 2
        //    var error: NSError?
        var jsonObject: AnyObject? = nil
        if let data = data {
            do {
                jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            } catch _ {
                jsonObject = nil
            }
        }
        
        // 3
        if let jsonObject = jsonObject as? [String: AnyObject],
            // 4
            let jsonData = JSONValue.fromObject(jsonObject)?["data"]?.array {
            for MonsterJSON in jsonData {
                if let MonsterJSON = MonsterJSON.array,
                    // 5
                    Monster = Monster.fromJSON(MonsterJSON) {
                    Monsters.append(Monster)
                }
            }
        }
    }

}

