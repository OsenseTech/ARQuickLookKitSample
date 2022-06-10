//
//  ARViewControllerRepresentable.swift
//  SwiftUIDemo
//
//  Created by 蘇健豪 on 2022/6/10.
//

import Foundation
import SwiftUI

struct ARViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARViewController {
        let controller = ARViewController()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
