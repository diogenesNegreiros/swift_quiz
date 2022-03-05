//
//  HomeViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 26/02/22.
//

import UIKit

class HomeViewController: UIViewController {
    var manager = QuizManager.shared


    @IBAction func startQuizAction(_ sender: Any) {
        
        if manager.quizes.count > 0 {
                    let vc = QuizViewController.loadStoryboard()
            vc.quizManager = manager
                    navigationController?.pushViewController(vc, animated: true)
        }else {
            let alert = UIAlertController(
                title: "Atenção",
                message: "Você não tem perguntas cadastradas, cadastre as perguntas para iniciar um Quiz!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popToRootViewController(animated: false)
            }))
            self.present(alert, animated: true, completion: nil)
        }
//        let vc = QuizViewController.loadStoryboard()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToConfigAction(_ sender: Any) {
        let vc = ConfigViewController.loadStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//extension HomeViewController: QuizManagerDelegate {
//    func showAlertError(msg: String) {
//        let alert = UIAlertController(
//            title: "Atenção",
//            message: msg,
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            self.navigationController?.popToRootViewController(animated: false)
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func startQuizGame() {
//                let vc = QuizViewController.loadStoryboard()
//                navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    
//}
