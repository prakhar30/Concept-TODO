//
//  ViewController.swift
//  Concept-TODO
//
//  Created by Prakhar Tripathi on 11/02/19.
//  Copyright © 2019 Prakhar Tripathi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var helloLabelTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var color = [CAGradientLayer]()
    var currentCenteredCellIndex = 0
    var sourceRect: CGRect?
    var customViewLayedOut = false
    var todoBoards: NSArray? {
        didSet {
            self.collectionView.reloadData()
            self.color = UIColorHelper.returnUIColouredViews(count: todoBoards!.count)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        todoBoards = RealmHelper.getAllBoards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize()
        if !customViewLayedOut {
            helloLabelTrailing.constant += calculateSectionInset()
            customViewLayedOut = true
        }
    }
    
    @IBAction func addBoardButtonAction(_ sender: Any) {
        showInputDialog(title: "Create a new ToDo Board", subtitle: nil, actionTitle: "OK", cancelTitle: "Cancel", inputPlaceholder: "Board name", inputKeyboardType: .default, cancelHandler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }) { (boardName) in
            RealmHelper.saveNewBoard(boardID: self.todoBoards!.count, boardName: boardName)
            self.todoBoards = RealmHelper.getAllBoards()
        }
    }
    
    func calculateSectionInset() -> CGFloat {
        let deviceIsIpad = UIDevice.current.userInterfaceIdiom == .pad
        let deviceOrientationIsLandscape = UIDevice.current.orientation.isLandscape
        let cellBodyViewIsExpended = deviceIsIpad || deviceOrientationIsLandscape
        let cellBodyWidth: CGFloat = 236 + (cellBodyViewIsExpended ? 174 : 0)
        let inset = (collectionViewFlowLayout.collectionView!.frame.width - cellBodyWidth) / 4
        return inset
    }
    
    func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        collectionViewFlowLayout.itemSize = returnDefaultCellSize(inset: inset)
    }
    
    func returnDefaultCellSize(inset: CGFloat) -> CGSize {
        return CGSize(width: collectionViewFlowLayout.collectionView!.frame.size.width - inset * 2, height: collectionViewFlowLayout.collectionView!.frame.size.height)
    }
    
    func indexOfMajorCell() -> Int {
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = collectionViewFlowLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(color.count - 1, index))
        return safeIndex
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoBoards!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        let todoBoard = todoBoards![indexPath.row] as! ToDoBoard
        cell.boardName.text = todoBoard.boardName
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        let frameforNewView = collectionView.convert(cell.frame, to: self.view)
        self.createView(withFrame: frameforNewView, withColor: UIColor.white, atIndexPath: indexPath)
    }
    
    func createView(withFrame: CGRect, withColor: UIColor, atIndexPath: IndexPath) {
        self.sourceRect = withFrame
        let newview = UIView(frame: withFrame)
        newview.backgroundColor = withColor
        view.addSubview(newview)
        UIView.animate(withDuration: 0.5, animations: {
            newview.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { (animationComplete) in
            if animationComplete {
                self.addGestureRecognizer(toView: newview)
                let boardDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardDetailViewController_ID") as! BoardDetailViewController
                boardDetailsVC.selectedBoardID = atIndexPath.row
                self.addChild(boardDetailsVC)
                newview.addSubview(boardDetailsVC.view)
            }
        })
    }
    
    func addGestureRecognizer(toView: UIView) {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        toView.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == .down {
                self.dismissView(createdView: gesture.view!)
            }
        }
    }
    
    func dismissView(createdView: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            createdView.frame = self.sourceRect!
        }) { (animationComplete) in
            if animationComplete {
                createdView.removeFromSuperview()
            }
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return returnDefaultCellSize(inset: calculateSectionInset())
    }
}

extension MainViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentCenteredCellIndex = indexOfMajorCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let indexOfMajorCell = self.indexOfMajorCell()
        
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = currentCenteredCellIndex + 1 < color.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = currentCenteredCellIndex - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == currentCenteredCellIndex
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = currentCenteredCellIndex + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = collectionViewFlowLayout.itemSize.width * CGFloat(snapToIndex)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
                self.color[snapToIndex].frame = self.view.frame
                self.view.layer.insertSublayer(self.color[snapToIndex], at: 0)
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            collectionViewFlowLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            UIView.animate(withDuration: 0.3) {
                self.color[indexPath.row].frame = self.view.frame
                self.view.layer.insertSublayer(self.color[indexPath.row], at: 0)
            }
        }
    }
}
