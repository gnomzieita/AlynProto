//
//  ViewController.swift
//  AlynProto
//
//  Created by Alex Agarkov on 03.04.2021.
//

import UIKit
import ResearchKit
import CareKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manager = appDelegate.synchronizedStoreManager
        //let careViewController = UINavigationController(rootViewController: CareViewController(storeManager: manager))

        present(CareViewController(storeManager: manager), animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
}

