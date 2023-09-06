//
//  TaskTableViewCell.swift
//  iOS_ToDoApp
//
//  Created by Nazym Sayakhmet on 04.09.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var checkButton = UIButton()
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var checkButtonLeadingConstraint: NSLayoutConstraint?
    var titleLabelLeadingConstraint: NSLayoutConstraint?
    var descriptionLabelLeadingConstraint: NSLayoutConstraint?
    var isEditingConstraints: Bool = false
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTask(task: Task) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description
    }
    
    func setupViews() {
        checkButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.tintColor = .systemYellow
        checkButton.contentMode = .scaleToFill
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkButton)
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .left
        descriptionLabel.contentMode = .topLeft
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        
        checkButtonLeadingConstraint?.isActive = false
        titleLabelLeadingConstraint?.isActive = false
        descriptionLabelLeadingConstraint?.isActive = false
        
        if isEditingConstraints {
            checkButtonLeadingConstraint = checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50)
            titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 15)
            descriptionLabelLeadingConstraint = descriptionLabel.leadingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: 40)
        } else {
            checkButtonLeadingConstraint = checkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
            titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 15)
            descriptionLabelLeadingConstraint = descriptionLabel.leadingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: 40)
        }
            checkButtonLeadingConstraint?.isActive = true
            titleLabelLeadingConstraint?.isActive = true
            descriptionLabelLeadingConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 25),
            checkButton.heightAnchor.constraint(equalToConstant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

}

