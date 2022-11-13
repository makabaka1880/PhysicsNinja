//
//  GameViewController.swift
//  PhysicsNinja
//
//  Created by SeanLi on 2022/11/13.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var scnView: SCNView!
    var scnScene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    // MARK: SetupView()
    func setupView() {
        scnView = (self.view as! SCNView)
    }
    // MARK: SetupScene()
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
}
