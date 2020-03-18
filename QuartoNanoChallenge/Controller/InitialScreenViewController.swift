//
//  InitialScreenViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import GameKit

class InitialScreenViewController: UIViewController {
    
    @IBOutlet weak var firstScreenView: UIView!
    
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstScreenView.layer.cornerRadius = 30.0
        authPlayer()
        
    }
    
    func authPlayer () {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {
        (view, error) in
            if view != nil{
                self.present(view!, animated: true, completion: nil)
            }
            else {
                print("player ", GKLocalPlayer.local.isAuthenticated)
            }
        }

    }
    
    @IBAction func playBtnPressed(_ sender: Any) {
        gameScene.runnigAnimation = true
        gameScene.initialSetup()
        gameScene.initialScreenWasShowed = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
