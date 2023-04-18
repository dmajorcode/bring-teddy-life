//
//  File.swift
//  
//
//  Created by Diane on 2023/04/19.
//

import Foundation
import RealityKit
import simd
import Combine

@available(macOS 13.3.1, *)
public enum Experience {
    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }
    
    private static var streams = [Combine.AnyCancellable]()
    
    public static func loadTeddy() throws -> Experience.Teddy{
        guard let realityFileURL = Foundation.Bundle(for: Experience.Teddy.self).url(forResource:"Experience", withExtension: "reality") else{
            throw
            Experience.LoadRealityFileError.fileNotFound("Experience.reality")
        }
        
        let realityFileSceneURL = realityFileURL.appendingPathComponent("Teddy", isDirectory: false)
        let anchorEntity = try Experience.Teddy.loadAnchor(contentsOf: realityFileSceneURL)
        return createTeddy(from: anchorEntity)
    }
    private static func createTeddy(from anchorEntity: RealityKit.AnchorEntity) -> Experience.Teddy{
        let teddy = Experience.Teddy()
        teddy.anchoring = anchorEntity.anchoring
        teddy.addChild(anchorEntity)
        return teddy
    }
    
    public class Teddy: RealityKit.Entity, RealityKit.HasAnchoring {
        public var group: RealityKit.Entity?{
            return self.findEntity(named: "group")
        }
    }
}


