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
    
    @IBOutlet weak var tapToPlayOutlet: UIButton!
    @IBOutlet weak var firstScreenView: UIView!
    
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstScreenView.layer.cornerRadius = 30.0
        authPlayer()
//        animationLabel()
    }
    
    func animationLabel() {
        UIView.animate(withDuration: 1, delay: 0, options: [UIButton.AnimationOptions.autoreverse, UIButton.AnimationOptions.repeat],
                                   animations: {

                                    self.tapToPlayOutlet.setTitleColor(UIColor.clear, for: .normal)
                                    print("1")
//        self.tapToPlayOutlet.titleLabel?.textColor.withAlphaComponent(0)
        }, completion: nil)
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
        gameScene.currentState = .game
        gameScene.runnigAnimation = true
        gameScene.intialScreenIsShowing = false
        gameScene.initialScreenWasShowed = true
        gameScene.initialSetup()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
