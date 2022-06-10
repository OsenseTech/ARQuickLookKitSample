//
//  ARViewController+ARSCNViewDelegate.swift
//  SwiftUIDemo
//
//  Created by 蘇健豪 on 2022/6/10.
//

import ARKit
import ARQuickLookKit

extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let object = virtualObjectLoader.loadedObjects.first {
            autoPlace(object, at: anchor)
        }
    }
    
}
