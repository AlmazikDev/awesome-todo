//
//  CreateCategoryViewController.swift
//  Todo_app
//
//  Created by Almaz  on 11.02.2025.
//

import UIKit
import SnapKit
import FloatingPanel

protocol CreateCategoryViewControllerDelegate: AnyObject {
    func categoryDidCreated()
}

class CreateCategoryViewController: UIViewController {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Add new category"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter category name"
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .label
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let saveCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("save", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(saveCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: CreateCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureAddCategoryUI()
    }
    
    private func configureAddCategoryUI() {
        view.addSubview(categoryLabel)
        view.addSubview(categoryTextField)
        view.addSubview(saveCategoryButton)
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        categoryTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        saveCategoryButton.snp.makeConstraints { make in
            make.top.equalTo(categoryTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    @objc private func saveCategoryButtonTapped() {
        guard let name = categoryTextField.text, !name.isEmpty else { return }
        CoreDataManager.shared.saveCategory(
            name: name,
            id: UUID().uuidString,
            emoji: "",
            color: ""
        )
        
        dismiss(animated: true)
        delegate?.categoryDidCreated()
    }
}
