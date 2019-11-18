//
//  StartScreenViewController.swift
//  MaristCampusMap
//
//  Created by Jenna Daly on 10/13/19.
//  Copyright © 2019 Jenna Daly. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    @IBAction func onStartClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mainScreenSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainScreenSegue" {
            var vc = segue.destination as! MainScreenViewController
            vc.modalPresentationStyle = .fullScreen
        }
    }
    
    
}
