//
//  GameViewController.swift
//  Lab5
//
//  Created by James Park on 4/18/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //create the view
        if let view = self.view as! SKView? {
            //create the scene
            let scene = GameScene(size: CGSize(width: 1336, height: 1024))

            //set the scale mode to scale to fill the view window
            scene.scaleMode = .aspectFill

            //set the background color
            scene.backgroundColor = UIColor(red: 105/255, green: 157/255, blue: 181/255, alpha: 1.0)

            //present the scene
            view.presentScene(scene)

            //set the view options
            view.ignoresSiblingOrder = false
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
