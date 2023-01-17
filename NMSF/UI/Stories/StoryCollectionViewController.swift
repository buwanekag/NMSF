//
//  CollectionViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/21/21.
//

import UIKit

private let reuseIdentifier = "Cell"
private let fourImageCell = "FourCell"
private let threeImageCell = "ThreeCell"
private let twoImageCell = "TwoCell"

class StoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let stories = [Story(name: "Intro", details: "Fascinating Intro", imageName: ["ray"]),Story(name: "Intro", details: "Fascinating Intro", imageName: ["fish","ray"]),Story(name: "Intro", details: "Fascinating Intro", imageName: ["fish","ray","fish"]),Story(name: "Intro", details: "Fascinating Intro", imageName: ["fish","ray","fish","ray"])]
    var isLastSwipe = false
    var isLastTap = false
    var halfViewX: CGFloat =  0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopControls()
        setupCollectionView()
        halfViewX = self.view.frame.width
    }
    
    lazy var pageControl: ProgressView = {
        let pc = ProgressView()
        pc.setCurrentSegment(1)
        pc.numberOfSegments = stories.count
        return pc
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close_lg"), for: .normal)
        button.imageView?.accessibilityLabel = Constants.Common.a11y.close
        button.imageView?.tintColor = .white
        button.bounds.size = CGSize(width: 15, height: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    func setupTopControls() {
        let progressContainerView = UIView()
        progressContainerView.bounds.size.height = 7
        progressContainerView.addSubview(pageControl)
        
        let topControlsStackView = UIStackView(arrangedSubviews: [ pageControl,closeButton])
        topControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        topControlsStackView.distribution = .fill
        topControlsStackView.spacing = 5
        
        view.addSubview(topControlsStackView)
        
        NSLayoutConstraint.activate([
            topControlsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 5),
            topControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            topControlsStackView.heightAnchor.constraint(equalToConstant: ProgressView().containerViewY * 2),
           
            ])
    }
    
    func setupCollectionView() {
        self.collectionView!.register(OneImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(FourImageCollectionViewCell.self, forCellWithReuseIdentifier: fourImageCell)
        self.collectionView!.register(ThreeImageCollectionViewCell.self, forCellWithReuseIdentifier: threeImageCell)
        self.collectionView!.register(TwoImageCollectionViewCell.self, forCellWithReuseIdentifier: twoImageCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView!.isPagingEnabled = true
        
    }
    
    @IBAction func dismissButtonTapped(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    init() {
            super.init(collectionViewLayout: UICollectionViewFlowLayout())
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}

extension StoryCollectionViewController {
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        pageControl.setCurrentSegment(Int(x / view.frame.width + 1))
        
        if isLastSwipe {
            self.dismiss(animated: true, completion: nil)
        }
        isLastSwipe = pageControl.currentSegment == stories.count
       
   
    }
    
    
    @objc func handleRightTap(sender: UIButton) {
        if let currentSegment = pageControl.currentSegment {
            let nextIndex = min(currentSegment, stories.count - 1)
            let indexPath = IndexPath(item: nextIndex, section: 0)
            pageControl.setCurrentSegment(nextIndex + 1)
            if isLastTap {
                self.dismiss(animated: true, completion: nil)
            } else {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            isLastTap =  currentSegment == stories.count - 1
        }
        
    }
    
    @objc func handleLeftTap(sender: UIButton) {
        if let currentSegment = pageControl.currentSegment {
            let nextIndex = max(currentSegment - 1, 0)
            let indexPath = IndexPath(item: nextIndex - 1, section: 0)
            pageControl.setCurrentSegment(nextIndex)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        
    }
}

extension StoryCollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let story = stories[indexPath.item]
        let imageCount = story.imageName.count
        
        switch imageCount {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OneImageCollectionViewCell
            cell.nextButton.tag = indexPath.row
            cell.nextButton.addTarget(self,
                                      action: #selector(self.handleRightTap(sender: )),
                                      for: .touchUpInside)
            cell.configure(story: story)
            cell.backgroundColor = .white
            return cell
        case 2:
            let twoCell = collectionView.dequeueReusableCell(withReuseIdentifier: twoImageCell, for: indexPath) as! TwoImageCollectionViewCell
            twoCell.nextButton.tag = indexPath.row
            twoCell.prevButton.tag = indexPath.row
            twoCell.nextButton.addTarget(self,
                                      action: #selector(self.handleRightTap(sender: )),
                                      for: .touchUpInside)
            twoCell.prevButton.addTarget(self,
                                      action: #selector(self.handleLeftTap(sender: )),
                                      for: .touchUpInside)
            twoCell.configure(story: story)
            return twoCell
        case 3:
            let threeCell = collectionView.dequeueReusableCell(withReuseIdentifier: threeImageCell, for: indexPath) as! ThreeImageCollectionViewCell
            threeCell.nextButton.tag = indexPath.row
            threeCell.prevButton.tag = indexPath.row
            threeCell.nextButton.addTarget(self,
                                      action: #selector(self.handleRightTap(sender: )),
                                      for: .touchUpInside)
            threeCell.prevButton.addTarget(self,
                                      action: #selector(self.handleLeftTap(sender: )),
                                      for: .touchUpInside)
            threeCell.configure(story: story)
            return threeCell
        case 4:
            let fourCell = collectionView.dequeueReusableCell(withReuseIdentifier: fourImageCell, for: indexPath) as! FourImageCollectionViewCell
            fourCell.nextButton.tag = indexPath.row
            fourCell.prevButton.tag = indexPath.row
            fourCell.nextButton.addTarget(self,
                                      action: #selector(self.handleRightTap(sender: )),
                                      for: .touchUpInside)
            fourCell.prevButton.addTarget(self,
                                      action: #selector(self.handleLeftTap(sender: )),
                                      for: .touchUpInside)
            fourCell.configure(story: story)
            return fourCell
        default:
            return UICollectionViewCell()
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentSegment == 1 {
                self.collectionView?.contentOffset = .zero
            } else {
                let indexPath = IndexPath(item: self.pageControl.currentSegment!, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
        }) { (_) in
            
        }
    }
}
