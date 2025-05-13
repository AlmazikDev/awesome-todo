//
//  ViewController.swift
//  Todo_app
//
//  Created by Almaz  on 02.02.2025.
//

import UIKit
import SnapKit
import FloatingPanel

class ViewController: UIViewController {
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
  
    private var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private var tasksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addTaskImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "add_task")
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAddTask))
        image.addGestureRecognizer(tapGestureRecognizer)
        return image
    }()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    
    lazy var sections : [SectionType] = {
        var sections = [SectionType]()
        sections.append(.incompleted(rows: incompletedTask))
        sections.append(.completed(completedTask))
        return sections
    }()
    
    var incompletedTask: [TaskModel] = [
        TaskModel(sections: "Incomplete", tasks: "Upload 1099-R to TurboTax", category: "💰 Finance", coreDataObject: nil ),
        TaskModel(sections: "Incomplete", tasks: "Submit 2019 tax return", category: "💰 Finance", coreDataObject: nil),
        TaskModel(sections: "Incomplete", tasks: "Print parking passes", category: "💞 Wedding", coreDataObject: nil),
        TaskModel(sections: "Incomplete", tasks: "Sign contract, send back", category: "🖥️ Freelance", coreDataObject: nil),
        TaskModel(sections: "Incomplete", tasks: "Hand sanitizer", category: "🛒 Shopping List", coreDataObject: nil),
       ]
    
    var completedTask: [CompletedTaskModel] = [
        CompletedTaskModel(task: "Check on FedEx Order", coreDataObject: nil),
        CompletedTaskModel(task: "Look at new plugins", coreDataObject: nil),
        CompletedTaskModel(task: "Respond to catering company", coreDataObject: nil),
        CompletedTaskModel(task: "Reschedule morning coffee", coreDataObject: nil),
        CompletedTaskModel(task: "Check the latest on Community", coreDataObject: nil)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PerformedTaskCell.self, forCellReuseIdentifier: "PerformedTaskCell")
        configureAddTaskUI()
        configureMainLabels()
        configureTaskCountLabels()
        removeEmptyTasks()
        loadTasksFromCoreData()
        
    
    }
    
    func configureMainLabels() {
        var currentDate = ""
        currentDate = currentDate.getCurrentDate(date: Date())
        dateLabel.text = currentDate
    }
    
    func configureTaskCountLabels() {
        let completedTaskCount = completedTask.count
        let incompletedTaskCount = incompletedTask.count
        
        tasksLabel.text = "\(incompletedTaskCount) incomplete, \(completedTaskCount) completed"
    }
    
    // MARK: - Loads tasks from Core Data
    func loadTasksFromCoreData() {
        let tasks = CoreDataManager.shared.fetchEntities(ofType: Task.self)
        
        let allTasks = CoreDataManager.shared.fetchEntities(ofType: Task.self)
        for task in allTasks {
            print("Task: \(task.name ?? ""), completed: \(task.completed)")
        }
        
        if tasks.isEmpty {
            insertDefaultTasks()
            return
        }
        
        incompletedTask = tasks.filter { !$0.completed }.map {
            TaskModel(sections: "Incompleted", tasks: $0.name ?? "❗️No name", category: "📝 New", coreDataObject: $0)
        }
        
        completedTask = tasks.filter {$0.completed }.map {
            CompletedTaskModel(task: $0.name ?? "", coreDataObject: $0)
        }
        
        sections = [
            .incompleted(rows: incompletedTask),
            .completed(completedTask)
        ]
        
        tableView.reloadData()
        configureTaskCountLabels()
    }
    
    func insertDefaultTasks() {
        let defaultTasks = [
            TaskModel(sections: "Incomplete", tasks: "Upload 1099-R to TurboTax", category: "💰 Finance", coreDataObject: nil),
            TaskModel(sections: "Incomplete", tasks: "Submit 2019 tax return", category: "💰 Finance", coreDataObject: nil),
            TaskModel(sections: "Incomplete", tasks: "Print parking passes", category: "💞 Wedding", coreDataObject: nil),
            TaskModel(sections: "Incomplete", tasks: "Sign contract, send back", category: "🖥️ Freelance", coreDataObject: nil),
            TaskModel(sections: "Incomplete", tasks: "Hand sanitizer", category: "🛒 Shopping List", coreDataObject: nil),
        ]
        
        for task in defaultTasks {
            let categoryName = task.category
            let category: Category
            
            if let existingCategory = CoreDataManager.shared.getCategory(byName: categoryName) {
                category = existingCategory
            } else {
                CoreDataManager.shared.saveCategory(name: categoryName, id: UUID().uuidString, emoji: "", color: "")
                category = CoreDataManager.shared.getCategory(byName: categoryName)!
            }
            
            CoreDataManager.shared.saveTask(name: task.tasks,
                                            id: UUID().uuidString,
                                            dueDate: Date(),
                                            completed: false, category: category)
        }
        loadTasksFromCoreData()
    }
    
    func removeEmptyTasks() {
        let allTasks = CoreDataManager.shared.fetchEntities(ofType: Task.self)
        
        let emptyTasks = allTasks.filter { ($0.name ?? "").isEmpty }
        
        for task in emptyTasks {
            CoreDataManager.shared.context.delete(task)
        }
        
        do {
            try CoreDataManager.shared.saveContext()
            print("✅ Успешно удалили пустые задачи")
        } catch {
            print("⚠️ Ошибка при удалении пустых задач:", error)
        }
        
        loadTasksFromCoreData()
        
    }
    
    @objc func handleAddTask(sender: UITapGestureRecognizer) {
        let viewController = CreateTaskViewController()
        viewController.delegate = self
        let floatingPanel = FloatingPanelController()
        floatingPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        floatingPanel.isRemovalInteractionEnabled = true
        floatingPanel.set(contentViewController: viewController)
        floatingPanel.surfaceView.grabberHandle.isHidden = true
        floatingPanel.layout = FloatingPanelIntrinsicLayout()
        
        present(floatingPanel, animated: true)
    }
    
    private func configureAddTaskUI() {
        view.addSubview(containerView)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(tasksLabel)
        containerView.addSubview(addTaskImage)
        containerView.addSubview(labelStackView)
        view.addSubview(tableView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
        
        addTaskImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
            make.size.equalTo(56)
        }

        tableView.snp.makeConstraints{ make in
            make.top.equalTo(containerView.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
            case .incompleted(let rows):
                return rows.count
            case .completed(let rows):
                return rows.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sections[section] {
            case .incompleted:
                return "Incomplete"
            case .completed:
                return "Completed"
            default :
                return ""
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .incompleted(let rows):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
            cell.configureTask(task: rows[indexPath.row])
            cell.onCheckBoxTapped = {
                
                if case .incompleted(let tasks) = self.sections[indexPath.section] {
                    let task = tasks[indexPath.row]
                    
                    if let object = task.coreDataObject {
                        object.completed = true
                        try? CoreDataManager.shared.saveContext()
                    }
                    self.loadTasksFromCoreData()
                }
                
                
            }
            return cell
            
        case .completed(let rows):
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerformedTaskCell", for: indexPath) as! PerformedTaskCell
            cell.configureCompletedTask(task: rows[indexPath.row])
            return cell
    
        }
        
    }
    
    // MARK: - Swipe to delete feature
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Swipe to delete row \(indexPath.row)")
            
            
            if case .incompleted(let tasks) = self.sections[indexPath.section] {
                let taskToDelete = tasks[indexPath.row]
                
                if let coreDataObject = taskToDelete.coreDataObject {
                    CoreDataManager.shared.deleteTask(task: coreDataObject)
                    
                    do {
                        try CoreDataManager.shared.saveContext()
                        print("✅ Задача успешно удалена")
                    } catch {
                        print("⚠️ Ошибка при удалении задачи:", error)
                    }
                    
                    loadTasksFromCoreData()
                }
            }
            
            if case .completed(let tasks) = self.sections[indexPath.section] {
                let taskToDelete = tasks[indexPath.row]
                
                if let coreDataObject = taskToDelete.coreDataObject {
                    CoreDataManager.shared.deleteTask(task: coreDataObject)
                    
                    do {
                        try CoreDataManager.shared.saveContext()
                        print("✅ Задача успешно удалена")
                    }
                    catch {
                        print("⚠️ Ошибка при удалении задачи:", error)
                    }
                    
                    loadTasksFromCoreData()
                }
            }
            
        }
    }
    
}

    // MARK: - Selecting row in TableView
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Item \(indexPath.row) selected")
    }
    
}



public final class FloatingPanelIntrinsicLayout: FloatingPanelLayout {
    
    // MARK: - Public Properties

    public var position: FloatingPanelPosition = .bottom

    public var initialState: FloatingPanelState { .full }

    public var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        [.full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: 0, referenceGuide: .safeArea)]
    }

    // MARK: - Init

    public init() {}
}

    // MARK: - Delegate
extension ViewController: CreateTaskViewControllerDelegate {
    func saveTaskButtonDidTap(with task: String, category: Category?) {
        print("Received task before trimming: '\(task)'")
        
        let trimmedTask = task.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("Received task after trimming: '\(trimmedTask)'")
        
        guard !trimmedTask.isEmpty else {
            print("⚠️ Task name is empty. Not saving.")
            return
        }
        print("Saving task with name: \(trimmedTask)")
        
        print("🚀 Calling saveTask with name: \(trimmedTask)")
        
        guard let category = category else {
            print("⚠️ Category is not selected. Cannot save task.")
            return
        }
        
        CoreDataManager.shared.saveTask(name: trimmedTask,
                                        id: UUID().uuidString,
                                        dueDate: Date(),
                                        completed: false,
                                        category: category)
        loadTasksFromCoreData()
    }
    
    
}

