//
//  File.swift
//  
//
//  Created by Diane on 2023/04/18.
//
import UIKit
import RealityKit
import ARKit


class ARTeddyViewControllerSuper: UIViewController {
    let arView = ARView()
    
    var session: ARSession{
        arView.session
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(arView)
        arView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}

class ARTeddyViewController: ARTeddyViewControllerSuper {
//    @IBOutlet var arView: ARView!
    private var teddyAnchor: AnchorEntity!
    private var cameraAnchor: AnchorEntity!
//    @IBOutlet var arView: ARView!
//
//    var roboAnchor: RoboBear.Scene!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        roboAnchor = try! RoboBear.loadScene()
//        roboAnchor.generateCollisionShapes(recursive: true)
//
//        arView.scene.anchors.append(roboAnchor)
//    }
//    @IBAction func startExperience(_ sender: Any){
//        roboAnchor.notifications.roboStart.post()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("this is arVIew:",arView)
        arView.session.delegate = self
        setupARView()
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    func setupARView(){
        print("in setupARView")
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        print("i am all made")
    }
    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        print("i am in handle tap")
        let location = recognizer.location(in: arView)
        
        
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first {
            let anchor = ARAnchor(name: "TeddyBear", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
        } else {
            print("Object placement failed - couldn't find surface.")
        }
    }
    func placeObject(named entityName: String, for anchor: ARAnchor) {
        print("i am in placing object")
        let entity = try! ModelEntity.loadModel(named: entityName)
        
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: entity)
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity)
        arView.scene.addAnchor(anchorEntity)
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        initAnchors()
//
//        Experience.loadTeddyAsync{[weak self] result in
//            let experience = try! result.get()
//            self?.addExperience(experience)
//        }
//
////        let anchor = AnchorEntity()
////        arView.scene.anchors.append(anchor)
////        Experience.loadTeddyAsync(completion: {[weak self](result) in
////            let experience = try! result.get()
////            let bear = experience.group as! (Entity & HasCollision)
////            anchor.addChild(bear)
////            self?.arView.installGestures(for: bear)
////        })
//
//    }
//    private func addExperience(_ experience: Experience.Teddy){
//
//    }
//    private func initAnchors(){
//        teddyAnchor = AnchorEntity()
//        arView.scene.anchors.append(teddyAnchor)
//
//        cameraAnchor = AnchorEntity(.camera)
//        arView.scene.addAnchor(cameraAnchor)
//    }
    
//    let arView = ARView()
//
//    var session: ARSession{
//        arView.session
//    }
}

extension ARTeddyViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "TeddyBear"{
                placeObject(named: anchorName, for:anchor)
            }
        }
    }
}
