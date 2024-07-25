//
//  HeroesViewModel.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import Foundation
import Combine


class HeroesViewModel: ObservableObject {
    
    static let shared = HeroesViewModel()
    
    @Published var isLoading = true
    @Published var error: String? = nil
    @Published var heroes: [HeroModel] = []
    @Published var filterredHeroes: [HeroModel] = []
    @Published var roles: [RoleModel] = []
    
    private let repository = HeroesRepository.shared
    
    
    func fetchHeroes() {
        Task {
            do {
                self.isLoading = true
                self.error = nil
                
                let locally = try await repository.fetchLocalHeroes()
                if !locally.isEmpty {
                    self.heroes = locally
                    self.filterredHeroes = locally
                    self.roles = self.extractRoles(from: locally)
                    self.isLoading = false
                    return
                }
                
                let heroes = try await repository.fetchHeroes()
                repository.saveLocalHeroes(heroes)
                self.heroes = heroes
                self.filterredHeroes = heroes
                self.roles = self.extractRoles(from: heroes)
                
            } catch {
                self.error = "Failed to load heroes: \(error.localizedDescription)"
            }
            self.isLoading = false
        }
    }

    private func extractRoles(from heroes: [HeroModel]) -> [RoleModel] {
        let allRoles = heroes
            .flatMap { $0.roles }
            .reduce(into: Set<String>()) { result, role in
                result.insert(role)
            }
            .map { RoleModel(id: $0) }
        return Array(allRoles) + [allRole]
    }

    
    func filterHero(_ value: RoleModel) {
        if value.id == allRole.id {
            self.filterredHeroes = self.heroes
        } else {
            self.filterredHeroes = self.heroes.filter { $0.roles.contains(value.id) }
        }
    }
    
    func getSimilarHero(_ value: HeroModel) -> [HeroModel] {
        switch value.primaryAttr {
        case HeroAttributeEnum.strength.rawValue:
            return getHighestBaseAttack()
        case HeroAttributeEnum.agility.rawValue:
            return getHighestSpeed()
        case HeroAttributeEnum.intelligence.rawValue:
            return getHighestBaseMana()
        default:
            return Array(heroes.prefix(3))
        }
    }
    
    func getHighestSpeed() -> [HeroModel] {
        let sortedHeroes = heroes.sorted { ($0.moveSpeed ) > ($1.moveSpeed ) }
        return Array(sortedHeroes.prefix(3))
    }
    
    func getHighestBaseAttack() -> [HeroModel] {
        let sortedHeroes = heroes.sorted { ($0.baseAttackMax ) > ($1.baseAttackMax ) }
        return Array(sortedHeroes.prefix(3))
    }
    
    func getHighestBaseMana() -> [HeroModel] {
        let sortedHeroes = heroes.sorted { ($0.baseHealth ) > ($1.baseHealth ) }
        return Array(sortedHeroes.prefix(3))
    }
}


