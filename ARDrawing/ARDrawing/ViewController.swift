//
//  ViewController.swift
//  ARDrawing
//
//  Created by estech on 12/4/23.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var azulButton: UIButton!
    @IBOutlet weak var verdeButton: UIButton!
    @IBOutlet weak var rojoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
//        self.sceneView.showsStatistics = true
        
        self.sceneView.delegate = self
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let transform = pointOfView.transform
        
        let orientacion = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        let frontOfCamera: SCNVector3 = orientacion + location
        
        DispatchQueue.main.async {
            if self.azulButton.isHighlighted { // Mientras pulsamos, dibuja puntos azules
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                sphereNode.position = frontOfCamera
                sphereNode.name = "azul"
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else { // Si no pulsamos, muestra un puntero blanco
                let puntero = SCNNode(geometry: SCNSphere(radius: 0.005))
                puntero.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                puntero.name = "puntero"
                puntero.position = frontOfCamera
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "puntero" {
                        node.removeFromParentNode() // Eliminamos los nodos mientras nos movemos
                    }
                })
                
                self.sceneView.scene.rootNode.addChildNode(puntero)
            }
            
            
            if self.verdeButton.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                sphereNode.position = frontOfCamera
                sphereNode.name = "verde"
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            }
            
            
            if self.rojoButton.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                sphereNode.position = frontOfCamera
                sphereNode.name = "rojo"
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            }
            
        }
    }
    
    
    
    @IBAction func resetButtonAzul(_ sender: Any) {
        self.resetAzul()
    }
    
    @IBAction func resetButtonVerde(_ sender: Any) {
        self.resetVerde()
    }
    
    @IBAction func resetButtonRojo(_ sender: Any) {
        self.resetRojo()
    }
    
    
    func resetAzul() {
        self.sceneView.session.pause()
        //Eliminar nodos
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "azul" {
                node.removeFromParentNode()
            }
        }
        //Volver a ejecutar la sesión
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func resetVerde() {
        self.sceneView.session.pause()

        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "verde" {
                node.removeFromParentNode()
            }
        }

        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func resetRojo() {
        self.sceneView.session.pause()

        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "rojo" {
                node.removeFromParentNode()
            }
        }

        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    

}


func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
