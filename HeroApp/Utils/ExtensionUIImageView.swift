//
//  ExtensionUIImageView.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import Foundation
import Kingfisher

extension UIImageView {
    func loadImage(url:String){
        var kf = self.kf
        kf.indicatorType = .activity
        kf.setImage(with: URL(string: url)!,
                    options: [.transition(.fade(0.2))]){ result in
            switch result {
            case .success(_): break
            case .failure(_):
                self.image = UIImage(named: "error_image")
            }
        }
    }
}
