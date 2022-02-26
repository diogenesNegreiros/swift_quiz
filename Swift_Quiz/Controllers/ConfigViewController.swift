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
    
    var quizTimerSeconds: Double = 30.0
    var userInfo = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userTime = userInfo.double(forKey: "time")
        if userTime > 0.0 {
            quizTimerSeconds = userTime
        }
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
