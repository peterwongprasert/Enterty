//
//  Models.swift
//  Enterty
//
//  Created by PandaSan on 11/6/24.
//

import Foundation

struct Title : Codable , Identifiable{
    let id : Int
    let name : String
    let type : String
}

struct UserCollection: Codable{
    let titleId : Int
    let userEmail: String
    let startDate: Date?
    let endDate: Date?
    let lastAccessDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case titleId = "title_id"
        case userEmail = "user_email"
        case startDate = "start_date"
        case endDate = "end_date"
        case lastAccessDate = "last_access_date"
    }
}

