//
//  AddEditTaskTableViewController.swift
//  SimpleToDoApp
//
//  Created by Yuki Tsukada on 2021/01/10.
//

import UIKit

class AddEditTaskTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var task: Task?
    var selectedPriority: Int
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var priorityPickerView: UIPickerView!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    
//    var pickerViewForPriority: UIPickerView = UIPickerView()
    let priorityList = ["High Priority", "Medium Priority", "Low Priority"]
    
    
    init?(coder: NSCoder, task: Task?, selectedPriority: Int) {
        self.task = task
        self.selectedPriority = selectedPriority
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priorityPickerView.delegate = self
        priorityPickerView.dataSource = self
        
        
        if let task = task {
            titleTextField.text = task.title
            descriptionTextField.text = task.todoDescription
            // priority
            
            // isCompleted
            
            title = "Edit Task"
            priorityPickerView.isHidden = true
        } else {
            title = "Add Task"
            priorityPickerView.isHidden = false
        }

        updateSaveButtonState()
    }
    
    // for pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorityList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPriority = row
    }
    
    
    
    func updateSaveButtonState() {
        let titleText = titleTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
//        let priorityText = priorityTextField.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty && !descriptionText.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text ?? ""
        let todoDescription = descriptionTextField.text ?? ""
        let priority = selectedPriority
        let completionStatusDefault = false
        task = Task(title: title, todoDescription: todoDescription, priorityNumber: priority, isCompleted: completionStatusDefault)
        print(task!)
    }
    
    
    
    

    // MARK: - Table view data source

    
}
