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
    
    var quizManager: QuizManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quizManager = QuizManager()
        viewTimer.frame.size.width = view.frame.size.width
        
        UIView.animate(withDuration: 60.0, delay: 0, options: .curveLinear) {
            self.viewTimer.frame.size.width = 0
        } completion: { (success) in
            self.showResults()
        }
        
        getNewQuiz()

    }
    
    func showResults(){
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! ResultViewController
        resultViewController.totalAnswers = quizManager.totalAnswers
        resultViewController.totalCorrectAnswers = quizManager.totalCorrectAnswers
    }
    
    func getNewQuiz() {
        quizManager.refreshQuiz()
        labelQuestion.text = quizManager.question
        for i in 0..<quizManager.options.count {
            let option = quizManager.options[i]
            let button = buttonAnswers[i]
            button.setTitle(option, for: .normal)
        }
    }
    
    
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        guard let index = buttonAnswers.firstIndex(of: sender) else {return}
        quizManager.validateAnswer(index: index)
        getNewQuiz()
    }
}
