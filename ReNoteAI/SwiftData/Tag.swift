//
//  Folder.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 15/02/24.
//

import Foundation
import SwiftData

@Model
class Tag: Identifiable, Codable {
    var id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }

    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}





