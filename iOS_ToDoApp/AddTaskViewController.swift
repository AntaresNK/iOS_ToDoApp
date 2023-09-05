//
//  AddTaskViewController.swift
//  iOS_ToDoApp
//
//  Created by Nazym Sayakhmet on 04.09.2023.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    let navigationBar = UINavigationBar()
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionTextField = UITextField()
    var warningLabel = UILabel()
    var tasks: [Task] = []
    let defaults = UserDefaults.standard
    var editTaskIndex: Int?
    var isEditingTask = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 246/255, green: 244/255, blue: 247/255, alpha: 1)
        
        setupViews()
        setupConstraints()
        hideKeyboardWhenTappedAraound()
        getTask()
        editCurrentTask()
    }
    
    func setupViews() {
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTouched))
        cancelButton.tintColor = .systemRed
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTouched))
            
        navigationBar.setItems([UINavigationItem(title: "")], animated: false)
        navigationBar.topItem?.setLeftBarButton(cancelButton, animated: false)
        navigationBar.topItem?.setRightBarButton(saveButton, animated: false)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = "Название"
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleTextField.font = UIFont.systemFont(ofSize: 17)
        titleTextField.textAlignment = .left
        titleTextField.borderStyle = .roundedRect
        titleTextField.layer.borderColor = .none
        titleTextField.backgroundColor = .white
        titleTextField.placeholder = "Название"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleTextField)
        
        descriptionTextField.font = UIFont.systemFont(ofSize: 17)
        descriptionTextField.textAlignment = .left
      
        descriptionTextField.borderStyle = .roundedRect
        descriptionTextField.backgroundColor = .white
        descriptionTextField.placeholder = "Описание"
        descriptionTextField.contentVerticalAlignment = .top
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextField)
        
        warningLabel.text = ""
        warningLabel.textColor = .systemRed
        warningLabel.textAlignment = .left
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warningLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 45.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            titleTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            descriptionTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 470)
        ])
        
    }
    func editCurrentTask() {
        if !isEditingTask {
            return
        }
        titleTextField.text = tasks[editTaskIndex!].title
        descriptionTextField.text = tasks[editTaskIndex!].description
    }
    
    @objc func cancelButtonTouched() {
        self.dismissView()
    }
    
    @objc func saveButtonTouched() {
        let title = titleTextField.text!
        let description = descriptionTextField.text!
        
        if title.isEmpty {
            warningLabel.text = "Заполните Название"
        } else {
            if isEditingTask {
                tasks[editTaskIndex!].title = titleTextField.text!
                tasks[editTaskIndex!].description = descriptionTextField.text!
                isEditingTask = false
            } else {
                tasks.append(Task(title: title, description: description))
            }
            saveTask()
            titleTextField.text = ""
            descriptionTextField.text = ""
            dismissView()
        }
    }
    
    func saveTask() {
        do {
          let json = try JSONEncoder().encode(tasks)
            defaults.set(json, forKey: "task")
        } catch {
            print("Failed to encode")
        }
    }
    
    func getTask() {
        if let data = defaults.data(forKey: "task") {
            do {
                let taskArray = try JSONDecoder().decode([Task].self, from: data)
                tasks = taskArray
            } catch {
                print("Failed to decode")
            }
        }
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAraound() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
