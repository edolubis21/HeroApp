//
//  DetailViewController.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var hero: HeroModel
    var similarHero: [HeroModel]
    
    init(hero: HeroModel, similarHero: [HeroModel]) {
        self.hero = hero
        self.similarHero = similarHero
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let heroDetailStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let heroImage = {
        let heroImage = UIImageView()
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFit
        heroImage.clipsToBounds = true
        return heroImage
    }()
    
    private let heroNameLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let heroRoleLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    func getIconImage(_ value: String) -> UIImageView {
        let iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFit
        iconImage.clipsToBounds = true
        iconImage.image = UIImage(named: value)
        
        return iconImage
    }
    
    func getAtrLabel(_ value: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = value
        return label
    }
    
    func getSimilarImage(_ value: String) -> UIImageView {
        let heroImage = UIImageView()
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFit
        heroImage.clipsToBounds = true
        heroImage.loadImage(url: value)
        return heroImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 251/255.0, alpha: 1)
        
        setupHeroDetail()
        setupHeroAtt()
        setupSimilarHero()
    }
    
    
    func setupHeroDetail() {
        
        let horStack = UIStackView(arrangedSubviews: [getIconImage(hero.attackType), heroNameLabel])
        horStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horStack.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        heroDetailStack.addArrangedSubview(heroImage)
        heroDetailStack.addArrangedSubview(horStack)
        heroDetailStack.addArrangedSubview(heroRoleLabel)
        
        view.addSubview(heroDetailStack)
        
        NSLayoutConstraint.activate([
            heroDetailStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroDetailStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            heroDetailStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            heroDetailStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
        ])
        
        heroImage.loadImage(url: "\(Config.imageUrl)\(hero.img)")
        heroNameLabel.text = hero.localizedName
        heroRoleLabel.text = "Role: \n \(hero.roles.joined(separator: " "))"
        
    }
    
    func setupHeroAtt() {
        
        let hor1Stack = UIStackView(arrangedSubviews: [getIconImage("attack"), getAtrLabel("\(hero.baseAttackMax) - \(hero.baseAttackMin)"), getIconImage("health"), getAtrLabel("\(hero.baseHealth)")])
        hor1Stack.distribution = .fillEqually
        hor1Stack.translatesAutoresizingMaskIntoConstraints = false
        
        let hor2Stack = UIStackView(arrangedSubviews: [getIconImage("armor"), getAtrLabel("\(hero.baseArmor)"), getIconImage("mana"), getAtrLabel("\(hero.baseMana)")])
        hor2Stack.distribution = .fillEqually
        hor2Stack.translatesAutoresizingMaskIntoConstraints = false
        
        let hor3Stack = UIStackView(arrangedSubviews: [getIconImage("speed"), getAtrLabel("\(hero.moveSpeed)"), getIconImage("attr"), getAtrLabel("\(hero.primaryAttr)")])
        hor3Stack.distribution = .fillEqually
        hor3Stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hor1Stack)
        view.addSubview(hor2Stack)
        view.addSubview(hor3Stack)
        
        NSLayoutConstraint.activate([
            hor1Stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hor1Stack.leadingAnchor.constraint(equalTo: heroDetailStack.trailingAnchor, constant: 24),
            hor1Stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            hor1Stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6 / 4),
            
            hor2Stack.topAnchor.constraint(equalTo: hor1Stack.bottomAnchor, constant: 24),
            hor2Stack.leadingAnchor.constraint(equalTo: heroDetailStack.trailingAnchor, constant: 24),
            hor2Stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            hor2Stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6 / 4),
            
            hor3Stack.topAnchor.constraint(equalTo: hor2Stack.bottomAnchor, constant: 24),
            hor3Stack.leadingAnchor.constraint(equalTo: heroDetailStack.trailingAnchor, constant: 24),
            hor3Stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            hor3Stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6 / 4),
        ])
        
    }
    
    func setupSimilarHero() {
        let label = getAtrLabel("Similar Heroes:")
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        let hStack = UIStackView()
        hStack.addArrangedSubview(label)
        
        for hero in similarHero {
            hStack.addArrangedSubview(getSimilarImage("\(Config.imageUrl)\(hero.img)"))
        }
        
        hStack.distribution = .equalCentering
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: heroDetailStack.bottomAnchor, constant: 10),
            hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    
    
}
