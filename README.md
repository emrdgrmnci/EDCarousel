# EDCarousel

**`EDCarousel`** is a [`Custom collection view Layout`](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout) library for overlapping style carousel collection view flow layout.

## Features
* Animate cell scale while scrolling
* Easy to integrate and use
* Easy Customizeable
* Page control 

## Installation

To install using Cocoapods, clone this repo and go to Example directory then run the following command:

```swift
pod install
```

## Example

https://github.com/emrdgrmnci/EDCarousel/tree/main/Example

![Visual](https://github.com/emrdgrmnci/EDCarousel/blob/main/visual.gif "")

## Usage
#### via Interface Builder

Set the UICollectionView layout class to CarouselFlowLayout as given below.

![Alt text](https://github.com/emrdgrmnci/EDCarousel/blob/main/usage.png "step-1")

#### Detect current indexPath or page while scrolling

* After scrolling end with left or right then you can use the scrollViewWillEndDragging delegate method. This method called when scroll view grinds to a halt.
```
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
```

* Updates the button and page control states.
```
//
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
        } else {
            nextButton.setImage(UIImage("image"), for: .normal)
        }
    }

    private func updateButtonStates(with currentPage: Int) {
        pageControl.currentPage = currentPage
        previousButton.isEnabled = currentPage > 0
        nextButton.isEnabled = currentPage < images.count
    }

```

#### Scroll to specifc index
`scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)` method use to scroll specific index. 

```
collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
```

## Contributing

Feel free to open an issue if you have questions about how to use `EDCarousel`, discovered a bug, or want to improve the implementation or interface.

## Credits

`EDCarousel` is primarily the work of [Emre Degirmenci](https://github.com/emrdgrmnci).
