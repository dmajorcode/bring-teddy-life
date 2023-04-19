//
//  File.swift
//  
//
//  Created by Diane on 2023/04/18.
//
import UIKit
import RealityKit
import ARKit
import Speech

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
    
    private var teddyAnchor: AnchorEntity!
    private var cameraAnchor: AnchorEntity!
    
    // Speech Recognition
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let speechRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechTask = SFSpeechRecognitionTask()
    
    // Audio
    let audioEngine = AVAudioEngine()
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("this is arVIew:",arView)
        arView.session.delegate = self
        setupARView()
        
        // Tap detector
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
        // Start Speech Recognition
        startSpeechRecognition()
    }
    func setupARView(){
        print("in setupARView")
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        // DENOTE THIS : code for development environment
        arView.debugOptions = .showAnchorGeometry
        
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
    func startSpeechRecognition(){
        
        // 1. Permission
        requestPermission()
        // 2. Audio Record
        startAudioRecording()
        // 3. Speech Recognition
        speechRecognize()
    }
    func requestPermission(){
        SFSpeechRecognizer.requestAuthorization{ (authorizationStatus) in
            if (authorizationStatus == .authorized){
                print("Authorized")
            } else if (authorizationStatus == .denied){
                print("Denied")
            } else if (authorizationStatus == .notDetermined){
                print("Waiting")
            } else if (authorizationStatus == .restricted){
                print("Speech Recognition not available")
            }
        }
    }
    func startAudioRecording(){
        // Input node
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){(buffer, _) in
            
            // Pass the audio samples to Speech Recognition
            self.speechRequest.append(buffer)
        }
        
        // Audio Engine start
        do{
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            audioEngine.prepare()
            try audioEngine.start()
        }
        catch{
            
        }
        
    }
    func speechRecognize(){
        guard let speechRecognizer = SFSpeechRecognizer() else{
            print("Speech recognizer not available")
            return
        }
        if (speechRecognizer.isAvailable == false){
            print("Temporarilty not working")
        }
        
        // Task (recognize text)
        var count = 0
        
        speechTask = speechRecognizer.recognitionTask(with: speechRequest, resultHandler: {(result, error) in
            count += 1
            
            if (count == 1){
                guard let result = result else {return}
                let recognizedText = result.bestTranscription.segments.last
                
                // start recording
                print("recording should start from here")
                if (recognizedText?.substring == "Teddy"){
                    print("Word Teddy recognized")
                }
                
            } else if (count >= 3){
                count = 0
            }
            
        })
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
