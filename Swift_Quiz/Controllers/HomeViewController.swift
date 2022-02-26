//
//  HomeViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 26/02/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func startQuizAction(_ sender: Any) {
        let vc = QuizViewController.loadStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToConfigAction(_ sender: Any) {
        let vc = ConfigViewController.loadStoryboard()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
