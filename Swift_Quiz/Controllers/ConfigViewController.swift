//
//  HomeViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 25/02/22.
//

import UIKit
import CoreData

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var pickerQuizTimer: UIDatePicker!
    @IBOutlet weak var pickerNumberOfQuestions: UIPickerView!
    @IBOutlet weak var numberOfQuestions: UITextField!
    
    var allQuizTimerMinutes: Int = 1
    var userInfo = UserDefaults.standard
    var manager = QuizManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.loadAllQuizes { quizList, success in
            
            if quizList.count == 0 {
                self.numberOfQuestions.text = "1"
            }else {
                self.numberOfQuestions.text = String(quizList.count)
            }
            
        }
        setupToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let userTimeMin = userInfo.integer(forKey: "timeMinutes")
        if userTimeMin > 0 {
            allQuizTimerMinutes = userTimeMin
        }
        
        if let dateUser = UserDefaults.standard.value(forKey: "date") {
            pickerQuizTimer.setDate(dateUser as! Date, animated: true)
        }
        
        let numQuestions = UserDefaults.standard.integer(forKey: "numberOfQuestions")
        if numQuestions > 0 {
            self.numberOfQuestions.text = "\(numQuestions)"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userInfo.set(allQuizTimerMinutes, forKey: "timeMinutes")
        userInfo.set(numberOfQuestions.text, forKey: "numberOfQuestions")
        userInfo.set(pickerQuizTimer.date, forKey: "date")
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date) + calendar.component(.hour, from: date) * 60
        self.allQuizTimerMinutes = minutes
        print("Total de minutos: \(minutes)")
    }
    
    @IBAction func backToHome(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToAddAnsers(_ sender: Any) {
        let vc = CreateQuestionsViewController.loadStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clearAnsersDataBase(_ sender: Any) {
        showOptionAlert(title: "Atenção ‼️", subTitle: "Tem certeza que deseja excluir o banco de dados? \nTodas as perguntas cadastradas anteriormente serão excluídas!!") {
            self.deleteDataBase()
        }
    }
    
    func setupToolbar(){
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        numberOfQuestions.inputAccessoryView = bar
    }
    
    func showAlertClosure(body: String, action: @escaping ()->()) {
        let alert = UIAlertController(
            title: "Atenção",
            message: body,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            action()
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dismissMyKeyboard() {
        self.view.endEditing(true)
    }
    
    func deleteDataBase() {
        // Get a reference to a NSPersistentStoreCoordinator
        let storeContainer = persistentContainer.persistentStoreCoordinator
        
        // Delete each existing persistent store
        for store in storeContainer.persistentStores {
            
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            }catch {
                print(error.localizedDescription)
            }
        }
        persistentContainer.loadPersistentStores {
            (store, error) in
            // Handle errors
            print("Erro no Core Data: \(String(describing: error?.localizedDescription))")
        }
    }
}

extension ConfigViewController {
    class func loadStoryboard() -> ConfigViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfigViewController") as! ConfigViewController
    }
}

extension ConfigViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        let maxElements = manager.quizes.count
        let selectValue = textField.text ?? "1"
        let selectIntValue = Int(selectValue) ?? 1
        
        if selectIntValue > maxElements && maxElements > 1 {
            showAlertClosure(body: "O valor selecionado é maior que a quantidade de perguntas disponíveis no banco!") {
                if maxElements > 0 {
                    textField.text = "\(maxElements)"
                }else {
                    textField.text = "1"
                }
            }
            
        }else if (selectIntValue == 0) {
            showAlertClosure(body: "O valor selecionado é inválido, escolha um valor maior que zero!") {
                textField.text = "1"
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let maxElements = manager.quizes.count
        let selectValue = textField.text ?? "1"
        let selectIntValue = Int(selectValue) ?? 1
        
        if textField.text == "" {
            showAlertClosure(body: "O campo de quantidade de perguntas deve ser preenchido com um valor válido!") {
                if maxElements > 0 {
                    textField.text = "\(maxElements)"
                }else {
                    textField.text = "1"
                }
            }
        }else if (maxElements == 0 && selectIntValue > 0) {
            showAlertClosure(body: "Você não tem perguntas cadastradas no banco, cadastre as perguntas e depois selecione a quantidade!") {
                textField.text = "1"
            }
        }
    }
}





