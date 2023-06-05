//
//  CoreDataStore.swift
//  JKOAssignment
//
//  Created by 鄭昭韋 on 2023/6/1.
//

import CoreData

final class CoreDataStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init(bundle: Bundle = .main, storeURL: URL) throws {
        container = try NSPersistentContainer.load(modelName: "JKOStore", in: bundle, storeURL: storeURL)
        context = container.newBackgroundContext()
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = context
        context.perform { action(context) }
    }
}

extension CoreDataStore: CartItemStoreSaver {
    func insert(_ item: LocalItem, completion: @escaping (CartItemStoreSaver.Result) -> Void) {
        perform { context in
            do {
                let managedItem = ManagedItem(context: context)
                managedItem.name = item.name
                managedItem.descriptionContent = item.description
                managedItem.price = Int16(item.price)
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

extension CoreDataStore: CartItemsStoreLoader {
    func retrieve(completion: @escaping (CartItemsStoreLoader.Result) -> Void) {
        perform { context in
            guard let entityName = ManagedItem.entity().name else { return }
            
            completion(Result {
                let request: NSFetchRequest<ManagedItem> = NSFetchRequest(entityName: entityName)
                let sort = NSSortDescriptor(key: #keyPath(ManagedItem.timestamp), ascending: false)
                request.sortDescriptors = [sort]
                request.returnsObjectsAsFaults = false
                let managedItems = try context.fetch(request)
                return managedItems.map {
                    Item(name: $0.name,
                         description: $0.descriptionContent,
                         price: Int($0.price),
                         timestamp: $0.timestamp,
                         imageName: $0.imageName)
                }
            })
        }
    }
}

extension CoreDataStore: OrderStoreSaver {
    func insert(order: Order, completion: @escaping (OrderStoreSaver.Result) -> Void) {
        perform { context in
            do {
                let managedOrder = ManagedOrder(context: context)
                managedOrder.items = NSOrderedSet(array: order.items.map {
                    let managedItem = ManagedOrderItem(context: context)
                    managedItem.name = $0.name
                    managedItem.descriptionContent = $0.description
                    managedItem.price = Int16($0.price)
                    managedItem.timestamp = $0.timestamp
                    managedItem.imageName = $0.imageName
                    return managedItem
                })
                managedOrder.price = Int16(order.price)
                managedOrder.timestamp = order.timestamp
                try context.save()
                completion(.none)
            } catch {
                completion(.some(error))
            }
        }
    }
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
