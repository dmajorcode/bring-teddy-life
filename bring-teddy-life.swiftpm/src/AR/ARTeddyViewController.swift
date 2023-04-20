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
//    required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//        }
//
//    init(){
//        super.init()
//        
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
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
    
//    let audioRecorder = AudioRecorder()
    private var teddyAnchor: AnchorEntity!
    private var cameraAnchor: AnchorEntity!
    var placementState = false
    
    // Speech Recognition
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let speechRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechTask = SFSpeechRecognitionTask()
    
    // Audio
    let audioEngine = AVAudioEngine()
    let audioSession = AVAudioSession.sharedInstance()
    
    @Published var recognitionState = false
    @Published var recordingsList = [Recording]()
    
//    init(coder aDecoder: NSCoder, audioRecorder: AudioRecorder, teddyAnchor: AnchorEntity!, cameraAnchor: AnchorEntity!, placementState: Bool = false, speechTask: SFSpeechRecognitionTask = SFSpeechRecognitionTask(), recognitionState: Bool = false) {
//        self.audioRecorder = audioRecorder
//        self.teddyAnchor = teddyAnchor
//        self.cameraAnchor = cameraAnchor
//        self.placementState = placementState
//        self.speechTask = speechTask
//        self.recognitionState = recognitionState
//        super.init(coder: aDecoder)
//    }

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.audioRecorder = AudioRecorder()
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    //    init(audioRecorder: AudioRecorder, teddyAnchor: AnchorEntity!, cameraAnchor: AnchorEntity!, placementState: Bool = false, speechTask: SFSpeechRecognitionTask = SFSpeechRecognitionTask(), recognitionState: Bool = false) {
//        self.audioRecorder = audioRecorder
//        self.teddyAnchor = teddyAnchor
//        self.cameraAnchor = cameraAnchor
//        self.placementState = placementState
//        self.speechTask = speechTask
//        self.recognitionState = recognitionState
//        self.audioRecorder = audioRecorder
//        super.init()
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("this is arVIew:",arView)
        arView.session.delegate = self
        setupARView()
        
        // Tap detector
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
    }
    func setupARView(){
        
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
        // DENOTE THIS : code for development environment
        arView.debugOptions = .showAnchorGeometry
        
        arView.session.run(configuration)
        
    }

    @objc
    func handleTap(recognizer: UITapGestureRecognizer){
        
        if (placementState){return}
        let location = recognizer.location(in: arView)
        
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first {
            let anchor = ARAnchor(name: "TeddyBear", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
            
            // Start Speech Recognition
            startSpeechRecognition()
            
        } else {
            print("Object placement failed - couldn't find surface.")
        }
        
    }
    
    func placeObject(named entityName: String, for anchor: ARAnchor) {
        placementState = true
        
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
    var count = 0
    func speechRecognize(){
        
        guard let speechRecognizer = SFSpeechRecognizer() else{
            print("Speech recognizer not available")
            return
        }
        if (speechRecognizer.isAvailable == false){
            print("Temporarilty not working")
        }
        
        // Task (recognize text)
        
        speechTask = speechRecognizer.recognitionTask(with: speechRequest, resultHandler: {(result, error) in
            guard let result = result else {return}
            
            if (self.recognitionState || self.count > 0){return}
            print(result.bestTranscription.formattedString)
            if (result.bestTranscription.formattedString.contains("Remember me teddy") ||
                result.bestTranscription.formattedString.contains("Remember me Teddy") ||
                result.bestTranscription.formattedString.contains("remember me teddy") ||
                result.bestTranscription.formattedString.contains("remember me Teddy")){
                // Start recording
                self.recognitionState = true
                self.count += 1
                
                let audioRecorder = AudioRecorder()
                audioRecorder.startRecording()
                print(audioRecorder.recording)

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                  // 1초 후 실행될 부분
                    if audioRecorder.recording == true{
                        audioRecorder.stopRecording()
                        print(audioRecorder.recordings)
                        self.recordingsList = audioRecorder.recordings
                        print(self.recordingsList, "this is list")
                    }
                    
                }
                return
                
            }
            // record here
//            print(self.recognitionState)
//            if (self.recognitionState){
//                let audioRecorder = AudioRecorder()
////                self.audioRecorder.startRecording()
//                audioRecorder.startRecording()
//                print(audioRecorder.recording)
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//                  // 1초 후 실행될 부분
//                    if audioRecorder.recording == true{
//                        audioRecorder.stopRecording()
//                    }
//
//                }
//                return
//            }
            
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
