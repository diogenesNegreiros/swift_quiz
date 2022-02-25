//
//  HomeViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 25/02/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
