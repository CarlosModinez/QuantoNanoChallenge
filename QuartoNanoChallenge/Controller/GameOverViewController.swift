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
import GoogleMobileAds

class GameOverViewController: UIViewController, GADInterstitialDelegate {
    
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
        GameCenter.shared.updateScore(with: Model.shared.bestScore)
    }
    

    func showGameOverAd() {
        //A frequência desse ad é de 1/3
        Model.shared.gameOverCount += 1
        if Model.shared.gameOverCount == 3 {
            Model.shared.gameOverCount = 0
            Model.shared.gameOverAd.present(fromRootViewController: self)
            loadGameOverAd()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // A frequência desse ad é 1/2
        let adSorter = Int.random(in: 0..<2)
        if Model.shared.currentCoins > 0 && adSorter == 0 {
           showAdPermission()
        }
    }
    
    func loadGameOverAd(){
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        // ID LOJA
        //"ca-app-pub-3143840922595951/9170978827"
        // ID TESTE
        //"ca-app-pub-3940256099942544/4411468910"
        interstitial.delegate = self
        interstitial.load(GADRequest())
        Model.shared.gameOverAd = interstitial
    }
    
    func showAdPermission() {
        let adPermissionViewController: AdPermissionViewController!
        let adPermissionView: UIStoryboard = UIStoryboard(name: "AdPermission", bundle: nil)
        adPermissionViewController = adPermissionView.instantiateViewController(withIdentifier: "AdView") as? AdPermissionViewController
        adPermissionViewController.gameScene = self.gameScene
        self.present(adPermissionViewController, animated: true, completion: nil)
    }
    
    @IBAction func playAgainPressed(_ sender: Any) {
        
        gameScene.removeAllChildren()
        
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = self
        
        let gameViewController: GameViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        gameViewController = gameView.instantiateViewController(withIdentifier: "gameView") as? GameViewController
        self.present(gameViewController, animated: false, completion: nil)
    }
    
    @IBAction func positionteste(_ sender: Any) {
        GameCenter.shared.showLeaderboard(presentingVC: self)
    }
    
    @IBAction func goHomePressed(_ sender: Any) {
        gameScene.removeAllChildren()
        
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = self
        
        let gameViewController: InitialScreenViewController!
        let gameView: UIStoryboard = UIStoryboard(name: "InitialScreen", bundle: nil)
        gameViewController = gameView.instantiateViewController(withIdentifier: "InitialScreen") as? InitialScreenViewController
        self.present(gameViewController, animated: false, completion: nil)
    }
}
