//
//  MonsterViewController.swift
//  PokeFinder
//
//  Created by Andy Hadjigeorgiou on 7/15/16.
//  Copyright © 2016 Andy Hadjigeorgiou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class MonsterViewController: UIViewController, MKMapViewDelegate {
    
    var monster: Monster!
    
    @IBOutlet weak var monsterImage: UIImageView!
    @IBOutlet weak var monsterName: UILabel!
    @IBOutlet weak var spotterName: UILabel!
    @IBOutlet weak var totalVotes: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var upVotes: UILabel!
    @IBOutlet weak var downVotes: UILabel!
    var monsterId: Int!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.monsterImage.image = UIImage(named: monster.imageName)
        self.monsterName.text = monster.title
        self.spotterName.text = monster.spotterName
        self.monsterId = monster.id
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.addAnnotation(monster)
        centerMapOnMonster()
        setVotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnMonster() {
        let center = CLLocationCoordinate2D(latitude: monster.coordinate.latitude, longitude: monster.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func handleBackButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})

    }
    
    @IBAction func handleUpVote(sender: AnyObject) {
        if !monster.voted {
            sendVote("up")
            monster.voted = true
            monster.upVotes += 1
            setVotes()
        }
    }

    @IBAction func handleDownVote(sender: AnyObject) {
        if !monster.voted {
            sendVote("down")
            monster.voted = true
            monster.downVotes += 1
            setVotes()
        }
    }
    
    func setVotes() {
        self.upVotes.text = String(monster.upVotes)
        self.downVotes.text = String(monster.downVotes)
        let totalVotes = monster.upVotes - monster.downVotes
        self.totalVotes.text = String(totalVotes)
        if totalVotes > 0 {
            self.totalVotes.textColor = self.upVotes.textColor
        } else {
            self.totalVotes.textColor = self.downVotes.textColor
        }
    }
    
    func sendVote(vote: String) {
        Alamofire.request(.POST, "https://\(Constants.baseUrl).herokuapp.com/vote", parameters: ["uuid": UIDevice.currentDevice().identifierForVendor!.UUIDString, "monster_id": self.monsterId, "vote": vote, "version": Constants.version])
                
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? Monster {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type:.DetailDisclosure) as! UIView
                
            }
            view.canShowCallout = true
            view.image = UIImage(named: annotation.imageName)
            
            return view
        }
        return nil
    }
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
                 calloutAccessoryControlTapped control: UIControl!) {
        
        var monster = view.annotation as! Monster

        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        monster.mapItem().openInMapsWithLaunchOptions(launchOptions)
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
