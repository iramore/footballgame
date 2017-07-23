//
//  StartViewController.swift
//  Footballgame
//
//  Created by infuntis on 23/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import UIKit
import GameKit

class StartViewController: UIViewController, GKGameCenterControllerDelegate {
    @IBAction func showLB(_ sender: Any) {
        showLeaderBoard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authPlayer()
    }
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
    
    func showLeaderBoard(){
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        gcvc.gameCenterDelegate = self
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
}
