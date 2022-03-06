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
    @IBOutlet weak var viewBackgroundTimer: UIView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tableViewOptions: UITableView!
    
    var currentQuestions:[String?] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableViewOptions.reloadData()
            }
        }
    }
    
    var timeMinutesRemaining: Int = 1 {
        didSet {
            DispatchQueue.main.async {
                self.timerLabel.text = "tempo restante: \(self.timeMinutesRemaining):\(self.timeSecondsRemaining)"
            }
            
        }
    }
    var timerMinutes: Timer!
    
    var timeSecondsRemaining: Int = 60 {
        didSet {
            DispatchQueue.main.async {
                let str = String(format: "%02d", self.timeSecondsRemaining)
                self.timerLabel.text = "tempo restante:  \(self.timeMinutesRemaining):\(str)"
            }
            
        }
    }
    var timerSeconds: Timer!
    
    var allTimeInSeconds: Double = 60.0
    var totalNumberChosen = 1
    
    var quizManager = QuizManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func endQuizbuttonAction(_ sender: Any) {
        showResults()
    }
    
    @IBAction func backToHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizManager.loadAllQuizes()
        //        quizManager = QuizManager.shared
        
        self.totalNumberChosen = UserDefaults.standard.integer(forKey: "numberOfQuestions")
        self.timeMinutesRemaining = UserDefaults.standard.integer(forKey: "timeMinutes")
        self.allTimeInSeconds = Double(timeMinutesRemaining * 60)
        
        DispatchQueue.main.async {
            self.timerLabel.text = "tempo restante: \(self.timeMinutesRemaining):00"
        }
        
        
        viewTimer.frame.size.width = view.frame.size.width
        
        if quizManager.totalquizesElements > 0 {
            
            hideViews(isHide: false)
            self.viewTimer.backgroundColor = .blue
            
            UIView.animate(withDuration: allTimeInSeconds, delay: 0, options: .curveLinear) {
                
                self.timeMinutesRemaining -= 1
                self.timerMinutes = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.self.stepMinutes), userInfo: nil, repeats: true)
                self.timerSeconds = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.stepSeconds), userInfo: nil, repeats: true)
                
                
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
    
    @objc func stepMinutes() {
        if timeMinutesRemaining > 0 {
            timeMinutesRemaining -= 1
        }else {
            timerMinutes.invalidate()
        }
    }
    
    @objc func stepSeconds() {
        if timeSecondsRemaining > 1 {
            timeSecondsRemaining -= 1
        }else {
            timeSecondsRemaining = 60
        }
        
        if timeSecondsRemaining == 1 && timeMinutesRemaining == 0 {
            timerSeconds.invalidate()
        }
    }
    
    func showResults(){
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    func hideViews(isHide: Bool) {
        viewTimer.isHidden = isHide
        //        labelQuestion.isHidden = isHide
        viewBackgroundTimer.isHidden = isHide
        endButton.isHidden = isHide
        tableViewOptions.isHidden = isHide
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController = segue.destination as! ResultViewController
        resultViewController.totalAnswers = quizManager.totalAnswers
        resultViewController.totalCorrectAnswers = quizManager.totalCorrectAnswers
        resultViewController.delegate = self
    }
    
    func getNewQuiz() {
        
        if quizManager.totalquizesElements == quizManager.totalQuizesInDataBase - totalNumberChosen  {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }else{
            quizManager.refreshQuiz()
            self.currentQuestions = quizManager.options
        }
    }
}

extension QuizViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = currentQuestions[indexPath.row]
        cell?.textLabel?.numberOfLines = 0
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        quizManager.validateAnswer(index: indexPath.row)
        if quizManager.totalquizesElements == 0 {
            showResults()
        }else{
            getNewQuiz()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let str = "\(quizManager.question )\n"
        return str
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableView.estimatedSectionHeaderHeight = 36;
        return UITableView.automaticDimension
    }
    
}

extension QuizViewController {
    
    class func loadStoryboard() -> QuizViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
    }
}

extension QuizViewController: ResultViewControllerDelegate {
    func goToRootController() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
}
