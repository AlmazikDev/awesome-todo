//
//  ViewController.swift
//  Todo_app
//
//  Created by Almaz  on 02.02.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.lightGray.cgColor
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
    
    private var addTaskImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "add_task") // add in future realease
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
        TaskModel(sections: "Incomplete", tasks: "Upload 1099-R to TurboTax", category: "💰 Finance"),
        TaskModel(sections: "Incomplete", tasks: "Submit 2019 tax return", category: "💰 Finance"),
        TaskModel(sections: "Incomplete", tasks: "Print parking passes", category: "💞 Wedding"),
        TaskModel(sections: "Incomplete", tasks: "Sign contract, send back", category: "🖥️ Freelance"),
        TaskModel(sections: "Incomplete", tasks: "Hand sanitizer", category: "🛒 Shopping List"),
       ]
    
    var completedTask: [CompletedTaskModel] = [
        CompletedTaskModel(task: "Check on FedEx Order"),
        CompletedTaskModel(task: "Look at new plugins"),
        CompletedTaskModel(task: "Respond to catering company"),
        CompletedTaskModel(task: "Reschedule morning coffee"),
        CompletedTaskModel(task: "Check the latest on Community")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "cell")
        tableView.register(PerformedTaskCell.self, forCellReuseIdentifier: "PerformedTaskCell")
        configureAddTaskUI()
        configureMainLabels()
        configureTaskCountLabels()
    
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

    
    @objc func handleAddTask(sender: UITapGestureRecognizer) {
        if sender.state == .ended{
            print("Add task tapped")
        }
    }
    
    private func configureAddTaskUI() {
        view.addSubview(containerView)
        containerView.addSubview(labelStackView)
        labelStackView.addArrangedSubview(dateLabel)
        labelStackView.addArrangedSubview(tasksLabel)
        view.addSubview(addTaskImage)
        view.addSubview(labelStackView)
        view.addSubview(tableView)
        
        containerView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(labelStackView.snp_margins)
        }
        
        labelStackView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
        }
        
        addTaskImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            make.right.equalToSuperview().offset(-18)
            make.width.height.equalTo(56)
        }

        tableView.snp.makeConstraints{ make in
            make.top.equalTo(labelStackView.snp.bottom)
            make.left.equalTo(view).offset(16)
            make.right.equalTo(view).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .incompleted(let rows):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
            cell.configureTask(task: rows[indexPath.row])
            return cell
            
        case .completed(let rows):
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerformedTaskCell", for: indexPath) as! PerformedTaskCell
            cell.configureCompletedTask(task: rows[indexPath.row])
            return cell
    
        }
        
    }
    
    
}
