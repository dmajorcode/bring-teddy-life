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

@available(iOS 13.0, macOS 10.15, *)
public enum Experience {

    public enum LoadRealityFileError: Error {
        case fileNotFound(String)
    }

    private static var streams = [Combine.AnyCancellable]()

    public static func loadTeddy() throws -> Experience.Teddy {
        guard let realityFileURL = Foundation.Bundle(for: Experience.Teddy.self).url(forResource: "Experience", withExtension: "reality") else {
            throw Experience.LoadRealityFileError.fileNotFound("Experience.reality")
        }

        let realityFileSceneURL = realityFileURL.appendingPathComponent("Teddy", isDirectory: false)
        let anchorEntity = try Experience.Teddy.loadAnchor(contentsOf: realityFileSceneURL)
        return createTeddy(from: anchorEntity)
    }

    public static func loadTeddyAsync(completion: @escaping (Swift.Result<Experience.Teddy, Swift.Error>) -> Void) {
        guard let realityFileURL = Foundation.Bundle(for: Experience.Teddy.self).url(forResource: "Experience", withExtension: "reality") else {
            completion(.failure(Experience.LoadRealityFileError.fileNotFound("Experience.reality")))
            return
        }

        var cancellable: Combine.AnyCancellable?
        let realityFileSceneURL = realityFileURL.appendingPathComponent("Teddy", isDirectory: false)
        let loadRequest = Experience.Teddy.loadAnchorAsync(contentsOf: realityFileSceneURL)
        cancellable = loadRequest.sink(receiveCompletion: { loadCompletion in
            if case let .failure(error) = loadCompletion {
                completion(.failure(error))
            }
            streams.removeAll { $0 === cancellable }
        }, receiveValue: { entity in
            completion(.success(Experience.createTeddy(from: entity)))
        })
        cancellable?.store(in: &streams)
    }

    private static func createTeddy(from anchorEntity: RealityKit.AnchorEntity) -> Experience.Teddy {
        let teddy = Experience.Teddy()
        teddy.anchoring = anchorEntity.anchoring
        teddy.addChild(anchorEntity)
        return teddy
    }

    public class Teddy: RealityKit.Entity, RealityKit.HasAnchoring {

    }

}
