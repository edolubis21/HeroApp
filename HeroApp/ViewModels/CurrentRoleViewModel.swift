//
//  CurrentRoleViewModel.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import Foundation
import Combine

class CurrentRoleViewModel: ObservableObject {
    
    static let shared = CurrentRoleViewModel()
    
    @Published var role: RoleModel = allRole

    
    func seletcRole(_ value: RoleModel) {
        role = value
    }
}


