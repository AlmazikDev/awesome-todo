//
//  CoreDataManager.swift
//  Todo_app
//
//  Created by Nurzhan Duisembayev on 04.03.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "todoapp_coredate")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
    
    func fetchEntities<T: NSManagedObject>(ofType type: T.Type) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch error: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveCategory(name: String, id: String, emoji: String, color: String) {
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as! Category
        category.name = name
        category.id = id
        category.emoji = emoji
        category.color = color
        saveContext()
    }
    
    func deleteEntity(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
}
