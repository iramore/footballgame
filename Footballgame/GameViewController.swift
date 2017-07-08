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
import GameKit

class GameViewController: UIViewController, GameOverDelegate, GKGameCenterControllerDelegate {
    
    
    @IBAction func gcLeaderboardPressed(_ sender: Any) {
        saveHighscore(number: Int(gameOverLblScore.text!)!)
        showLeaderBoard()
    }
    
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
       // scene.addDanger()
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
        authPlayer()
      //  facebookBtn.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
//    func handleCustomFBLogin() {
//        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
//            if err != nil {
//                print("Custom FB Login failed:", err)
//                return
//            }
//            
//            
//            self.showEmailAddress()
//        }
//    }
    
//    func showEmailAddress() {
//        let accessToken = FBSDKAccessToken.current()
//        guard let accessTokenString = accessToken?.tokenString else { return }
//        
//        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
//        Auth.auth().signIn(with: credentials, completion: { (user, error) in
//            if error != nil {
//                print("Something went wrong with our FB user: ", error ?? "")
//                return
//            }
//            
//            print("Successfully logged in with our user: ", user ?? "")
//        })
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
//            
//            if err != nil {
//                print("Failed to start graph request:", err)
//                return
//            }
//            print(result)
//        }
//    }
    
    
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (view, error) in
            if view != nil {
                self.present(view!, animated: true, completion: nil)
            }
            else {
                print(GKLocalPlayer.localPlayer().isAuthenticated)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    func saveHighscore(number : Int){
        
        if GKLocalPlayer.localPlayer().isAuthenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "leaderboard")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.report(scoreArray, withCompletionHandler: nil)
            
        }
        
        
    }
    
    func showLeaderBoard(){
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController?.present(gcvc, animated: true, completion: nil)
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
