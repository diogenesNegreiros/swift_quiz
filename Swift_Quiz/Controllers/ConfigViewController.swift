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
    
    var quizTimerSeconds: Double = 60.0
    var allQuizTimerMinutes: Int = 0
    var userInfo = UserDefaults.standard

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userTimeSec = userInfo.double(forKey: "timeSeconds")
        if userTimeSec > 0.0 {
            quizTimerSeconds = userTimeSec
        }
        
        let userTimeMin = userInfo.integer(forKey: "timeMinutes")
        if userTimeMin > 0 {
            allQuizTimerMinutes = userTimeMin
        }
        
        setupToolbar()

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.pickerQuizTimer.countDownDuration = TimeInterval()
//            self.pickerQuizTimer.backgroundColor = .green
//        }
        
        if let dateUser = UserDefaults.standard.value(forKey: "date") {
            pickerQuizTimer.setDate(dateUser as! Date, animated: true)
        }
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userInfo.set(quizTimerSeconds, forKey: "timeSeconds")
        userInfo.set(allQuizTimerMinutes, forKey: "timeMinutes")
        userInfo.set(numberOfQuestions.text, forKey: "numberOfQuestions")
        userInfo.set(pickerQuizTimer.date, forKey: "date")
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date) + calendar.component(.hour, from: date) * 60
        self.quizTimerSeconds = Double(minutes * 60)
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





