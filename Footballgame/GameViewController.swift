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
import FBSDKLoginKit

class GameViewController: UIViewController, GameOverDelegate {
    
    internal func gameOver(score: Int) {
        gameOverView.isHidden = false
        gameOverLblScore.text = "\(score)"
    }

    @IBOutlet weak var facebookBtn: UIButton!
    
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
    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("Did log out of facebook")
//    }
//    
//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print(error)
//            return
//        }
//        
//        print("Successfully logged in with facebook...")
//    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        beginGame()
        facebookBtn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    func handleCustomFBLogin() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err)
                return
            }
            
            self.showEmailAddress()
        }
    }
    
    func showEmailAddress() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err)
                return
            }
            print(result)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
