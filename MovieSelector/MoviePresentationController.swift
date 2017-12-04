//
//  MoviePresentationController.swift
//  MovieSelector
//
//  Created by Vamshi Krishna on 03/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit

class MoviePresentationController: UIPresentationController , UIAdaptivePresentationControllerDelegate{
    var dimmingView = UIView()
    
    override var shouldPresentInFullscreen: Bool{
        return true
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.backgroundColor = UIColor(white:0, alpha:0.8)
        dimmingView.alpha = 0
    }
  
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.alpha = 0
        containerView?.insertSubview(dimmingView, at: 0)
        if let coordinator = presentedViewController.transitionCoordinator{
            coordinator.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 1
            }, completion: nil)
        }else{
            dimmingView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator{
            coordinator.animate(alongsideTransition: { (context) in
                self.dimmingView.alpha = 0
            }, completion: nil)
        }else{
            dimmingView.alpha = 0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        if let containerBounds = containerView?.bounds{
            dimmingView.frame = containerBounds
            presentedView?.frame = containerBounds
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
}
