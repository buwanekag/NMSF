//
//  StoryListCollectionViewController.swift
//  NMSF
//
//  Created by Clay Suttner on 10/3/21.
//

import UIKit

protocol StorySelectionDelegate: AnyObject {
    func selectedStory(index: Int)
}

class StoryListCollectionViewController: UICollectionViewController {
    
    var viewModel: PointsOfInterestViewModel?
    
    weak var delegate: StorySelectionDelegate?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: StoryListCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: StoryListCollectionViewCell.className)
    }
}

extension StoryListCollectionViewController {
    // MARK: - Collection DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryListCollectionViewCell.className, for: indexPath) as! StoryListCollectionViewCell
        cell.configureUI()
        return cell
    }
}

extension StoryListCollectionViewController {
    // MARK: - Collection Delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.selectedStory(index: indexPath.row)
    }
}

extension StoryListCollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - Collection Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 144, height: 184)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 24, height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 24, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}
