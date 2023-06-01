//
//  CoreDataStore.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import CoreData

final class CoreDataStore: ItemStoreSaver {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init(bundle: Bundle = .main, storeURL: URL) throws {
        container = try NSPersistentContainer.load(modelName: "JKOStore", in: bundle, storeURL: storeURL)
        context = container.newBackgroundContext()
    }
    
    func insert(_ item: Item, completion: @escaping (ItemStoreSaver.Result) -> Void) {
        let context = context
        context.perform {
            do {
                let managedItem = ManagedItem(context: context)
                managedItem.name = item.name
                managedItem.descriptionContent = item.description
                managedItem.price = Int64(item.price)
                managedItem.timestamp = item.timestamp
                managedItem.imageName = item.imageName
                
                try context.save()
                completion(.none)
            } catch {
                completion(.some(error))
            }
        }
    }
}

@objc(ManagedItem)
class ManagedItem: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var descriptionContent: String
    @NSManaged var price: Int64
    @NSManaged var timestamp: Date
    @NSManaged var imageName: String
}

extension NSPersistentContainer {
    enum LoadingError: Error {
        case modelNotFound
        case failedToLoadPersistentStore(Error)
    }
    
    static func load(modelName: String, in bundle: Bundle, storeURL: URL) throws -> NSPersistentContainer {
        guard let modelURL = bundle.url(forResource: modelName, withExtension: "momd"), let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw LoadingError.modelNotFound
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        let description = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Error?
        container.loadPersistentStores { _, error in
            loadError = error
        }
        
        try loadError.map { throw LoadingError.failedToLoadPersistentStore($0) }
        
        return container
    }
}
