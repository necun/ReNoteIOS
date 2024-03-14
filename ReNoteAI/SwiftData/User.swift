//
//  Document.swfit.swift
//  ReNoteAI
//
//  Created by Sravan Kumar Kandukuru on 14/02/24.
//

import Foundation
import SwiftData

enum UserType: String, CaseIterable {
    case Google = "Google";
    case iCloud = "iCloud";
    case OneDrive = "OneDrive";
    case Local = "Renote"
}


@Model
class User {
    var name: String
    var email: String
    var userType: String
    var accessToken : String
    var accessTokenExpirationDate: Date
    var refreshToken: String
    var refreshTokenExpirationDate : Date?
    var idToken: String
    var idTokenExpirationDate: Date
    var mainFolderID: String
    
    init(name: String, email: String, userType: String, accessToken: String, accessTokenExpirationDate: Date, refreshToken: String, refreshTokenExpirationDate: Date, idToken: String, idTokenExpirationDate: Date, mainFolderID: String) {
        self.name = name
        self.email = email
        self.userType = userType
        self.accessToken = accessToken
        self.accessTokenExpirationDate = accessTokenExpirationDate
        self.refreshToken = refreshToken
        self.refreshTokenExpirationDate = refreshTokenExpirationDate
        self.idToken = idToken
        self.idTokenExpirationDate = idTokenExpirationDate
        self.mainFolderID = mainFolderID
    }
}
