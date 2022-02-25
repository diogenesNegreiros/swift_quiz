//
//  ViewControle+Alertas.swift
//  Swift_Quiz
//
//  Created by Diogenes de Souza Negreiros on 25/02/22.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showErrorAlert(title: String, subTitle: String) {
        let alert = UIAlertController(
            title: title,
            message: subTitle,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //completion: @escaping (Result?, Bool, String?) -> Void
    
    func showOptionAlert(title: String, subTitle: String, confirmClosure: @escaping (()->())) {
        let alert = UIAlertController(
            title: title,
            message: subTitle,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            confirmClosure()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
