//
//  AddWaypointViewController.swift
//  tripPlanner
//
//  Created by Andrei Lyskov on 10/23/15.
//  Copyright © 2015 Andrei Lyskov. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class AddWaypointViewController: UIViewController, UISearchBarDelegate {
    
    let googleServerAPIKey = "AIzaSyCBkrEAWTQGTUPWFQFTrDxgdrb7eJPT1tk"
    var trip:Trip!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(trip.tripName!)
        // Do any additional setup after loading the view.
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(initialLocation)
    }


    
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    //Do search logic here
        print("wow")
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        //take the input of the search bar, and convert to latitude/longitude numbers
        let locationSearch = searchBar.text!
        HTTPRequest(locationSearch)
        //retrieve core data object (waypoint) & save
        
        
        //increase count of waypoints
        
        //exit out of view controller
//        navigationController?.popViewControllerAnimated(true)
    }

    
 //GLOSS JSON PARSING library -> read through networking lecture -> transform
    
 //need to create a function here which calls an HTTP request to the server for more information on the GPS location
    //http://stackoverflow.com/questions/24016142/how-to-make-an-http-request-in-swift
    func HTTPRequest(locationSearch: String){
        // finding online http://stackoverflow.com/questions/24879659/how-to-encode-a-url-in-swift
        let locationSearch = locationSearch.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        if let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + locationSearch! + "&key=" + googleServerAPIKey){
            //TODO need to catch incorrect spelling of locations
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                let json = JSON(data: data!)
                let latitudeJSON = json["results"][0]["geometry"]["location"]["lat"].double!
                let longitudeJSON = json["results"][0]["geometry"]["location"]["lng"].double!
                let newLocation = CLLocation(latitude: latitudeJSON, longitude: longitudeJSON)
                self.centerMapOnLocation(newLocation)
            }
        
            task.resume()
        }
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
