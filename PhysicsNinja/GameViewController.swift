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
    var camNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCam()
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
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
        scnView.scene = scnScene
    }
    func setupCam() {
        camNode = SCNNode()
        camNode.camera = SCNCamera()
        camNode.position = .init(0, 0, 10)
        scnScene.rootNode.addChildNode(camNode)
        scnScene.rootNode.camera = camNode.camera
    }
}
