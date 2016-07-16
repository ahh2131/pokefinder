import MapKit

extension ViewController: MKMapViewDelegate {
    
    // 1
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
        let modalVC : MonsterViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MonsterViewController") as! MonsterViewController
        modalVC.monster = monster
        //modalVC.delegate=self;
        self.presentViewController(modalVC, animated: true, completion: nil)
        //let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        //monster.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
    
    
}