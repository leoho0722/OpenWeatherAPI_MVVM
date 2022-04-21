//
//  Alert.swift
//  MVVM Demo
//
//  Created by Leo Ho on 2022/4/21.
//  Copyright © 2022 Leo Ho. All rights reserved.
//

import UIKit

class Alert {
    func yesAlert(title: String?, message: String?, confirmTitle: String?, vc: UIViewController, completionHandler: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { action in
            completionHandler?()
        }
        alertVC.addAction(confirmAction)
        vc.present(alertVC, animated: true, completion: nil)
    }
}
