//
//  ViewController.swift
//  iOS_ToDoApp
//
//  Created by Nazym Sayakhmet on 02.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var tasks: [Task] = []
    
    let inititalTextLabel = UILabel()
    let newTaskButton = UIButton()
    let editTaskButton = UIButton()
    var tableView = UITableView()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTableView()
        setupViews()
        setupConstraints()
        getTask()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTask()
        tableView.reloadData()
    }
    
    func setupViews() {
        inititalTextLabel.text = "Cоздайте новую задачу нажав на кнопку плюс."
        inititalTextLabel.font = UIFont.systemFont(ofSize: 20)
        inititalTextLabel.numberOfLines = 2
        inititalTextLabel.textAlignment = .center
        inititalTextLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inititalTextLabel)
        
        newTaskButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        newTaskButton.tintColor = .systemGreen
        newTaskButton.contentMode = .scaleToFill
        newTaskButton.translatesAutoresizingMaskIntoConstraints = false
        newTaskButton.addTarget(self, action: #selector(addNewTask), for: .touchDown)
        view.addSubview(newTaskButton)
        view.bringSubviewToFront(newTaskButton)
        
        editTaskButton.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
        editTaskButton.tintColor = .systemBlue
        editTaskButton.contentMode = .scaleToFill
        editTaskButton.translatesAutoresizingMaskIntoConstraints = false
        editTaskButton.addTarget(self, action: #selector(editButtonTouched), for: .touchDown)
        view.addSubview(editTaskButton)
        view.bringSubviewToFront(editTaskButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            inititalTextLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            inititalTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            inititalTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: inititalTextLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            newTaskButton.widthAnchor.constraint(equalToConstant: 50),
            newTaskButton.heightAnchor.constraint(equalToConstant: 50),
            newTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            newTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            editTaskButton.widthAnchor.constraint(equalToConstant: 50),
            editTaskButton.heightAnchor.constraint(equalToConstant: 50),
            editTaskButton.bottomAnchor.constraint(equalTo: newTaskButton.topAnchor, constant: -15),
            editTaskButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }
    
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")
    }
    
    @objc func addNewTask() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.modalPresentationStyle = .fullScreen
        present(addTaskVC, animated: true)
    }
    
    @objc func editButtonTouched() {
        let cell = TaskTableViewCell()
        if tableView.isEditing {
            tableView.isEditing = false
            cell.isEditingConstraints = false
            editTaskButton.setBackgroundImage(UIImage(systemName: "pencil.circle.fill"), for: .normal)
            newTaskButton.isHidden = false
            tableView.reloadData()
        } else {
            tableView.isEditing = true
            cell.isEditingConstraints = true
            editTaskButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            newTaskButton.isHidden = true
            tableView.reloadData()
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

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskTableViewCell
        
        if tasks[indexPath.row].isComplete {
            cell.checkButton.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        } else {
            cell.checkButton.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        let task = tasks[indexPath.row]
        cell.setTask(task: task)
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].isComplete.toggle()
        saveTask()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let addTaskVC = AddTaskViewController()
        addTaskVC.editTaskIndex = indexPath.row
        addTaskVC.isEditingTask = true
        addTaskVC.modalPresentationStyle = .fullScreen
        present(addTaskVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            saveTask()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let taskMoved = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(taskMoved, at: destinationIndexPath.row)
        saveTask()
    }
}
