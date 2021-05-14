//
//  QuizViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza on 14/05/21.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet var buttonAnswers: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func selectAnswer(_ sender: UIButton) {
    }
}
