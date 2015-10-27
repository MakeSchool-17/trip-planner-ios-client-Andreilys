//
//  addTripViewController.swift
//  tripPlanner
//
//  Created by Andrei Lyskov on 10/18/15.
//  Copyright © 2015 Andrei Lyskov. All rights reserved.
//

import UIKit

class addTripViewController: UIViewController {
   
    @IBOutlet weak var textBox: UITextField!
    
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func addTrip(sender: AnyObject) {
        print(self.textBox.text!)
        self.textBox.text = nil
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
