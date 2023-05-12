//
//  ViewController.swift
//  Example
//
//  Created by Degirmenci Emre on 11.05.2023.
//

import UIKit
import EDCarousel
import Combine

final class ViewController: UIViewController {

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var previousButton: UIButton!
    @IBOutlet private var pageControl: CustomPageControl!
    @IBOutlet private var closeButton: UIButton!

    private var collectionDataSource: ExampleCollectionDataSource!
    private let padding = 10.0
    private var images = [Onboarding]()
    private var cancelBag = Set<AnyCancellable>()

    var viewModel = ExampleViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setupCollectionView()
        setupPreviousButton()
        setupNextButton()
        setObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPageControl()
    }

    // MARK: - Private

    private func setObservers() {
        cancelBag.removeAll()
        viewModel.images
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak collectionDataSource] in
                collectionDataSource?.updateData(items: $0)
                self.images = $0
            }
            .store(in: &cancelBag)
    }

    private func setStyle() {
        view.backgroundColor = UIColor(named: "darkGray")
        collectionView.backgroundColor = UIColor(named: "darkGray")
    }

    private func setupCollectionView() {
        collectionDataSource = ExampleCollectionDataSource(
            collectionView: collectionView
        )
        collectionView.delegate = collectionDataSource
        collectionView.dataSource = collectionDataSource
        collectionDataSource?
            .scrollViewWillEndDragging = { [weak self] scrollView, velocity, targetContentOffset in
                self?.scrollViewWillEndDragging(
                    scrollView,
                    withVelocity: velocity,
                    targetContentOffset: targetContentOffset
                )
            }
    }

    private func setupPageControl() {
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.clipsToBounds = false
    }

    private func setupPreviousButton() {
        previousButton.isHidden = true
        previousButton.setTitle("Previous", for: .normal)
        previousButton.setImage(UIImage(named: "arrow_left_white"), for: .normal)
    }

    private func setupNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.setImage(UIImage(named: "arrow_right_white"), for: .normal)
        nextButton.semanticContentAttribute = .forceRightToLeft
    }

    func scrollViewWillEndDragging(
        _: UIScrollView,
        withVelocity _: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let targetOffset = targetContentOffset.pointee.x
        let width = (collectionView.frame.size.width - padding) / 1.21
        let rounded = Double((images.count / 2)) * abs(targetOffset / width)
        let scale = round(rounded)
        pageControl.currentPage = Int(scale)
        updateButtonStates(with: pageControl.currentPage)
        updateUI(with: pageControl.currentPage)
    }

    @IBAction
    func didTapOnPreviousButton(_: Any) {
        let prevIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        pageControl.currentPage = prevIndex
        collectionView?.isPagingEnabled = false
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        updateButtonStates(with: pageControl.currentPage)
        updateUI(with: pageControl.currentPage)
    }

    @IBAction
    func didTapOnNextButton(_: Any) {
        let nextIndex = min(pageControl.currentPage + 1, images.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.isPagingEnabled = false
        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        updateButtonStates(with: pageControl.currentPage)
        updateUI(with: pageControl.currentPage)
    }

    private func updateUI(with currentPage: Int) {
        pageControl.currentPage = currentPage
        pageControl.indicatorImage(forPage: pageControl.currentPage)
        previousButton.isHidden = currentPage == 0
        nextButton.isHidden = currentPage == images.count - 1
        if currentPage == images.count - 1 {
            nextButton.isHidden = false
            nextButton.setImage(UIImage(), for: .normal)
            nextButton.setTitle("OK", for: .normal)
        } else {
            nextButton.setImage(UIImage(named: "arrow_right_white"), for: .normal)
            nextButton.setTitle("Next", for: .normal)
        }
    }

    private func updateButtonStates(with currentPage: Int) {
        pageControl.currentPage = currentPage
        previousButton.isEnabled = currentPage > 0
        nextButton.isEnabled = currentPage < images.count
    }
}
