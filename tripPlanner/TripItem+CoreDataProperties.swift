//
//  TripItem+CoreDataProperties.swift
//  tripPlanner
//
//  Created by Andrei Lyskov on 10/23/15.
//  Copyright © 2015 Andrei Lyskov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TripItem {

    @NSManaged var tripName: String?
    @NSManaged var waypoints: String?

}
