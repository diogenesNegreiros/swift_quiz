//
//  QuizManager.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza on 14/05/21.
//

import Foundation
import UIKit
import CoreData

//protocol QuizManagerDelegate: AnyObject {
//    func showAlertError(msg: String)
//    func startQuizGame()
//}

class QuizManager {
    static var shared: QuizManager = {
        let instance = QuizManager()
        instance.loadAllQuizes()
        instance.quiz = Question()
        
        return instance
    }()
    
//    weak var delegate: QuizManagerDelegate?
    var quizes: [Question] = []
    var totalQuizesInDataBase: Int = 0
    
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
        return [quiz.answer1 , quiz.answer2, quiz.answer3, quiz.answer4]
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
    
//    init() {
//        loadAllQuizes()
//    }
    
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
            quiz.correctIndex = quizData.correctIndex
            
            quizes.remove(at: randomIndex)
        }
    }
    
    func loadGetAllQuizes() ->[Question] {
//        quizes = []
//        context.reset()
        
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "statement", ascending: true)
        fetchRequest.sortDescriptors  = [sortDescritor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try fetchedResultController.performFetch()
            
            if let myQuizes = fetchedResultController.fetchedObjects {
               return myQuizes
                
            }
        }catch {
            print(error.localizedDescription)
//            delegate?.showAlertError(msg: "Erro na recuperação dos dados do banco!")
        }
        return []
    }
    
    func loadAllQuizes() {
//        quizes = []
        context.reset()
        
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "statement", ascending: true)
        fetchRequest.sortDescriptors  = [sortDescritor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try fetchedResultController.performFetch()
            
            if let myQuizes = fetchedResultController.fetchedObjects {
                self.totalQuizesInDataBase = myQuizes.count
                
                if myQuizes.count > 0 {
                    quizes = myQuizes
//                    delegate?.startQuizGame()
                }else {
//                    delegate?.showAlertError(msg: "Você não tem perguntas cadastradas!")
                }
                
            }else {
//                delegate?.showAlertError(msg: "Erro na recuperação dos dados do banco!")
            }
        }catch {
            print(error.localizedDescription)
//            delegate?.showAlertError(msg: "Erro na recuperação dos dados do banco!")
        }
    }
    
    func validateAnswer(index: Int) {
        _totalAnswers += 1
        if String(index + 1)  == quiz.correctIndex {
            _totalCorrectAnswers += 1
        }
    }
}
