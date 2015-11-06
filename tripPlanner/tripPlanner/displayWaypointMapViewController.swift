//
//  displayWaypointMapViewController.swift
//  tripPlanner
//
//  Created by Andrei Lyskov on 11/4/15.
//  Copyright © 2015 Andrei Lyskov. All rights reserved.
//

import UIKit
import MapKit

class displayWaypointMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitutdeLabel: UILabel!
    var currentWaypoint:Waypoint!
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentWaypoint)
        
        self.title = currentWaypoint.waypointName!
        let latitude = currentWaypoint.latitude!
        let longitude = currentWaypoint.longitude!
        let initialLocation = CLLocation(latitude: Double(latitude), longitude: Double(longitude))
        centerMapOnLocation(initialLocation)
        
        longitutdeLabel.text = "Longitutde " + String(longitude)
        latitudeLabel.text = "Latitude " + String(latitude)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
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
