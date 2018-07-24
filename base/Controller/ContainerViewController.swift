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

class ContainerViewController: UIViewController {

    var state: SlideOutState = .closed
    let centerPanelExpandedOffset: CGFloat = 60
    let expandPointRatio: CGFloat = 0.35
    let sufficientVelocityForStateChange: CGFloat = 1000
    
    var leftViewController: SideViewController!
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)
                
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(gesture)
    }

}

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notExpanded = (state != .expanded)
        if notExpanded {
            addLeftViewController()
        }
        animateLeftPanel(shouldExpand: notExpanded)
    }
    
    func addLeftViewController(){
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftViewController() {
            leftViewController = vc
            addChildViewController(vc)
            view.insertSubview(vc.view, at: 0)
        }
    }
    
    func animateLeftPanel(shouldExpand: Bool){
        if shouldExpand {
            state = .expanded
            let newPosition = centerNavigationController.view.frame.width - centerPanelExpandedOffset
            animateCenterPanelXPosition(targetPosition: newPosition)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.state = .closed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {

        switch recognizer.state {
            case .began:
                addLeftViewController()
            
            case .changed:
                let horizontalCenter = self.view.center.x
                let movingXPosition = self.centerNavigationController.view.center.x
                let translation = recognizer.translation(in: view)
                
                let startedMovingToLeft = (translation.x < 0)
                let isNotFurtherLeftThanScreenCenter = ((movingXPosition + translation.x) <= horizontalCenter)
                let startedMovingToRight = (translation.x > 0)
                let isNotFurtherRightThanOffset = (movingXPosition + translation.x) >= (view.bounds.size.width - self.centerPanelExpandedOffset)
                
                
                if let movingView = self.centerNavigationController.view {
                    if (isNotFurtherLeftThanScreenCenter && startedMovingToLeft) || (isNotFurtherRightThanOffset && startedMovingToRight) {
                        break
                    } else {
                        movingView.center.x = movingView.center.x + translation.x
                        recognizer.setTranslation(CGPoint.zero, in: view)
                    }
                }
            
            case .ended:
                if let _ = leftViewController, let movingView = self.centerNavigationController.view {
                    let hasMovedBeyondExpandingPoint = movingView.center.x > ((self.expandPointRatio + 1/2) * view.bounds.size.width)
                    let hasSufficientVelocityForStateChange = abs(recognizer.velocity(in: view).x) > self.sufficientVelocityForStateChange
                    let isDirectedInProperDirection = (self.state == .closed) ? recognizer.velocity(in: view).x > 0 : recognizer.velocity(in: view).x < 0
                    
                    switch self.state {
                        case .closed:
                            animateLeftPanel(shouldExpand: (hasMovedBeyondExpandingPoint || hasSufficientVelocityForStateChange) && isDirectedInProperDirection)
                        case .expanded:
                            animateLeftPanel(shouldExpand: (hasMovedBeyondExpandingPoint && !hasSufficientVelocityForStateChange) || !isDirectedInProperDirection)
                    }
                }
            
            default:
                break
        }
    }
    
}



private extension UIStoryboard {
    
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static func leftViewController() -> SideViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SideViewController
    }
    
    static func centerViewController() -> CenterViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "CenterViewController") as? CenterViewController
    }
}
