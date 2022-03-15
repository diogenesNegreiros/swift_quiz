//
//  ConfigQuizViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 27/01/22.
//

import UIKit
import CoreData

class CreateQuestionsViewController: UIViewController {
    
    @IBOutlet weak var backgroundSV: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var answer1: UITextField!
    @IBOutlet weak var answer2: UITextField!
    @IBOutlet weak var answer3: UITextField!
    @IBOutlet weak var answer4: UITextField!
    @IBOutlet weak var correctAnswer: UITextField!
    
    @IBOutlet weak var startQuizButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var myQuestion: Question!
    var manager = QuizManager.shared
    
    @IBAction func backHome(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startQuiz(_ sender: Any) {
        
        manager.loadAllQuizes { quizList, success in
            if success {
                let vc = QuizViewController.loadStoryboard()
                
                if quizList.count > 0  {
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    let alert = UIAlertController(
                        title: "Atenção",
                        message: "Você não tem perguntas cadastradas, cadastre as perguntas para iniciar um Quiz!",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
        
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        myQuestion = Question(context: context)
        myQuestion.statement = question.text ?? ""
        myQuestion.answer1 = answer1.text ?? ""
        myQuestion.answer2 = answer2.text ?? ""
        myQuestion.answer3 = answer3.text ?? ""
        myQuestion.answer4 = answer4.text ?? ""
        myQuestion.correctIndex = correctAnswer.text ?? "0"
        clearAllTexts()
        do {
            try context.save()
            manager.loadAllQuizes { quizList, success in
                
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
        
        //Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
        
        //We make a call to our keyboard handling function as soon as the view is loaded.
        initializeHideKeyboard()
        
        setupToolbar()
        validateAddButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from all our notifications
        unsubscribeFromAllNotifications()
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
    
    func clearAllTexts() {
        question.text = ""
        answer1.text = ""
        answer2.text = ""
        answer3.text = ""
        answer4.text = ""
        correctAnswer.text = ""
    }
    

}

extension CreateQuestionsViewController {
    
    class func loadStoryboard() -> CreateQuestionsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfigQuizViewController") as! CreateQuestionsViewController
    }
}

extension CreateQuestionsViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let selectValue = textField.text ?? ""
        let selectIntValue = Int(selectValue) ?? 0
        
        if textField == correctAnswer && textField.text != "" {
            if selectIntValue < 1 || selectIntValue > 4 {
                textField.text = ""
                showAlertClosure(body: "Escolha uma opção de 1 a 4", action: {})
            }
        }
        self.validateAddButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.validateAddButton()
    }
    
}

extension CreateQuestionsViewController {
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
}

extension CreateQuestionsViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        // Get required info out of the notification
        if let scrollView = backgroundSV, let userInfo = notification.userInfo, let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey], let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey], let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] {
            
            // Transform the keyboard's frame into our view's coordinate system
            let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
            
            // Find out how much the keyboard overlaps our scroll view
            let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
            
            // Set the scroll view's content inset & scroll indicator to avoid the keyboard
            scrollView.contentInset.bottom = keyboardOverlap + 24.0
            scrollView.scrollIndicatorInsets.bottom = keyboardOverlap + 24.0
            
            let duration = (durationValue as AnyObject).doubleValue
            let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
            UIView.animate(withDuration: duration!, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
