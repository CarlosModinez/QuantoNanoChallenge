//
//  InitialScreenViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {
    
    @IBOutlet weak var firstScreenView: UIView!
    
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstScreenView.layer.cornerRadius = 30.0
        
    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        gameScene.runnigAnimation = true
        gameScene.initialSetup()
        gameScene.initialScreenWasShowed = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
