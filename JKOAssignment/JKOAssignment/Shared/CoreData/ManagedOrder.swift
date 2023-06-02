//
//  ManagedOrder.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/2.
//

import CoreData

@objc(ManagedOrder)
class ManagedOrder: NSManagedObject {
    @NSManaged var items: NSOrderedSet
    @NSManaged var timestamp: Date
    @NSManaged var price: Int16
}

class ManagedOrderItem: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var descriptionContent: String
    @NSManaged var price: Int16
    @NSManaged var timestamp: Date
    @NSManaged var imageName: String
    @NSManaged var order: ManagedOrder
}
