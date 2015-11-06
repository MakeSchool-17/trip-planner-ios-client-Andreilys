//
//  WaypointsTableViewController.swift
//  tripPlanner
//
//  Created by Andrei Lyskov on 10/29/15.
//  Copyright © 2015 Andrei Lyskov. All rights reserved.
//

import UIKit
import CoreData

class WaypointsTableViewController: UITableViewController {

    var trip:Trip!
    var waypoints = [Waypoint]()
    var selectedCellWaypoint:Waypoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Trip: " + trip.tripName!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trip.waypoints!.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let array = trip.waypoints! as Set!
        
        //enumerate the objects and grab the relevant context
        for (index, value) in array.enumerate(){
            let item = value as! Waypoint
            waypoints.append(item)
        }
        cell!.textLabel!.text = waypoints[indexPath.row].waypointName!
        return cell!
    }
    
    
    //lets you edit the table rows
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //deleting NSManaged Object
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let managedObjectContext = appDelegate.managedObjectContext
            
            let waypointItemToDelete = waypoints[indexPath.row]
            managedObjectContext.deleteObject(waypointItemToDelete)
            waypoints.removeAtIndex(indexPath.row)
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //selecting tableview cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Pull from the waypoints instance variable to find the selected Trip
        let selectedWaypoint = waypoints[indexPath.row]
        //set the trip to trips object
        selectedCellWaypoint = selectedWaypoint
        performSegueWithIdentifier("showWaypoint", sender: self)
  
    }
    
    //preparing for segue
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "showWaypoint") {
            let svc = segue!.destinationViewController as! displayWaypointMapViewController;
            print(selectedCellWaypoint)
            svc.currentWaypoint = selectedCellWaypoint
        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
