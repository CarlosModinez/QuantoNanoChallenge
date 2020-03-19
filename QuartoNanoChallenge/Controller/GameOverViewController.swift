//
//  GameOverViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import GameKit
import GameplayKit

class GameOverViewController: UIViewController {


    //let gameOver = GameOverViewController()
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblCurrenntScore: UILabel!
    
    var gameScene: GameScene!
    var width : CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playAgainPressed(_ sender: Any) {
        gameScene.currentState = .game
        width = self.view.bounds.width
        gameScene.gameObjects.removeAll()
        gameScene.removeAllChildren()
        gameScene.boxes.removeAll()
        gameScene.disableBoxes.removeAll()
        gameScene.runnigAnimation = true
        gameScene.initialSetup()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateScore() {
        lblScore.text = String(Model.shared.bestScore)
        lblCurrenntScore.text = String(Model.shared.currentScore)
    }
    @IBAction func positionteste(_ sender: Any) {
        GameCenter.shared.showLeaderboard(presentingVC: )
    }
    
    @IBAction func goHomePressed(_ sender: Any) {
        gameScene.currentState = .initialView
        gameScene.showInitialScreen()
        self.dismiss(animated: false, completion: nil)
    }
}
