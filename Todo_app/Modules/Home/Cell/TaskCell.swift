//
//  TaskCell.swift
//  Todo_app
//
//  Created by Almaz  on 02.02.2025.
//

import UIKit
import SnapKit

class TaskCell: UITableViewCell {
    
    private var checkBoxImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "checkbox")
        image.contentMode = .scaleAspectFit
        return image
    }()

    private var taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.text = "Upload 1099-R to TurboTax"
        return label
    }()
    
    private var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.text = "💰 Finance"
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCellUI()
    }
    
    private func configureCellUI() {
        contentView.addSubview(checkBoxImage)
        contentView.addSubview(taskLabel)
        contentView.addSubview(categoryNameLabel)
        
        checkBoxImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(24)
        }
        
        taskLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(checkBoxImage.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(taskLabel.snp.bottom).offset(4)
            make.left.equalTo(checkBoxImage.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            /*make.height.equalTo(20)*/ // question about content hugging priority
        }
        
    }
    
    func configureTask(task: TaskModel) {
        taskLabel.text = task.tasks
        categoryNameLabel.text = task.category
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
