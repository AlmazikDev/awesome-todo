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

protocol CreateTaskViewControllerDelegate: AnyObject {
    func saveTaskButtonDidTap(with task: String, category: Category?)
}

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
    
    weak var delegate: CreateTaskViewControllerDelegate?
    
    var createdTask : String = ""
    
    private var selectedCategory: Category?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupSubviews()
        
        categoryView.delegate = self
        nameTextField.delegate = self
        fetchCategories()
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
    
    private func fetchCategories() {
        let categories = CoreDataManager.shared.fetchEntities(ofType: Category.self)
        categoryView.setup(categories: categories)
    }
    
    @objc private func saveButtonDidTap() {
        let text = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else {
                print("⚠️ Cannot save empty task")
                    return
        }
        delegate?.saveTaskButtonDidTap(with: text, category: selectedCategory)
        print("Save button did tap with text:", text)
        dismiss(animated: true)
    }
    
    @objc private func onTapView() {
        view.endEditing(true)
    }
}

extension CreateTaskViewController: CategorySelectViewDelegate {
   
    func addCategoryButtonDidTap() {
        let categoryViewController = CreateCategoryViewController()
        categoryViewController.delegate = self
        let floatingPanel = FloatingPanelController()
        floatingPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        floatingPanel.isRemovalInteractionEnabled = true
        floatingPanel.set(contentViewController: categoryViewController)
        floatingPanel.surfaceView.grabberHandle.isHidden = true
        floatingPanel.layout = FloatingPanelIntrinsicLayout()
        
        present(floatingPanel, animated: true)
    }
    
    func categoryDidSelect(_ category: Category) {
        selectedCategory = category
        print("Selected category: \(category.name ?? "")")
    }
}

extension CreateTaskViewController: CreateCategoryViewControllerDelegate {
    func categoryDidCreated() {
        fetchCategories()
    }
}

extension CreateTaskViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let taskName = textField.text ?? ""
        print("Task text from UITextField: '\(taskName)'")
        
        if let value = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty {
            createdTask = value
            print("Received task: \(createdTask)")
        }
        else {
            print("⚠️ Task name is empty. Not saving.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
}
