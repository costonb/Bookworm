//
//  DataController.swift
//  Bookworm
//
//  Created by Brandon Coston on 9/3/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    static let shared = DataController()
    
    let container: NSPersistentContainer
    
    static let preview: DataController = {
        let controller = DataController(inMemory: true)
        
        return controller;
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Bookworm")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
