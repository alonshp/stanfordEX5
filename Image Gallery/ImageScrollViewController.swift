//
//  ImageViewController.swift
//  Image Gallery
//
//  Created by Alon Shprung on 4/8/18.
//  Copyright © 2018 Alon Shprung. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView?.contentSize = imageView.frame.size
    }

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    private var imageView  = UIImageView()
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
