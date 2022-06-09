//
//  ViewController+ARSCNViewDelegate.swift
//  ARQuickLookKitSample
//
//  Created by 蘇健豪 on 2022/5/27.
//

import ARKit
import ARQuickLookKit

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let object = virtualObjectLoader.loadedObjects.first {
            autoPlace(object, at: anchor)
        }
    }
    
}
