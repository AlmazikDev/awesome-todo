//
//  CreateTaskViewController.swift
//  Todo_app
//
//  Created by Nurzhan Duisembayev on 11.02.2025.
//

import UIKit
import IQKeyboardManagerSwift
import FloatingPanel

// Enter name
// Select due date
// Select category optional

class CreateTaskViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.textColor = .label
        view.text = "Add Task"
        return view
    }()
    
    private let nameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "do math homework"
        view.font = .systemFont(ofSize: 18)
        view.textColor = .label
        view.borderStyle = .roundedRect
        return view
    }()
    
    private let categoryView: CategorySelectView = {
        let view = CategorySelectView()
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        view.setTitle("save", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        view.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupSubviews()
        
        categoryView.setup(categories: ["Category1 Category 2", "2", "Category 3", "Category 4", "Category 1", "Category 2", "Category 3", "Category 4", "Category 1", "Category 2", "Category 3", "Category 4", "Category 1", "Category 2", "Category 3", "Category 4"] + ["+"])
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(categoryView)
        view.addSubview(saveButton)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView)))
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(categoryView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualTo(view.snp.bottomMargin)
        }
    }
    
    @objc private func saveButtonDidTap() {
//        let CategoryVC = CreateCategoryViewController()
//        let floatingPanel = FloatingPanelController()
//        floatingPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
//        floatingPanel.isRemovalInteractionEnabled = true
//        floatingPanel.set(contentViewController: CategoryVC)
//        floatingPanel.surfaceView.grabberHandle.isHidden = true
//        floatingPanel.layout = FloatingPanelIntrinsicLayout()
//        
//        present(floatingPanel, animated: true)
        
        let alert = UIAlertController(title: "Category", message: "Create a new category", preferredStyle: .alert)
        
        alert.addTextField {textField in
            textField.placeholder = "Enter category name"
            textField.autocapitalizationType = .words
            textField.returnKeyType = .go
        }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
            print("Save button tapped")
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel button tapped")
        }
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
    
    @objc private func onTapView() {
        view.endEditing(true)
    }
}
