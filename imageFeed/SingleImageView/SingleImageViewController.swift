//
//  SingleImageViewController.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 28.09.2023.
//

import UIKit
import Kingfisher
final class SingleImageViewController : UIViewController {
    
//    var image: UIImage! {
//        didSet {
//            guard isViewLoaded else { return }
//            imageView.image = image
//            rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    var imageUrl : String = ""
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        downloadImage()
    }
    
    
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [imageView.image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    private func downloadImage(){
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: URL(string: imageUrl)!) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                showError()
            }
        }
    }
    func showError() {
        let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.downloadImage()
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

