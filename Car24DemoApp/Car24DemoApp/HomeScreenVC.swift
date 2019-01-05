//
//  HomeScreenVC.swift
//  Car24DemoApp
//
//  Created by Uniqolabel Developer on 05/01/19.
//  Copyright © 2019 GeekGuns. All rights reserved.
//

import UIKit
import ARKit
class HomeScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func moveToScreen2(_ sender: Any) {
        if (ARConfiguration.isSupported) {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "ARScreen", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ARScreenVCID") as! ARScreenVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            showAlert(message: "Your Device is not Supporting AR (Augmented Reality)")
        }
    }
    

}
