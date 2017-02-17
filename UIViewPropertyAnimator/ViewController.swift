//
//  ViewController.swift
//  UIViewPropertyAnimator
//
//  Created by Daniel Wallace on 15/02/17.
//  Copyright © 2017 Daniel Wallace. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var animator: UIViewPropertyAnimator!
    
    var redBox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slider)
        
        view.bottomAnchor.constraint(equalTo: slider.layoutMarginsGuide.bottomAnchor, constant: 44).isActive = true
        slider.widthAnchor.constraint(equalToConstant: (view.bounds.size.width / 2)).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        redBox = UIView(frame: CGRect(x: -64, y: 0, width: 128, height: 128))
        redBox.translatesAutoresizingMaskIntoConstraints = false
        redBox.backgroundColor = UIColor.red
        redBox.center.y = view.center.y
        view.addSubview(redBox)
        
        animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) { [unowned self] in
           self.redBox.center.x = self.view.frame.width
            self.redBox.transform = CGAffineTransform(rotationAngle: CGFloat.pi)//.scaledBy(x: 0.001, y: 0.001)
        }
        
        animator.addCompletion { [unowned self] position in
            if position == .end {
                self.view.backgroundColor = UIColor.green
            } else {
                self.view.backgroundColor = UIColor.black
            }
        }
        
        let play = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playTapped))
        
        let stop = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(endTapped))
        
        let pause = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(pauseTapped))
        
        let reverse = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(reverseTapped))
        
        let restart = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartTapped))
        
        navigationItem.rightBarButtonItems = [stop, play, pause, reverse, restart]
    }
    
    func sliderChanged(_ sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }
    
    func playTapped() {
        // if the animation has started
        if animator.state == .active {
            // if it's current in motion
            if animator.isRunning {
                // pause it
                animator.pauseAnimation()
            } else {
                // continue at the same speed
                animator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            }
        } else {
            // not started yet; start it now
            animator.startAnimation()
        }
    }
    
    func pauseTapped() {
        if animator.state == .active {
            // pause it
            animator.pauseAnimation()
        }
    }
    
    func endTapped() {
        if animator.state == .active {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .end)
        }
    }
    
    func restartTapped() {
        animator.addAnimations { [unowned self] in
            self.redBox.center.x = self.view.frame.width
            self.redBox.transform = CGAffineTransform(rotationAngle: CGFloat.pi)//.scaledBy(x: 0.001, y: 0.001)
        }
    }

    
    func startTapped() {
        if animator.state == .active {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .start)
        }
    }
    
    func reverseTapped() {
        animator.isReversed = true
    }
}
