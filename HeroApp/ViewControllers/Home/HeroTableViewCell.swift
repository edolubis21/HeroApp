//
//  HeroCellTableViewCell.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import UIKit


class HeroTableViewCell: UICollectionViewCell {
    
    static let identifier = "HeroTableViewCell"
    
    private let heroImage = {
        let heroImage = UIImageView()
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFit
        heroImage.clipsToBounds = true
        return heroImage
    }()
    
    private let heroLabel = {
        let heroLabel = UILabel()
        heroLabel.translatesAutoresizingMaskIntoConstraints = false
        heroLabel.textAlignment = .center
        heroLabel.font = .boldSystemFont(ofSize: 17)
        return heroLabel
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUi() {
        contentView.addSubview(heroImage)
        contentView.addSubview(heroLabel)
        
        NSLayoutConstraint.activate([
            heroLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heroLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImage.bottomAnchor.constraint(equalTo: heroLabel.topAnchor),
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupHeroCell(hero: HeroModel) {
        heroLabel.text = hero.localizedName
        heroImage.loadImage(url: "\(Config.imageUrl)\(hero.img)")
    }

}
