//
//  GameOverViewController.swift
//  QuartoNanoChallenge
//
//  Created by Carlos Modinez on 12/03/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblCurrenntScore: UILabel!
    
    var gameScene: GameScene!
    var width : CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playAgainPressed(_ sender: Any) {
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
}
