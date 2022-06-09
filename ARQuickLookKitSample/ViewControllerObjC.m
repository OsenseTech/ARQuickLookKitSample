//
//  ViewControllerObjC.m
//  ARQuickLookKitSample
//
//  Created by 蘇健豪 on 2022/6/9.
//

#import "ViewControllerObjC.h"
@import ARKit;
@import ARQuickLookKit;
@import ARQuickLookKitObjC;

@interface ViewControllerObjC () <ARViewController, ARSCNViewDelegate>

@property (nonatomic, strong) ARWorldTrackingConfiguration *configuration;
@property (nonatomic, strong) PositionHelper *positionHelper;

@end

@implementation ViewControllerObjC

@synthesize sceneView, virtualObjectLoader, gestureHandler, updateQueue, positionHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sceneView = [[ARSCNView alloc] initWithFrame:CGRectZero];
    sceneView.delegate = self;
    
    virtualObjectLoader = [[VirtualObjectLoader alloc] initWithSceneView:sceneView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Models.scnassets/monkey/model" withExtension:@"scn"];
    VirtualObject *object = [[VirtualObject alloc] initWithURL:url];
    [virtualObjectLoader loadVirtualObjectObjC:object loadedHandler:^(BOOL success) {
        if (success) {
            
        }
    }];
    
    gestureHandler = [[GestureHandler alloc] initWithSceneView:sceneView viewController:self];
    
    dispatch_queue_attr_t qos = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, -1);
    updateQueue = dispatch_queue_create("ARUpdateQueue", qos);
    
    positionHelper = [[PositionHelper alloc] initWithVirtualObjectLoader:virtualObjectLoader gestureHandler:gestureHandler sceneView:sceneView updateQueue:updateQueue];
    
    self.sceneView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:sceneView];
    
    NSMutableArray *constrainArray = [NSMutableArray new];
    [constrainArray addObject:[self.sceneView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor]];
    [constrainArray addObject:[self.sceneView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]];
    [constrainArray addObject:[self.sceneView.topAnchor constraintEqualToAnchor:self.view.topAnchor]];
    [constrainArray addObject:[self.sceneView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]];

    [NSLayoutConstraint activateConstraints:constrainArray];
    
    self.configuration = [ARWorldTrackingConfiguration new];
    self.configuration.planeDetection = ARPlaneDetectionHorizontal;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.sceneView.session runWithConfiguration:self.configuration];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.sceneView.session pause];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if ([anchor isKindOfClass:[ARPlaneAnchor class]]) {
        [positionHelper autoPlace:self.virtualObjectLoader.loadedObjects.firstObject at:anchor];
    }
}

@end
