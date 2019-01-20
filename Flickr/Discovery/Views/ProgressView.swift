//
//  ProgressView.swift
//  MoVieApp
//
//  Created by Imayaselvan Ramakrishnan on 29/11/18.
//  Copyright © 2018 Imayaselvan Ramakrishnan. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    class func show(inView: UIView) -> ProgressView {
        let progressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        progressView.layer.cornerRadius = 6
        progressView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        inView.addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.centerXAnchor.constraint(equalToSystemSpacingAfter: inView.centerXAnchor, multiplier: 1).isActive = true
        progressView.centerYAnchor.constraint(equalToSystemSpacingBelow: inView.centerYAnchor, multiplier: 1).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let loader = UIActivityIndicatorView(style: .whiteLarge)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.startAnimating()
        progressView.addSubview(loader)
        
        loader.centerXAnchor.constraint(equalToSystemSpacingAfter: progressView.centerXAnchor, multiplier: 1).isActive = true
        loader.centerYAnchor.constraint(equalToSystemSpacingBelow: progressView.centerYAnchor, multiplier: 1).isActive = true
        return progressView
    }
}
