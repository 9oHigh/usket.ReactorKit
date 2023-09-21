//
//  TodoCell.swift
//  usket.ReactorKit
//
//  Created by 이경후 on 2023/09/21.
//

import UIKit

final class TodoCell: UITableViewCell {
    
    private let todoLabel = UILabel()
    private let checkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConfig()
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        todoLabel.text = nil
        checkImageView.image = nil
    }
    
    func configure(item: TodoItem) {
        todoLabel.text = "\(item.id)번 \(item.title)"
        if item.isDone {
            checkImageView.image = UIImage(named: "checked")
        } else {
            checkImageView.image = nil
        }
    }
    
    private func setConfig() {
        contentView.backgroundColor = .white
        
        todoLabel.textColor = .black
        todoLabel.font = UIFont.boldSystemFont(ofSize: 20)
        todoLabel.textAlignment = .left
        
        checkImageView.image = nil
        checkImageView.contentMode = .scaleAspectFit
    }
    
    private func setUI() {
        contentView.addSubview(todoLabel)
        contentView.addSubview(checkImageView)
    }
    
    private func setConstraint() {
        todoLabel.translatesAutoresizingMaskIntoConstraints = false
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todoLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            todoLabel.trailingAnchor.constraint(equalTo: self.checkImageView.leadingAnchor, constant: -16),
            todoLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkImageView.heightAnchor.constraint(equalToConstant: 24),
            checkImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            checkImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
        ])
    }
}
