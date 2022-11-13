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
        spawnShape()
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
    // MARK: LoadNode()
    func loadNode(_ node: SCNNode) {
        scnScene.rootNode.addChildNode(node)
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
    // MARK: SetupCam()
    func setupCam() {
        camNode = SCNNode()
        camNode.camera = SCNCamera()
        camNode.position = .init(0, 0, 10)
        loadNode(camNode)
    }
    // MARK: SpawnShape()
    func spawnShape() {
        var geometry: SCNGeometry
       //  var t: ShapeType = .torus
//        switch t {
//        case .box:
//            geometry = SCNBox(
//                width: 1,
//                height: 1,
//                length: 1,
//                chamferRadius: 0
//            )
//        case .sphere:
//        geometry = SCNSphere(
//            radius: 1
//        )
//        case .pyramid:
//            <#code#>
//        case .torus:
//            <#code#>
//        case .capsule:
//            <#code#>
//        case .cylinder:
//            <#code#>
//        case .cone:
//            <#code#>
//        case .tube:
//            <#code#>
//        }
        switch ShapeType.random {
        
        default:
            geometry = SCNBox(
                width: 1,
                height: 1,
                length: 1,
                chamferRadius: 0
            )
        }
        let geoNode = SCNNode(geometry: geometry)
        print(geoNode.geometry)
        loadNode(geoNode)
    }
}
