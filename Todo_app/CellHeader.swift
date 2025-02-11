//
//  CellHeader.swift
//  Todo_app
//
//  Created by Almaz  on 03.02.2025.
//

import UIKit
import SnapKit

class CellHeader: UITableViewHeaderFooterView {

    static let identifier = "CellHeader"
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
        label.textColor = .label
        label.text = "Title"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupSectionTitleUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with title: String) {
        sectionTitleLabel.text = title
    }
    
    private func setupSectionTitleUI() {
        addSubview(sectionTitleLabel)
        
        sectionTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        
    }
    
}
