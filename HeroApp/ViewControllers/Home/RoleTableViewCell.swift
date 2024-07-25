//
//  RoleTableViewCell.swift
//  HeroApp
//
//  Created by edo lubis on 25/07/24.
//

import UIKit

class RoleTableViewCell: UITableViewCell {
    
    static let identifier = "RoleTableViewCell"
    
    private let roleButton = {
        let roleButton = UIButton()
        roleButton.translatesAutoresizingMaskIntoConstraints = false
        roleButton.setTitleColor(.white, for: .normal)
        roleButton.backgroundColor = .black
        roleButton.layer.cornerRadius = 8
        return roleButton
    }()

    var buttonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUi() {
        
        contentView.addSubview(roleButton)
        
        NSLayoutConstraint.activate([
            roleButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            roleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            roleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            roleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
        
        roleButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    @objc private func buttonTapped() {
         buttonTapHandler?()
     }
    
    func setupRoleCell(role: RoleModel) {
        roleButton.setTitle(role.id, for: .normal)
    }

}
