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
    var userInfo = UserDefaults.standard
    var numberQuestionsOptions: [String] = ["1","2", "3","4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userTime = userInfo.double(forKey: "time")
        if userTime > 0.0 {
            quizTimerSeconds = userTime
        }
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.pickerQuizTimer.countDownDuration = TimeInterval()
//            self.pickerQuizTimer.backgroundColor = .green
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userInfo.set(quizTimerSeconds, forKey: "time")
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let date = sender.date
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date) + calendar.component(.hour, from: date) * 60
        self.quizTimerSeconds = Double(minutes * 60)
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
        }
    }
}

extension ConfigViewController {
    class func loadStoryboard() -> ConfigViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfigViewController") as! ConfigViewController
    }
}

extension ConfigViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberQuestionsOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberQuestionsOptions[row]
    }
    
}

