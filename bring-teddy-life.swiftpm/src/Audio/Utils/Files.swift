//
//  File.swift
//  
//
//  Created by Diane on 2023/04/20.
//

import Foundation

func getFileDate(for file:URL) -> Date{
    if let attributes = try?
        FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
       let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

