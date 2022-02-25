//
//  QuizViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza on 14/05/21.
//

import UIKit
import CoreData

class QuizViewController: UIViewController {
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet var buttonAnswers: [UIButton]!
    @IBOutlet weak var viewBackgroundTimer: UIView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var viewOptions: UIView!
    
    var time: Double = 30.0
    var timeRedZone: Double = 7.5
    var quizManager: QuizManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager = QuizManager()
        viewTimer.frame.size.width = view.frame.size.width
        
        if quizManager.totalquizesElements > 0 {
            hideViews(isHide: false)
            self.viewTimer.backgroundColor = .blue
            UIView.animate(withDuration: time, delay: 0, options: .curveLinear) {
                //            DispatchQueue.main.asyncAfter(deadline: .now() + self.time - 10.0) {
                //                self.viewTimer.backgroundColor = .red
                //            }
                self.viewTimer.backgroundColor = .red
                self.viewTimer.frame.size.width = 0
            } completion: { (success) in
                self.showResults()
            }
            getNewQuiz()
        }else {
            hideViews(isHide: true)
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
    }
    
    @objc func backHome() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func showResults(){
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    func hideViews(isHide: Bool) {
        viewTimer.isHidden = isHide
        labelQuestion.isHidden = isHide
        viewBackgroundTimer.isHidden = isHide
        endButton.isHidden = isHide
        viewOptions.isHidden = isHide
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! ResultViewController
        resultViewController.totalAnswers = quizManager.totalAnswers
        resultViewController.totalCorrectAnswers = quizManager.totalCorrectAnswers
        resultViewController.delegate = self
    }
    
    func getNewQuiz() {
        
        if quizManager.totalquizesElements == 0 {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }else{
            quizManager.refreshQuiz()
            labelQuestion.text = quizManager.question
            
            for i in 0..<quizManager.options.count {
                let option = quizManager.options[i]
                let button = buttonAnswers[i]
                button.setTitle(option, for: .normal)
            }
        }
    }
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        guard let index = buttonAnswers.firstIndex(of: sender) else {return}
        quizManager.validateAnswer(index: index)
        
        if quizManager.totalquizesElements == 0 {
            showResults()
        }else{
            getNewQuiz()
        }
    }
}

extension QuizViewController {
    
    class func loadStoryboard() -> QuizViewController {
        return UIStoryboard(name: "main", bundle: nil).instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
    }
}

extension QuizViewController: ResultViewControllerDelegate {
    func goToRootController() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
}
