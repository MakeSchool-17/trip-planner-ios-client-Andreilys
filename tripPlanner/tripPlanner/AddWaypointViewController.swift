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
import CoreData

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
        // Do any additional setup after loading the view.
        let initialLocation = CLLocation(latitude: 0, longitude: 0)
        centerMapOnLocation(initialLocation)
    }


    
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func HTTPRequest(locationSearch: String) {
        
        let locationSearch = locationSearch.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        if let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + locationSearch! + "&key=" + googleServerAPIKey){
            //TODO need to catch incorrect spelling of locations
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                let json = JSON(data: data!)
                let latitudeJSON = json["results"][0]["geometry"]["location"]["lat"].double!
                let longitudeJSON = json["results"][0]["geometry"]["location"]["lng"].double!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saveCoreData(latitudeJSON,longitudeJSON: longitudeJSON, waypointName: locationSearch!)
                })
            }
        
            task.resume()
        }
    }
    
    func saveCoreData(latitudeJSON: Double, longitudeJSON: Double, waypointName: String){
        //need to instantiate waypoint entity and save long/lat. also link it to current trip entity
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Waypoint", inManagedObjectContext: managedContext)
        
        let waypoint = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Waypoint
        
        waypoint.setValue(latitudeJSON, forKey: "latitude")
        waypoint.setValue(longitudeJSON, forKey: "longitude")
        waypoint.setValue(waypointName, forKey: "waypointName")
        waypoint.tripRelationship = trip
        
        print(latitudeJSON)
        do {
            try managedContext.save()
            //popup success
            let alert = UIAlertController(title: "New Waypoint", message: "New waypoint was added successfully! Feel free to add more.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK",
                style: .Default) { (action: UIAlertAction) -> Void in
            }
            alert.addAction(okAction)
            self.presentViewController(alert,
                animated: true,
                completion: nil)
            //
            let initialLocation = CLLocation(latitude: latitudeJSON, longitude: longitudeJSON)
            centerMapOnLocation(initialLocation)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
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
