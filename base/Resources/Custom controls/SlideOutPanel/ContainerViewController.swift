//
//  ContainerViewController.swift
//  base
//
//  Created by Nikola Milic on 7/23/18.
//  Copyright © 2018 Nikola Milic. All rights reserved.
//

import UIKit

enum SlideOutState {
    case expanded
    case closed
}

enum SlideOutSide {
    case left
    case right
}

class ContainerViewController: UIViewController {

    var state: SlideOutState = .closed
    var side: SlideOutSide = .right
    let centerPanelExpandedOffset: CGFloat = 100
    let expandPointRatio: CGFloat = 0.3
    let sufficientVelocityForStateChange: CGFloat = 1000
    
    var sideViewController: UIViewController!
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)
        centerNavigationController.didMove(toParent: self)
                
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
}

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notExpanded = (state != .expanded)
        if notExpanded {
            addSideViewController()
        }
        animateSidePanel(shouldExpand: notExpanded)
    }
    
    func addSideViewController(){
        guard sideViewController == nil else { return }
        
        if let vc = UIStoryboard.sideViewController() {
            sideViewController = vc
            addChild(vc)
            view.insertSubview(vc.view, at: 0)
        }
    }
    
    func animateSidePanel(shouldExpand: Bool){
        if shouldExpand {
            state = .expanded
            var newPosition: CGFloat
            switch side {
                case .left:
                    newPosition = centerNavigationController.view.frame.width - centerPanelExpandedOffset
                case .right:
                    newPosition = -centerNavigationController.view.frame.width + centerPanelExpandedOffset
            }
            animateCenterPanelXPosition(targetPosition: newPosition)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.state = .closed
                self.sideViewController?.view.removeFromSuperview()
                self.sideViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                            self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {
            case .began:
                addSideViewController()
            
            case .changed:
                let horizontalCenter = self.view.center.x
                let movingXCenter = self.centerNavigationController.view.center.x
                let movingXOrigin = self.centerNavigationController.view.frame.origin.x
                let translation = recognizer.translation(in: view)
                
                let startedMovingToLeft = (translation.x < 0)
                let startedMovingToRight = (translation.x > 0)
                var isInLeftmostPosition: Bool
                var isInRightmostPosition: Bool
                
                switch side {
                    case .left:
                        isInLeftmostPosition = (movingXCenter + translation.x) <= horizontalCenter
                        isInRightmostPosition = (movingXOrigin + translation.x) >= (view.bounds.size.width - self.centerPanelExpandedOffset)
                    case .right:
                        isInRightmostPosition = (movingXCenter + translation.x) >= horizontalCenter
                        isInLeftmostPosition = (movingXOrigin + translation.x) <= -(view.bounds.size.width - self.centerPanelExpandedOffset)
                }
                
                if let movingView = self.centerNavigationController.view {
                    if (isInLeftmostPosition && startedMovingToLeft) || (isInRightmostPosition && startedMovingToRight) {
                        break
                    } else {
                        movingView.center.x = movingView.center.x + translation.x
                        recognizer.setTranslation(CGPoint.zero, in: view)
                    }
                }
            
            case .ended:
                if let _ = sideViewController, let movingView = self.centerNavigationController.view {
                    let hasMovedBeyondExpandingPoint: Bool
                    let hasSufficientVelocityForStateChange: Bool
                    let isDirectedInProperDirection: Bool
                    
                    switch side {
                        case .left:
                            hasMovedBeyondExpandingPoint = movingView.center.x > ((self.expandPointRatio + 1/2) * view.bounds.size.width)
                            hasSufficientVelocityForStateChange = abs(recognizer.velocity(in: view).x) > self.sufficientVelocityForStateChange
                            isDirectedInProperDirection = (self.state == .closed) ? recognizer.velocity(in: view).x > 0 : recognizer.velocity(in: view).x < 0
                        case .right:
                            hasMovedBeyondExpandingPoint = movingView.center.x < (self.expandPointRatio  * view.bounds.size.width)
                            hasSufficientVelocityForStateChange = abs(recognizer.velocity(in: view).x) > self.sufficientVelocityForStateChange
                            isDirectedInProperDirection = (self.state == .closed) ? recognizer.velocity(in: view).x < 0 : recognizer.velocity(in: view).x > 0
                    }
                    
                    switch state {
                        case .closed:
                            animateSidePanel(shouldExpand: (hasMovedBeyondExpandingPoint || hasSufficientVelocityForStateChange) && isDirectedInProperDirection)
                        case .expanded:
                            animateSidePanel(shouldExpand: (hasMovedBeyondExpandingPoint && !hasSufficientVelocityForStateChange) || !isDirectedInProperDirection)
                    }
                }
            
            default:
                break
        }
    }
    
}


