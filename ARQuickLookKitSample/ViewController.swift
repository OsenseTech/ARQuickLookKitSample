//
//  ViewController.swift
//  ARQuickLookKitSample
//
//  Created by 蘇健豪 on 2022/5/24.
//

import UIKit
import ARKit
import SnapKit
import ARCapture
import ARQuickLookKit
import CameraButton

class ViewController: UIViewController, ARViewController {
    
    var sceneView = ARSCNView(frame: .zero)
    
    private let cameraButton = CameraButton()
    
    lazy var gestureHandler = GestureHandler(sceneView: sceneView, viewController: self, gestures: [.pinch, .pan])
    
    lazy var virtualObjectLoader = VirtualObjectLoader(sceneView: sceneView)
    
    private var capture: ARCapture?
    
    private let arConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        
        if ARConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics = .personSegmentationWithDepth
        }
        
        return configuration
    }()
    
    private let coachingView = ARCoachingOverlayView()
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    var updateQueue = DispatchQueue(label: "com.osensetech.ARObjectInteraction.serialSceneKitQueue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupARView()
        setupCoachingOverlay()
        addCameraButton()
        loadModel()
        
        capture = ARCapture(view: sceneView)
        
        func loadModel() {
            let modelNames = ["lamp", "monkey"]
            for modelName in modelNames {
                loadModel(model: modelName)
            }
            
            func loadModel(model: String) {
                guard let modelURL = Bundle.main.url(forResource: "Models.scnassets/\(model)/model", withExtension: "scn") else { return }
                guard let object = VirtualObject(url: modelURL) else { return }
                
                virtualObjectLoader.loadVirtualObject(object, key: model)
            }
        }
        
        func setupARView() {
            sceneView.delegate = self
            
            self.view.addSubview(sceneView)
            sceneView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            #if DEBUG
            sceneView.debugOptions = .showFeaturePoints
            #endif
        }
        
        func setupCoachingOverlay() {
            coachingView.session = sceneView.session
            coachingView.activatesAutomatically = true
            coachingView.goal = .horizontalPlane
            
            sceneView.addSubview(coachingView)
            coachingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        func addCameraButton() {
            cameraButton.delegate = self
            
            self.sceneView.addSubview(cameraButton)
            cameraButton.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-30)
                make.centerX.equalToSuperview()
                make.size.equalTo(CGSize(width: 66, height: 66))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(arConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // MARK: - Photo
    
    func takePhoto() {
        let image = sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
}

extension ViewController: CameraButtonDelegate {
    
    func didTap(_ button: CameraButton) {
        takePhoto()
    }
    
    func didStartProgress() {
        capture?.start()
    }
    
    func didEndProgress() {
        capture?.stop { success in
            print(success)
        }
    }
    
}
