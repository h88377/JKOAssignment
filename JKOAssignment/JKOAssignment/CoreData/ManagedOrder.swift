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
