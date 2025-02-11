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
    
    init(sections: String, tasks: String, category: String) {
        self.sections = sections
        self.tasks = tasks
        self.category = category
    }
    
}

class CompletedTaskModel {
    
    var task: String
    
    init(task: String) {
        self.task = task
    }
}

