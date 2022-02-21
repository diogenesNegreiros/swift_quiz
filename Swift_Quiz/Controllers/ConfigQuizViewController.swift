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
    
    var myQuestion: Question!
    
    @IBAction func addButtonAction(_ sender: Any) {
        myQuestion = Question(context: context)
        myQuestion.statement = question.text
        myQuestion.alternativa?.texto1 = answer1.text
        myQuestion.alternativa?.texto2 = answer2.text
        myQuestion.alternativa?.texto3 = answer3.text
        myQuestion.alternativa?.texto4 = answer4.text
        myQuestion.answer = correctAnswer.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ConfigQuizViewController {
    
    class func loadStoryboard() -> ConfigQuizViewController {
        return UIStoryboard(name: "ConfigQuiz", bundle: nil).instantiateViewController(withIdentifier: "ConfigQuizViewController") as! ConfigQuizViewController
    }
}
