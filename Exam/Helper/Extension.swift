//
//  Extension.swift
//  Exam
//
//  Created by Wade Wang on 2020/11/7.
//

import UIKit

extension UIViewController {
    func showError(_ error: Error) {
        let alertView = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Okey", style: .default, handler: nil)
        alertView.addAction(confirm)
        DispatchQueue.main.async {
            self.present(alertView, animated: true, completion: nil)
        }
    }
}


