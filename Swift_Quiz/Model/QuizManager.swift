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
    
    var quest = Question()
    
    var quizes: [Question] = []

    
//    private var quizes: [(question: String, correctAnswer: String, options: [String])] = [
//        (question: "Quais desses é string?", correctAnswer: "\"Olá mundo\"",
//         options: ["20", "\"Olá mundo\"", "Olá mundo", "'Olá mundo'"]),
//        (question: "Qual é o resultado da expressão \"1\" + \"1\"", correctAnswer: "\"11\"",
//         options: ["11", "\"2\"", "\"11\"", "\"1 1\""]),
//        (question: "Qual desses símbolos é usado para \"escapar\" caracteres especiais", correctAnswer: "\\",
//         options: ["/", "\\", "!", "ESC"]),
//        (question: "Qual a sintaxe correta para declarar uma função?", correctAnswer: "func myFunction() {}",
//         options: ["func = myFunction() {}", "let myFunction = func() {}", "let func = myFunction() {}", "func myFunction() {}"]),
//        (question:
//            """
//                 Qual a saída desse código?
//                   func printSomething() {
//                      print("Adoro funções")
//                   }
//                   printSomething()
//                """, correctAnswer: "Adoro funções",
//         options: ["Nada", "printSomething()", "Adoro funções", "Erro"]),
//        (question: "Quando não declaramos o tipo de retorno de uma função, qual é o retorno padrão?", correctAnswer: "Void",
//         options: ["Void", "Int", "String", "nil"]),
//        (question: "Qual é a sintaxe correta para declarar um parâmetro?", correctAnswer: "func myFunc(message: String) {}",
//         options: ["func myFunc(String message) {}", "func myFunc(let message = String) {}", "func myFunc(message String) {}", "func myFunc(message: String) {}"]),
//
//        (question: "Qual é o tipo de uma variavél String que pode aceitar nil?", correctAnswer: "String?",
//         options: ["String", "String?", "Int", "Void"]),
//        (question: "Quando queremos declarar uma constante, qual palavra reservada devemos usar?", correctAnswer: "let",
//         options: ["var", "const", "let", "CONST"]),
//        (question: "O que é um dicionário?", correctAnswer: "É uma coleção não-ordenada com chave e valor",
//         options: ["É uma coleção que não aceita objetos repetidos", "É uma coleção ordenada com chave e valor", "É uma coleção não-ordenada com chave e valor", "É uma coleção que permite valores de tipos diferentes"]),
//        (question: "Qual o nome do tipo especial em Swift que é usado para declarar blocos ou funções anônimas?", correctAnswer: "Closure",
//         options: ["Lambda", "Block", "Closure", "Protocol"]),
//        (question: "O que é um enum?", correctAnswer: "Tipo definido pelo usuário para um grupo de valores relacionados",
//         options: ["É um conjunto de Strings", "É um tipo especial de String", "É um operador unário do tipo prefix", "Tipo definido pelo usuário para um grupo de valores relacionados"]),
//        (question: "O que uma extension não pode fazer?", correctAnswer: "Adicionar propriedades armazenadas",
//         options: ["Adicionar novas funcionalidades", "Definir novos construtores", "Adicionar propriedades armazenadas", "Adicionar propriedades computadas"]),
//        (question: "Quando herdamos de uma classe e queremos chamar o seu construtor, usamos...", correctAnswer: "super.init",
//         options: ["main.init", "super.init", "self.init", "super"]),
//    ]
    
    var context: NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var fetchedResultController: NSFetchedResultsController<Question>!
    
    private var quiz: Question!
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
        print("")
        
        self.quiz = Question(context: self.context)
//        self.quest = Question(context: self.context)
//        
//        self.quest.answer1 = "an 1"
//        self.quest.answer2 = "an 2"
//        self.quest.answer3 = "an 3"
//        self.quest.answer4 = "an 4"
//        self.quest.statement = "Pergunta ?"
//        self.quest.answer = "an 1"
//
//        self.quizes.append(self.quest)
        
//        if let defaultQuizes = UserDefaults.standard.value(forKey: "quizes") {
//            self.quizes = defaultQuizes as! [(question: String, correctAnswer: String, options: [String])]
//        }
        
//        UserDefaults.standard.set(quizes, forKey: "quizes")
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
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "statement", ascending: true)
        fetchRequest.sortDescriptors  = [sortDescritor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultController.delegate = self
        do{
        try fetchedResultController.performFetch()
            self.quizes = fetchedResultController.fetchedObjects ?? []
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
