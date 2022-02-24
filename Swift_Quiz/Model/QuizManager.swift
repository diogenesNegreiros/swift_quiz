//
//  QuizManager.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza on 14/05/21.
//

import Foundation
import UIKit
import CoreData

class QuizManager {
    var quizes: [Question] = []
    
    private var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    private var fetchedResultController: NSFetchedResultsController<Question>!
    private var quiz = Question()
    private var _totalAnswers = 0
    private var _totalCorrectAnswers = 0
    
    var question: String {
        return quiz.statement ?? "????"
    }
    
    var options: [String?] {
        return [quiz.answer1, quiz.answer2, quiz.answer3, quiz.answer4]
    }
    
    var totalAnswers: Int {
        return _totalAnswers
    }
    
    var totalCorrectAnswers: Int {
        return _totalCorrectAnswers
    }
    
    var totalquizesElements: Int {
        return quizes.count
    }
    
    init() {
        loadAllQuizes()
    }
    
    func addNewQuiz(quiz: Question) {
        self.quizes.append(quiz)
    }
    
    func refreshQuiz(){
        if quizes.count != 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(quizes.count)))
            let quizData = quizes[randomIndex]
            quiz = Question(context: context)
            quiz.statement = quizData.statement
            quiz.answer1 = quizData.answer1
            quiz.answer2 = quizData.answer2
            quiz.answer3 = quizData.answer3
            quiz.answer4 = quizData.answer4
            quiz.answer = quizData.answer
            
            quizes.remove(at: randomIndex)
        }
    }
    
    func loadAllQuizes() {
        quizes = []
        context.reset()
        
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "statement", ascending: true)
        fetchRequest.sortDescriptors  = [sortDescritor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try fetchedResultController.performFetch()
            
            if let myQuizes = fetchedResultController.fetchedObjects {
                quizes = myQuizes
            }else {
                quiz = Question(context: self.context)
                quiz.statement = "Qual o nome desse App de Perguntas e respostas?"
                quiz.answer1 = "Quiz Manager"
                quiz.answer2 = "Quiz Brazuca"
                quiz.answer3 = "Study Quiz"
                quiz.answer4 = "Swift Quiz"
                quiz.answer = "Swift Quiz"
                
                self.quizes.append(self.quiz)
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func validateAnswer(index: Int) {
        _totalAnswers += 1
        if self.options[index]  == quiz.answer {
            _totalCorrectAnswers += 1
        }
    }
}
