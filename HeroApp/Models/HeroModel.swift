//
//  HeroModel.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import Foundation

struct HeroModel: Codable {
    let id: Int
    let name: String
    let primaryAttr: String
    let attackType: String
    let roles: [String]
    let img: String
    let baseHealth: Int
    let baseAttackMax: Int
    let moveSpeed: Int
    let localizedName: String
    let baseAttackMin: Int
    let baseArmor: Int
    let baseMana: Int
}
