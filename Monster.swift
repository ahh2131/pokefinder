import Foundation
import MapKit
import Contacts
class Monster: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let imageName: String
    let spotterName: String
    var upVotes: Int
    var downVotes: Int
    var totalVotes: Int
    let id: Int
    var voted: Bool
    
    init(id: Int, title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, imageName: String, spotterName: String, upVotes: Int, downVotes: Int, totalVotes: Int) {
        self.id = id
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.imageName = imageName
        self.spotterName = spotterName
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.totalVotes = totalVotes
        self.voted = false
        super.init()
    }
    
    class func fromJSON(json: [JSONValue]) -> Monster? {
        // 1
        var title: String
        if let titleOrNil = json[16].string {
            title = titleOrNil
        } else {
            title = ""
        }
        let locationName = json[12].string
        let discipline = json[15].string
        
        // 2
        let latitude = (json[18].string! as NSString).doubleValue
        let longitude = (json[19].string! as NSString).doubleValue

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // 3
        return Monster(id: 1, title: title, locationName: locationName!, discipline: discipline!, coordinate: coordinate, imageName: "", spotterName: "",
                       upVotes: 0,
                       downVotes: 0,
                       totalVotes: 0)
    }
    
    var subtitle: String? {
        return locationName
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {

        let addressDictionary = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}