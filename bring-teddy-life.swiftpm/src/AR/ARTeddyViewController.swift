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
    let arView = ARView()
    
    var session: ARSession{
        arView.session
    }
}
