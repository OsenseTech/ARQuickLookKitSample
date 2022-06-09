//
//  ViewController+UIGestureRecognizerDelegate.swift
//  ARQuickLookKitSample
//
//  Created by 蘇健豪 on 2022/5/24.
//

import UIKit

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
}
