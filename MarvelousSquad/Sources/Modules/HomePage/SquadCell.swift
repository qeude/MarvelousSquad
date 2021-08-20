//
//  SquadCell.swift
//  MarvelousSquad
//
//  Created by Quentin Eude on 17/08/2021.
//

import Backend
import Nuke
import UIKit

class SquadCell: UITableViewCell {
    static let Identifier = String(describing: SquadCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 96, height: 150)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(SquadSuperheroCell.self, forCellWithReuseIdentifier: SquadSuperheroCell.Identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()

    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}

// MARK: Setup UI

extension SquadCell {
    private func setupUI() {
        contentView.addSubview(collectionView)
        backgroundColor = .clear

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            contentView.heightAnchor.constraint(equalToConstant: 170),
        ])
    }
}
