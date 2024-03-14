//
//  SchemaData.swift
//  ReNoteAI
//
//  Created by Siddanathi Rohith on 28/02/24.
//

import Foundation



func schemaData() -> Data? {
    let schema: [String: Any] = [
        "tags": [
          "": [
            "id": "",
            "tagName": ""
          ]
        ],
        "folders": [
          [
            "id": "",
            "name": "",
            "createdDate": "",
            "updatedDate": "",
            "isSynced": false,
            "isPin": false,
            "isFavourite": false,
            "fileCount": 0,
            "driveType": "Google"
          ]
        ],
        "documents": [
          [
            "id": "",
            "name": "",
            "createdDate": "",
            "updatedDate": "",
            "folderId": "",
            "isSynced": false,
            "isPin": false,
            "isFavourite": false,
            "fileCount": 0,
            "driveType": "Google"
          ]
        ],
        "Files": [
          [
            "id": "",
            "name": "",
            "createdDate": "",
            "updatedDate": "",
            "fileData": "",
            "isSynced": false,
            "isPin": false,
            "isFavourite": false,
            "DocumentId": "",
            "openCount": 0,
            "localFilePathIos": "",
            "localFilePathAndroid": "",
            "tagId": "",
            "driveType": "Google",
            "fileExtension": "png"
          ]
        ]
    ]
    
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: schema, options: [])
        return jsonData
    } catch {
        print("Error serializing schema to JSON: \(error)")
        return nil
    }
}
