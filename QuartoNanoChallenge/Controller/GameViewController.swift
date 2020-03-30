//
//  GameViewController.swift
//  Primeiro Nano Challenge
//
//  Created by Carlos Modinez on 20/01/20.
//  Copyright © 2020 Carlos Modinez. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var width: CGFloat!
    var height: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.bounds.width
        height = self.view.bounds.height
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene"){
        
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                sceneNode.size = CGSize(width: width * 1.9, height: height * 1.8)
                
                sceneNode.gameViewController = self
                // Copy gameplay related content over to the scene
            
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = false
                    view.showsNodeCount = false
                    view.showsPhysics = false
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

