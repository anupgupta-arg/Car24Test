//
//  Extension.swift
//  Car24DemoApp
//
//  Created by GeekGuns Developer on 05/01/19.
//  Copyright © 2019 GeekGuns. All rights reserved.
//

import Foundation
import ARKit


extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}

extension UIViewController {
    
    func showAlert( message: String) {
        let title = "Car 24"
        let alertController = UIAlertController(title: title , message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
