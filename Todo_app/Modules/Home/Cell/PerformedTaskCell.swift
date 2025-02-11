//
//  PerformedTaskCell.swift
//  Todo_app
//
//  Created by Almaz  on 05.02.2025.
//

import UIKit
import SnapKit

class PerformedTaskCell: UITableViewCell {
    
    static let identifier: String = "PerformedTaskCell"
    
    var checkedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Checked")
        return imageView
    }()
    
    var performedTaskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .lightGray
        label.text = "Check on Fedex order"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configurePerformedTaskCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePerformedTaskCellUI() {
        contentView.addSubview(checkedImageView)
        contentView.addSubview(performedTaskLabel)
        
        checkedImageView.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.left.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        performedTaskLabel.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.right.equalToSuperview()
            make.left.equalTo(checkedImageView.snp.right).inset(-16)
            make.bottom.equalTo(-16)
            
        }
    }
    
    func configureCompletedTask(task: CompletedTaskModel) {
        performedTaskLabel.text = task.task
    }
    
}
