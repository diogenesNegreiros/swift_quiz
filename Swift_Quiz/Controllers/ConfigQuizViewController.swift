//
//  ConfigQuizViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 27/01/22.
//

import UIKit
import CoreData

class ConfigQuizViewController: UIViewController {
    
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var answer1: UITextField!
    @IBOutlet weak var answer2: UITextField!
    @IBOutlet weak var answer3: UITextField!
    @IBOutlet weak var answer4: UITextField!
    @IBOutlet weak var correctAnswer: UITextField!
    
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var myQuestion: Question!
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        
        myQuestion = Question(context: context)
        myQuestion.statement = question.text
        myQuestion.answer1 = answer1.text
        myQuestion.answer2 = answer2.text
        myQuestion.answer3 = answer3.text
        myQuestion.answer4 = answer4.text
        //        myQuestion.answer = correctAnswer.text
        myQuestion.correctIndex = correctAnswer.text
        
        do {
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()
        validateAddButton()
    }
    
    func setupToolbar(){
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        question.inputAccessoryView = bar
        question.inputAccessoryView = bar
        answer1.inputAccessoryView = bar
        answer2.inputAccessoryView = bar
        answer3.inputAccessoryView = bar
        answer4.inputAccessoryView = bar
        correctAnswer.inputAccessoryView = bar
    }
    
    func validateAddButton() {
        if question.text != ""
            && answer1.text != ""
            && answer2.text != ""
            && answer3.text != ""
            && answer4.text != ""
            && correctAnswer.text != "" {
            addButton.isUserInteractionEnabled = true
            addButton.backgroundColor = .systemBlue
        } else {
            addButton.isUserInteractionEnabled = false
            addButton.backgroundColor = .lightGray
        }
        
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}



extension ConfigQuizViewController {
    
    class func loadStoryboard() -> ConfigQuizViewController {
        return UIStoryboard(name: "ConfigQuiz", bundle: nil).instantiateViewController(withIdentifier: "ConfigQuizViewController") as! ConfigQuizViewController
    }
}

extension ConfigQuizViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validateAddButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.validateAddButton()
    }
}
