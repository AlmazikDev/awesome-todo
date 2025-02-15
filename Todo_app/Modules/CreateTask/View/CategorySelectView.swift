//
//  CategorySelectView.swift
//  Todo_app
//
//  Created by Nurzhan Duisembayev on 11.02.2025.
//

import UIKit
import FloatingPanel

final class CategorySelectView: UIView {
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
//        button.layer.cornerRadius = 8
//        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(addCategoryButtonDidTap), for: .touchUpInside)
        return button
    }()
    
//    private lazy var buttonView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemMint
//        view.layer.cornerRadius = 8
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        let button = UIButton()
//        button .setTitle("+", for: .normal)
//        button .setTitleColor(.black, for: .normal)
////        button .addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(button)
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().priority(.low)
        }
        
    }
    
    func setup(categories: [String]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for category in categories {
            let label = CategoryLabel()
            label.text = category
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.layer.borderWidth = 1
            label.layer.cornerRadius = 8
            stackView.addArrangedSubview(label)
        }
        stackView.addArrangedSubview(addCategoryButton)
    }
    
    @objc private func addCategoryButtonDidTap() {
//        let CategoryVC = CreateCategoryViewController()
//        let floatingPanel = FloatingPanelController()
//        floatingPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
//        floatingPanel.isRemovalInteractionEnabled = true
//        floatingPanel.set(contentViewController: CategoryVC)
//        floatingPanel.surfaceView.grabberHandle.isHidden = true
//        floatingPanel.layout = FloatingPanelIntrinsicLayout()
//        
//        present(floatingPanel, animated: true)
        print("Plus button category button tapped")
    }
}

class CategoryLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        
        return CGRect(x: rect.origin.x + 8, y: rect.origin.y + 8, width: rect.width + 8, height: rect.height + 8)
    }
    
}
