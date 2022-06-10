//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by 蘇健豪 on 2022/6/10.
//

import SwiftUI
import ARKit

struct ContentView: View {
    
    private let configuration: ARConfiguration = {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        
        return config
    }()
    
    private let coachingView: ARCoachingOverlayView = {
        let coachingView = ARCoachingOverlayView()
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingView.goal = .horizontalPlane
        
        return coachingView
    }()
    
    var body: some View {
        ARSceneView(config: configuration, coachingView: coachingView)
            .ignoresSafeArea()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
