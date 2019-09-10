//
//  ViewController.swift
//  SafariAR
//
//  Created by Thor Remiendo on 28/08/2019.
//  Copyright © 2019 ZET. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {
   
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/animal.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let arImages = ARReferenceImage.referenceImages(inGroupNamed: "Animal Cards", bundle: nil)
            else{ return }
        configuration.trackingImages = arImages
        configuration.maximumNumberOfTrackedImages = 2

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else { return }
        if let imageAnchor = anchor as? ARImageAnchor{
        
        //container
        if imageAnchor.referenceImage.name == "elephant-card"{
                guard let elephantContainer = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else { return }
                
                elephantContainer.removeFromParentNode()
                node.addChildNode(elephantContainer)
                elephantContainer.isHidden = false
            
                let physicalWidth = imageAnchor.referenceImage.physicalSize.width
                let physicalHeight = imageAnchor.referenceImage.physicalSize.height
            
                // Create a plane geometry to visualize the initial position of the detected image
                let mainPlane = SCNPlane(width: physicalWidth, height: physicalHeight)
                mainPlane.firstMaterial?.colorBufferWriteMask = .alpha
            
                // Create a SceneKit root node with the plane geometry to attach to the scene graph
                // This node will hold the virtual UI in place
                let mainNode = SCNNode(geometry: mainPlane)
                mainNode.eulerAngles.x = -.pi / 2
                mainNode.renderingOrder = -1
                mainNode.opacity = 1
            
                // Add the plane visualization to the scene
                node.addChildNode(mainNode)
                displayWebView(on: mainNode, xOffset: physicalWidth)
        
            
                
        
            }
        if imageAnchor.referenceImage.name == "rhino-card"{
                guard let rhinoContainer = sceneView.scene.rootNode.childNode(withName: "container2", recursively: false) else { return }
                
                rhinoContainer.removeFromParentNode()
                node.addChildNode(rhinoContainer)
                rhinoContainer.isHidden = false
                
            }
            
        
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor{

            if imageAnchor.referenceImage.name == "elephant-card"{
                let videoNode = SKVideoNode(fileNamed: "elephant.mp4")
                videoNode.play()
                
                let videoScene = SKScene(size: CGSize(width: 1080, height: 720))
                videoNode.position = CGPoint(x: videoScene.size.width / 2 , y: videoScene.size.height / 2)
                videoNode.yScale = -1.0
                videoScene.addChild(videoNode)
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                plane.firstMaterial?.diffuse.contents = videoScene
            
                let planeNode = SCNNode(geometry: plane)
                
                planeNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(planeNode)
            }
            if imageAnchor.referenceImage.name == "rhino-card"{
                let videoNode = SKVideoNode(fileNamed: "rhinos.mp4")
                videoNode.play()
                
                let videoScene = SKScene(size: CGSize(width: 1080, height: 720))
                videoNode.position = CGPoint(x: videoScene.size.width / 2 , y: videoScene.size.height / 2)
                videoNode.yScale = -1.0
                videoScene.addChild(videoNode)
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                plane.firstMaterial?.diffuse.contents = videoScene
                
                let planeNode = SCNNode(geometry: plane)
                
                planeNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(planeNode)
                
            }
            
        }
        
        
        return node
        
    }
    func displayWebView(on rootNode: SCNNode, xOffset: CGFloat) {
        // Xcode yells at us about the deprecation of UIWebView in iOS 12.0, but there is currently
        // a bug that does now allow us to use a WKWebView as a texture for our webViewNode
        // Note that UIWebViews should only be instantiated on the main thread!
        DispatchQueue.main.async {
            let request = URLRequest(url: URL(string: "https://www.worldwildlife.org/species/african-elephant#overview")!)
            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 480, height: 720))
            webView.loadRequest(request)
            
            let webViewPlane = SCNPlane(width: xOffset, height: xOffset * 1.4)
            webViewPlane.cornerRadius = 0
            
            let webViewNode = SCNNode(geometry: webViewPlane)
            webViewNode.geometry?.firstMaterial?.diffuse.contents = webView
            webViewNode.position.z -= 0
            webViewNode.position.y -= 0.01
            webViewNode.opacity = 0
            
            rootNode.addChildNode(webViewNode)
            webViewNode.runAction(.sequence([
                .wait(duration: 3.0),
                .fadeOpacity(to: 1.0, duration: 1.5),
                .moveBy(x: xOffset * 1.1, y: 0, z: -0.05, duration: 1.5),
                .moveBy(x: 0, y: 0, z: -0.05, duration: 0.2)
                ])
            )
        }
    }
   
}
