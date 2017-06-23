//
//  GameViewController.swift
//  Footballgame
//
//  Created by infuntis on 19/06/17.
//  Copyright © 2017 gala. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameOverDelegate {
    
    internal func gameOver(score: Int) {
        gameOverView.isHidden = false
        gameOverLblScore.text = "\(score)"
    }

    
    @IBOutlet weak var gameOverLblScore: UILabel!
    var scene: GameScene!
    
    @IBAction func restartBtnAct(_ sender: Any) {
        beginGame()
    }
    
    @IBOutlet weak var gameOverView: UIView!
    func beginGame(){
        gameOverView.isHidden = true
        let skView = view as! SKView
        //skView.isMultipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        scene = GameScene(size: skView.bounds.size)
        scene.gameOverDel = self
        scene.addBall()
        scene.addGround()
        skView.presentScene(scene)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        beginGame()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
