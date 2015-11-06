//
//  tripPlannerTableViewController.swift
//  tripPlanner
//
//  Created by Andrei Lyskov on 10/18/15.
//  Copyright © 2015 Andrei Lyskov. All rights reserved.
//

import UIKit
import CoreData

class tripPlannerTableViewController: UITableViewController {

    @IBOutlet var myTableView: UITableView!
    
    var trips = [NSManagedObject]()
    var selectedCellTrip:Trip!
    
    //MARK: viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
        
    }
    // helps fetch the trip request
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            trips = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func addTrip(sender: AnyObject) {
        let alert = UIAlertController(title: "New Trip", message: "Add a new Trip", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {(action:UIAlertAction) -> Void in
            
            let textField = alert.textFields!.first
            self.saveTrip(textField!.text!)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler{
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
// saves the trip
    func saveTrip(tripText: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("Trip", inManagedObjectContext: managedContext)
        
        let trip = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        trip.setValue(tripText, forKey: "tripName")
        trip.setValue(0, forKey: "numberOfWaypoints")
        
        do {
            try managedContext.save()
            trips.append(trip)
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
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

            let tripItemToDelete = trips[indexPath.row]
            managedObjectContext.deleteObject(tripItemToDelete)
            trips.removeAtIndex(indexPath.row)
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
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
        return trips.count
    }
    
    //init the cell
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let trip = trips[indexPath.row]
        
        let tripKeyValue = trip.valueForKey("tripName") as? String
        
        cell!.textLabel!.text = "Trip to " + tripKeyValue!
        
        return cell!
    }

    
    //prepare for segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Pull from the trips instance variable to find the selected Trip
        let selectedTrip = trips[indexPath.row] as! Trip
        //set the trip to trips object
        selectedCellTrip = selectedTrip
        print(selectedCellTrip.waypoints!.count)
        if(selectedCellTrip.waypoints!.count == 0){
            performSegueWithIdentifier("noWaypoints", sender: self)
        } else {
            performSegueWithIdentifier("showDetails", sender: self)
        }
    }
    
    // start the segue
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "showDetails") {
            var svc = segue!.destinationViewController as! WaypointsTableViewController;
            //pass the name
            svc.trip = selectedCellTrip
        } else if (segue.identifier == "noWaypoints"){
            var svc = segue!.destinationViewController as! AddWaypointViewController;
            svc.trip = selectedCellTrip
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
