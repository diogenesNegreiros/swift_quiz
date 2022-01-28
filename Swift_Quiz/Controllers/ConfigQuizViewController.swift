//
//  ConfigQuizViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 27/01/22.
//

import UIKit

class ConfigQuizViewController: UIViewController {
    @IBOutlet weak var question: UITextView!
    
    @IBOutlet weak var answer1: UITextField!
    @IBOutlet weak var answer2: UITextField!
    
    @IBOutlet weak var answer3: UITextField!
    
    @IBOutlet weak var correctAnswer: UITextField!
    @IBOutlet weak var answer4: UITextField!
    
    @IBAction func addButtonAction(_ sender: Any) {
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
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
