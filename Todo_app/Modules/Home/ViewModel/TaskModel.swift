//
//  TaskModel.swift
//  Todo_app
//
//  Created by Almaz  on 02.02.2025.
//

import Foundation

enum SectionType {
    case incompleted(rows: [TaskModel])
    case completed([CompletedTaskModel])
}

class TaskModel {
    
    var sections: String
    var tasks: String
    var category: String
    var coreDataObject: Task?
    
    init(sections: String, tasks: String, category: String, coreDataObject: Task?) {
        self.sections = sections
        self.tasks = tasks
        self.category = category
        self.coreDataObject = coreDataObject
    }
    
}

class CompletedTaskModel {
    
    var task: String
    var coreDataObject: Task?
    
    init(task: String, coreDataObject: Task?) {
        self.task = task
        self.coreDataObject = coreDataObject
    }
}

