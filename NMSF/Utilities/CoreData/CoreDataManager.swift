//
//  CoreDataStack.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/19/21.
//

import Foundation
import CoreData
import Combine

class CoreDataManager {
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NMSF")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                let message = "CoreDataManager -> \(#function): Unresolved error: \(error), \(error.userInfo)"
                fatalError(message)
            }
        }
        return container
        
    }()
    
    func saveContext() -> Future<Void, Error> {
        Future { [weak self] promise in
            guard let `self` = self,
                  self.managedContext.hasChanges else {
                promise(.failure(CoreDataError.unknown))
                return
            }
            
            var saveError: Error?
            self.managedContext.performAndWait {
                do {
                    try self.managedContext.save()
                } catch {
                    saveError = CoreDataError.unknown
                }
            }
            if let error = saveError {
                promise(.failure(error))
            } else {
                promise(.success(()))
            }
        }
    }
    
    func fetchAll<T: NSManagedObject>(ofType _: T.Type, predicate: NSPredicate?) -> Future<[T], Error> {
        Future { [weak self] promise in
            guard let `self` = self else {
                promise(.failure(CoreDataError.unknown))
                return
            }
            
            var entities: [T] = []
            self.managedContext.performAndWait {
                
                guard let items: [T] = self.fetch(ofType: T.self, predicate: predicate) else {
                    promise(.failure(CoreDataError.unknown))
                    return
                }
                
                entities = items
            }
            promise(.success(entities))
        }
    }
    
    func fetch<T: EntityIdentifiable>(ofType _: T.Type, entityId: String) -> T? {
        var entity: T?
        self.managedContext.performAndWait {
            
            let predicate = T.objectPredicate(entityId: entityId)
            let items: [T]? = self.fetch(ofType: T.self, predicate: predicate)
            
            entity = items?.first
        }
        return entity
    }
    
    func getExistingOrAddNew<T: EntityIdentifiable>(ofType _: T.Type, entityId: String) -> T? {
        let entity = fetch(ofType: T.self, entityId: entityId)
        
        if let entity = entity {
            return entity
        } else {
            var object: T?
            self.managedContext.performAndWait {
                if let newObject = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self.managedContext) as? T {
                    object = newObject
                    object?.entityId = entityId
                }
            }
            return object
        }
    }
    
    
    private func fetch<T: NSManagedObject>(ofType _T: T.Type, predicate: NSPredicate?) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
        fetchRequest.predicate = predicate
        
        return try? managedContext.fetch(fetchRequest)
    }

    func deleteObjects<T: NSManagedObject>(ofType _T: T.Type, predicate: NSPredicate?) {
        self.managedContext.performAndWait {
            let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
            fetchRequest.predicate = predicate
            if let existingObjects = try? self.managedContext.fetch(fetchRequest) {
                existingObjects.forEach {
                    self.managedContext.delete($0)
                }
            }
        }
    }
}
