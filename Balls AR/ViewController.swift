//
//  ViewController.swift
//  Balls AR
//
//  Created by Admin on 11/20/17.
//  Copyright © 2017 Jason Lee. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreGraphics

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitResult = result.last else {return}
        let hitTransform = SCNMatrix4.init(hitResult.worldTransform)
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        createBall(position: hitVector)
    }

    
    func createBall(position: SCNVector3){
        let ballShape = SCNSphere(radius: 0.1)
        let color = SCNMaterial()
        color.diffuse.contents = UIColor.random()
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
        ballShape.materials = [color]
        let ballNode = SCNNode(geometry: ballShape)
        ballNode.position = position
 
        sceneView.scene.rootNode.addChildNode(ballNode)
//        ballNode.runAction(SCNAction.rotateBy(x: 1, y: 0, z: 0, duration: 1))
        ballNode.runAction(SCNAction.moveBy(x: 2, y: 0, z: 0, duration: 1))
    }
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(),
                        green: .random(),
                        blue: .random(),
//                        yellow: .random(),
//                        orange: .random(),
//                        purple: .random(),
                        alpha: 1.0)
    }
}
