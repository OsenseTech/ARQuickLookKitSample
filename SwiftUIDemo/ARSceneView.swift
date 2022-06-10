//
//  ARSceneView.swift
//  SwiftUIDemo
//
//  Created by 蘇健豪 on 2022/6/10.
//

import SwiftUI
import ARKit
import RealityKit

struct ARSceneView: UIViewRepresentable {
    
    let config: ARConfiguration
    let coachingView: ARCoachingOverlayView
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView()
        let session = view.session
        
        session.run(config)
        
        coachingView.session = session
        view.addSubview(coachingView)
        
#if DEBUG
        view.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
#endif
        
        return view
    }
    
    func updateUIView(_ view: ARView, context: Context) {
        
    }
}
