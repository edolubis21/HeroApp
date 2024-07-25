//
//  HeroRepository.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import Foundation
import UIKit

class HeroesRepository {
    
    static let shared = HeroesRepository()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchHeroes() async throws -> [HeroModel]  {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "\(Config.url)/herostats")!)
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode([HeroModel].self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchLocalHeroes() async throws -> [HeroModel]  {
        do{
            let data = try context.fetch(HeroEntity.fetchRequest())
            return data.map { mapHeroEntityToHeroModel(entity: $0) }
            
        }catch{
            throw error
        }
    }
    
    func saveLocalHeroes(_ heroes: [HeroModel]) {
        do{
            let data = try context.fetch(HeroEntity.fetchRequest())
            
            data.forEach { context.delete($0) }
            
            try  heroes.forEach { value in
                let heroEntity = HeroEntity(context: context)
                heroEntity.id = Int64(value.id)
                heroEntity.name = value.name
                heroEntity.primaryAttr = value.primaryAttr
                heroEntity.attackType = value.attackType
                heroEntity.roles = value.roles
                heroEntity.img = value.img
                heroEntity.baseHealth = Int64(value.baseHealth )
                heroEntity.baseAttackMax = Int64(value.baseAttackMax )
                heroEntity.moveSpeed = Int64(value.moveSpeed )
                heroEntity.localizedName = value.localizedName
                try context.save()
                
                let data = try context.fetch(HeroEntity.fetchRequest())
            }
            
        } catch{}
    }
}


func mapHeroEntityToHeroModel(entity: HeroEntity) -> HeroModel {
    return HeroModel(
        id: Int(entity.id),
        name: entity.name ?? "",
        primaryAttr: entity.primaryAttr ?? "",
        attackType: entity.attackType ?? "",
        roles: entity.roles ?? [],
        img: entity.img ?? "",
        baseHealth: Int(entity.baseHealth),
        baseAttackMax: Int(entity.baseAttackMax),
        moveSpeed: Int(entity.moveSpeed),
        localizedName: entity.localizedName ?? "",
        baseAttackMin: Int(entity.baseAttackMin),
        baseArmor: Int(entity.baseArmor),
        baseMana: Int(entity.baseMana)
    )
}
