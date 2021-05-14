//
//  ResultViewController.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza on 14/05/21.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var labelAnswered: UILabel!
    @IBOutlet weak var labelCorrect: UILabel!
    @IBOutlet weak var labelWrong: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func close(_ sender: UIButton) {
    }
}
