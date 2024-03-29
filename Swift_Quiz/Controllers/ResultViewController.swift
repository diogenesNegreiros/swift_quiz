//
//  ResultViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza on 14/05/21.
//

import UIKit

protocol ResultViewControllerDelegate: AnyObject {
    func goToRootController()
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var labelAnswered: UILabel!
    @IBOutlet weak var labelCorrect: UILabel!
    @IBOutlet weak var labelWrong: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    
    var totalCorrectAnswers: Int = 0
    var totalAnswers: Int = 0
    weak var delegate: ResultViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelAnswered.text = "Perguntas respondidas: \(totalAnswers)"
        labelCorrect.text = "Perguntas corretas: \(totalCorrectAnswers)"
        labelWrong.text = "Perguntas incorretas: \(totalAnswers - totalCorrectAnswers)"
        
        if totalAnswers != 0 {
            let score = totalCorrectAnswers * 100 / totalAnswers
            labelScore.text = "\(score)%"
        }else{
            labelScore.text = "0%"
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        delegate?.goToRootController()
    }
}
