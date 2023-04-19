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
        NSLayoutConstraint.activate(arView.pin(to: view))
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = session
        coachingOverlay.goal = .horizontalPlane
        arView.addSubview(coachingOverlay)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(coachingOverlay.pin(to: arView))
        
    }
    
}

class ARTeddyViewController: ARTeddyViewControllerSuper {
//    private var cameraAnchor: AnchorEntity!
//    private var floorAnchor: AnchorEntity!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Add anchor for floor
//        floorAnchor = AnchorEntity(plane: .horizontal)
//        arView.scene.anchors.append(floorAnchor)
//        let anchor = floorAnchor!
//
//        // Add anchor for camera
//        cameraAnchor = AnchorEntity(.camera)
//        arView.scene.addAnchor(cameraAnchor)
//
//        addCubeExperiment(anchor: anchor)
//    }
//
//    func addCubeExperiment(anchor: AnchorEntity) {
//        let container = Entity()
//        let entity = createBox()
//        container.addChild(entity)
//        anchor.addChild(container)
//    }
//
//    func createBox() -> ModelEntity {
//        let box = MeshResource.generateBox(size: 0.2)
//        let material = SimpleMaterial(color: .green, isMetallic: true)
//        let entity = ModelEntity(mesh: box, materials: [material])
//        entity.generateCollisionShapes(recursive: true)
//        return entity
//    }
    private var teddyAnchor: AnchorEntity!
    private var cameraAnchor: AnchorEntity!

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
