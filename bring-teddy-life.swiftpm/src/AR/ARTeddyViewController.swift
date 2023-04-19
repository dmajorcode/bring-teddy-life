//
//  File.swift
//  
//
//  Created by Diane on 2023/04/18.
//
import UIKit
import RealityKit
import ARKit

class ARTeddyViewController: UIViewController {
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let anchor = AnchorEntity()
        arView.scene.anchors.append(anchor)
        Experience.loadTeddyAsync(completion: {[weak self](result) in
            let experience = try! result.get()
            let bear = experience.group as! (Entity & HasCollision)
            anchor.addChild(bear)
            self?.arView.installGestures(for: bear)
        })
        
    }
    
    let arView = ARView()

    var session: ARSession{
        arView.session
    }
}
