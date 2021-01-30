//
//  UIAlertController + ApplicationAlert.swift
//  ItunesForaSoftTest
//
//  Created by Александр on 27.01.2021.
//

import UIKit

// MARK: - StandartAlert
extension UIAlertController {
    
    static func applicationErrorAlert(controllerTitle cTitle: String?,
                                      cotrollerMessage message: String?,
                                      actionTitle aTitle: String?,
                                      cancelActionTitle caTitle: String?,
                                      actionHandler: ((UIAlertAction) -> Void)? = nil,
                                      cancelHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: cTitle, message: message, preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: aTitle, style: .default, handler: actionHandler)
        let cancelAction = UIAlertAction(title: caTitle, style: .destructive, handler: cancelHandler)
        
        alertController.addAction(cancelAction)
        alertController.addAction(reloadAction)
        
        return alertController
    }
}
