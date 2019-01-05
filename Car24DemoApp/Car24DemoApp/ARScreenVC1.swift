//
//  ARScreenVC1.swift
//  Car24DemoApp
//
//  Created by GeekGuns Developer on 05/01/19.
//  Copyright © 2019 GeekGuns. All rights reserved.
//

import UIKit
import ARKit
class ARScreenVC1: UIViewController {

    @IBOutlet weak var shipScreenView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shipScreenView.session.pause()
    }
    
    func setUpSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        shipScreenView.session.run(configuration)
        shipScreenView.delegate = self 
        shipScreenView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func configureLighting() {
        shipScreenView.autoenablesDefaultLighting = true
        shipScreenView.automaticallyUpdatesLighting = true
    }
    
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addShipToSceneView(withGestureRecognizer:)))
        shipScreenView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func addShipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: shipScreenView)
        let hitTestResults = shipScreenView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        print("hitTestResults>>>>>>>>>",hitTestResults)
        guard let hitTestResult = hitTestResults.first else {
            
            
            
            
            
            
            
            
            return }
        
        
        // check
        
        
        //        guard <#condition#> else {
        //            <#statements#>
        //        }
        
        print("hitTestResult1111111111",hitTestResult)
        print("hitTestResult.count",hitTestResults.count)
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        guard let shipScene = SCNScene(named: "ship.scn"),
            let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
            else { return }
        
        
        shipNode.position = SCNVector3(x,y,z)
        shipScreenView.scene.rootNode.addChildNode(shipNode)
    }
    
}

extension ARScreenVC1 : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.transparentLightBlue
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // 6
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // 1
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    
    
}

