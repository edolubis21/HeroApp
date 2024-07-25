//
//  HomeViewController.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let heroesViewModel = HeroesViewModel.shared
    private let roleViewModel = CurrentRoleViewModel.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    lazy var roleTable = {
        let roleTable = UITableView()
        roleTable.register(RoleTableViewCell.self, forCellReuseIdentifier: RoleTableViewCell.identifier)
        roleTable.translatesAutoresizingMaskIntoConstraints = false
        roleTable.separatorStyle = .none
        roleTable.showsVerticalScrollIndicator = false
        roleTable.showsHorizontalScrollIndicator = false
        return roleTable
    }()
    
    lazy var heroCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let heroCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        heroCollection.register(HeroTableViewCell.self, forCellWithReuseIdentifier: HeroTableViewCell.identifier)
        heroCollection.translatesAutoresizingMaskIntoConstraints = false
        heroCollection.showsVerticalScrollIndicator = false
        heroCollection.showsHorizontalScrollIndicator = false
        return heroCollection
    }()
    
    lazy var errorLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.textColor = .red
           label.numberOfLines = 0
           label.textAlignment = .center
           label.isHidden = true
           return label
       }()
       
       lazy var retryButton: UIButton = {
           let button = UIButton(type: .system)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.setTitle("Coba Lagi", for: .normal)
           button.addTarget(self, action: #selector(retryFetch), for: .touchUpInside)
           button.isHidden = true
           return button
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = roleViewModel.role.id
        
        setupRoleTable()
        setupHeroCollection()
        bindViewModel()
        setupLoadingView()
        setupErrorLabelAndButton()
        heroesViewModel.fetchHeroes()
    }
    
    private func bindViewModel() {
        heroesViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.loadingView.startAnimating()
                } else {
                    self.loadingView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        heroesViewModel.$error
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] error in
                        if let error = error {
                            self?.errorLabel.text = error
                            self?.errorLabel.isHidden = false
                            self?.retryButton.isHidden = false
                        } else {
                            self?.errorLabel.isHidden = true
                            self?.retryButton.isHidden = true
                        }
                    }
                    .store(in: &cancellables)
        
        heroesViewModel.$filterredHeroes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.heroCollection.reloadData()
            }
            .store(in: &cancellables)
        
        heroesViewModel.$roles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.roleTable.reloadData()
            }
            .store(in: &cancellables)
        
        roleViewModel.$role
            .receive(on: DispatchQueue.main)
            .sink { [weak self] role in
                self?.title = role.id
            }
            .store(in: &cancellables)
    }
    
    @objc private func retryFetch() {
         heroesViewModel.fetchHeroes()
     }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupErrorLabelAndButton() {
          view.addSubview(errorLabel)
          view.addSubview(retryButton)
          
          NSLayoutConstraint.activate([
              errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
              errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
              errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
              
              retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
              retryButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10)
          ])
      }
    
    func setupHeroCollection() {
        view.addSubview(heroCollection)
        
        NSLayoutConstraint.activate([
            heroCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            heroCollection.leadingAnchor.constraint(equalTo: roleTable.trailingAnchor, constant: 20),
            heroCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        heroCollection.delegate = self
        heroCollection.dataSource = self
        
    }
    
    func setupRoleTable() {
        view.addSubview(roleTable)
        
        NSLayoutConstraint.activate([
            roleTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            roleTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            roleTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            roleTable.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        roleTable.delegate = self
        roleTable.dataSource = self
    }
    
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hero = self.heroesViewModel.filterredHeroes[indexPath.row]
        let detailViewController = DetailViewController(hero: hero, similarHero: self.heroesViewModel.getSimilarHero(hero))
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.heroesViewModel.roles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoleTableViewCell.identifier, for: indexPath) as! RoleTableViewCell
        cell.setupRoleCell(role: self.heroesViewModel.roles[indexPath.row])
        cell.buttonTapHandler = {
            self.roleViewModel.seletcRole(self.heroesViewModel.roles[indexPath.row])
            self.heroesViewModel.filterHero(self.heroesViewModel.roles[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.heroesViewModel.filterredHeroes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroTableViewCell.identifier, for: indexPath) as! HeroTableViewCell
        cell.setupHeroCell(hero: self.heroesViewModel.filterredHeroes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 60) / 3
        return CGSize(width: width, height: width)
    }
    
}
