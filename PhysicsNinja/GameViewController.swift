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
        scnView.showsStatistics = true
        scnView.allowsCameraControl = true
        scnView.pointOfView = camNode
        scnView.autoenablesDefaultLighting = true
        
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
        switch ShapeType.random {
        case .box:
            geometry = SCNBox(
                width: 1,
                height: 1,
                length: 1,
                chamferRadius: 0
            )
        case .sphere:
            geometry = SCNSphere(
                radius: 1
            )
        case .pyramid:
            geometry = SCNPyramid(
                width: 1,
                height: 1,
                length: 1
            )
        case .torus:
            geometry = SCNTorus(
                ringRadius: 1.5,
                pipeRadius: 1
            )
        case .capsule:
            geometry = SCNCapsule(
                capRadius: 1.5,
                height: 1
            )
        case .cylinder:
            geometry = SCNCylinder(
                radius: 1,
                height: 1.5
            )
        case .cone:
            geometry = SCNCone(
                topRadius: 0,
                bottomRadius: 1,
                height: 1.5
            )
        case .tube:
            geometry = SCNTube(innerRadius: 1, outerRadius: 1.25, height: 1.5)
        }
        
        let geoNode = SCNNode(geometry: geometry)
        geoNode.position.y = -10
        geoNode.physicsBody = .init(type: .dynamic, shape: nil)
        geoNode.physicsBody?.applyForce(.init(-1, 10, 0), asImpulse: true)
        
        print(geoNode.geometry)
        loadNode(geoNode)
    }
}
