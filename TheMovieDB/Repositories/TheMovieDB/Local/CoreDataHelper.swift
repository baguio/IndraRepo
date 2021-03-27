//
//  CoreDataHelper.swift
//  TheMovieDB
//
//  Created by Jhonatan A. on 26/03/21.
//

import UIKit
import CoreData

private unowned var context: NSManagedObjectContext = {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}()

class CoreDataHelper<T: NSManagedObject> {
    var entityDescription: NSEntityDescription
    
    init?() {
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: String(describing: T.self),
            in: context
        ) else {
            return nil
        }
        self.entityDescription = entityDescription
    }
    
    func create() -> T {
        NSManagedObject(entity: entityDescription, insertInto: context) as! T
    }
    
    func query() throws -> [T] {
        try query(predicate: nil)
    }
    
    func query(predicate: String, _ arguments: String...) throws -> [T] {
        try query(predicate: (predicate, arguments))
    }
    
    private func query(predicate: (String, arguments: [String])?) throws -> [T] {
        let request = NSFetchRequest<NSFetchRequestResult>(
            entityName: String(describing: T.self)
        )
        request.returnsObjectsAsFaults = false
        if let predicate = predicate {
            request.predicate = NSPredicate(format: predicate.0, argumentArray: predicate.arguments)
        }
        let result = try context.fetch(request)
        return result as! [T]
    }
    
    static func save() throws {
        try context.save()
    }
}
