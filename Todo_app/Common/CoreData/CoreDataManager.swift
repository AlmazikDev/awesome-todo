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
    
    func saveTask(name: String, id: String, dueDate: Date, completed: Bool, category: Category) {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
        task.name = name
        task.id = id
        task.dueDate = dueDate
        task.completed = completed
        task.category = category
        
        
        print("Saving task with name: \(task.name ?? "No name")")
        
        do {
                try saveContext()
                print("Task saved successfully!")
            } catch {
                print("Failed to save task:", error)
            }
        
    }
    
    
    func deleteTask( task: Task) {
        context.delete(task)
        
        do {
           try context.save()
        } catch {
            print("Ошибка при сохранении контекста после удаления: \(error.localizedDescription)")
        }
        
    }
    
    func getCategory(byName name: String) -> Category? {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
}
