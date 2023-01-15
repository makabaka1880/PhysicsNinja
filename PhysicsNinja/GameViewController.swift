//
//  GameViewController.swift
//  PhysicsNinja
//
//  Created by SeanLi on 2022/11/13.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var deltat: TimeInterval = 0
    var dt: TimeInterval = 1
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime t: TimeInterval) {
        if t > deltat {
            spawnShape()
            game.updateHUD()
            deltat = t + dt
            dt = .random(in: 0...5)
        }
        game.updateHUD()
        cleanScene()
    }

    var scnView: SCNView!
    var scnScene: SCNScene!
    var camNode: SCNNode!
    var game = GameHelper.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCam()
        spawnShape()
        setupHUD()
        scnView.delegate = self
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        spawnShape()
    }
    
    func cleanScene() {
        for i in scnScene.rootNode.childNodes {
            if i.presentation.position.y < -20 {
                i.removeFromParentNode()
            }
        }
    }
    
    // MARK: SetupView()
    func setupView() {
        
        scnView = (self.view as! SCNView)
        scnView.showsStatistics = true
        scnView.allowsCameraControl = false
        scnView.pointOfView = camNode
        scnView.autoenablesDefaultLighting = true
        
    }
    // MARK: SetupHUD()
    func setupHUD() {
        game.hudNode.position = SCNVector3(0, 0, 0)
        scnScene.rootNode.addChildNode(game.hudNode)
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
        camNode.position = .init(0, 5, 10)
        camNode.camera?.fieldOfView = 90
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
        var offset = Float.random(in: -50...50)
        var particle = SCNParticleSystem(named: "Trail.scnp", inDirectory: nil)
        let ran = UIColor.random()
        particle?.particleColor = ran
        geoNode.addParticleSystem(particle!)
        geoNode.position.y = -20
        geoNode.position.x = offset
        geoNode.physicsBody = .init(type: .dynamic, shape: nil)
        geoNode.physicsBody?.applyForce(.init(-offset*2/3, 25, 0), asImpulse: true)
        geoNode.geometry?.firstMaterial?.diffuse.contents = ran
        print(geoNode.geometry)
        if [.black, .red, .blue].contains(ran) {
            geoNode.name = "BAD"
        } else {
            geoNode.name = "GOOD"
        }
        loadNode(geoNode)
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            geoNode.removeFromParentNode()
        }
    }
    
    // MARK: HandleTouchFor()
    func handleTouchFor(node: SCNNode) {
        if node.name == "GOOD" {
            game.score += 1
            createExplosion(geometry: node.geometry!, pos: node.presentation.position, rotation: .init(x: 0, y: 0, z: 0, w: 0), color: node.geometry!.firstMaterial!.diffuse.contents as! UIColor)
        } else if node.name == "BAD" {
            game.score -= 1
        } else if node.name != "HUD" {
            fatalError("NODE NOT IDENTIFIED: \(node), Named \(node.name)")
        }
        createExplosion(geometry: node.geometry!, pos: node.presentation.position, rotation: node.rotation, color: node.geometry!.firstMaterial!.diffuse.contents as! UIColor)
        node.removeFromParentNode()
    }
    
    
    // MARK: CreateExplosion()
    func createExplosion(geometry: SCNGeometry, pos: SCNVector3, rotation: SCNVector4, color: UIColor) {
        let particle = SCNParticleSystem(named: "Explode.scnp", inDirectory: nil)!
        particle.emitterShape = geometry
        particle.birthLocation = .surface
        
        let transformationMatrix = SCNMatrix4MakeRotation(
            rotation.w,
            rotation.x,
            rotation.y,
            rotation.z
        )
        
        let translationMatrix = SCNMatrix4MakeTranslation(
            pos.x,
            pos.y,
            pos.z
        )
        
        scnScene.addParticleSystem(particle, transform: SCNMatrix4Mult(transformationMatrix, translationMatrix))
        
        particle.particleColor = color
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let loc = touch.location(in: scnView)
        let hitReults = scnView.hitTest(loc)
        if let result = hitReults.first {
            handleTouchFor(node: result.node)
        }
    }
}

//extension GameViewController: SCNSceneRendererDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        spawnShape()
//    }
//}
