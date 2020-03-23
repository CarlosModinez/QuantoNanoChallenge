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
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblCurrenntScore: UILabel!
    
    
    var gameScene: GameScene!
    var width : CGFloat!
    var gameViewController: GameViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScene.runnigAnimation = false
        lblScore.text = String(Model.shared.bestScore)
        lblCurrenntScore.text = String(Model.shared.currentScore)
    }
    
    @IBAction func playAgainPressed(_ sender: Any) {
        
        gameScene.removeAllChildren()
        
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = self
        
        let gameViewController: GameViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        gameViewController = gameView.instantiateViewController(withIdentifier: "gameView") as? GameViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
    
    @IBAction func positionteste(_ sender: Any) {
        let cenaGame = GameScene()
        let gameover = GameOverViewController()
        cenaGame.openGameCenter(view: (gameover))
        let gcvc = GKGameCenterViewController()
        gcvc.viewState = .leaderboards
        gcvc.leaderboardIdentifier = "akira.123.com.scores"
        present(gcvc, animated: true, completion: nil)
    }
    
    @IBAction func goHomePressed(_ sender: Any) {
        let gameViewController: InitialScreenViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "InitialScreen", bundle: nil)
        gameViewController = gameView.instantiateViewController(withIdentifier: "InitialScreen") as? InitialScreenViewController
        self.present(gameViewController, animated: true, completion: nil)
    }
}

extension GameOverViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

}
