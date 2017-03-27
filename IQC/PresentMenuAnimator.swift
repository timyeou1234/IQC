//
//  PresentMenuAnimator.swift
//  IQC
//
//  Created by YeouTimothy on 2017/3/15.
//  Copyright © 2017年 Wework. All rights reserved.
//

import UIKit

class PresentMenuAnimator: NSObject {

}

extension PresentMenuAnimator: UIViewControllerAnimatedTransitioning{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {
            return
        }
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

        // replace main view with snapshot
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        SnapShot.snapshot.snapshotView = snapshot!
        snapshot?.tag = MenuHelper.snapshotNumber
        snapshot?.isUserInteractionEnabled = false
        snapshot?.layer.shadowOpacity = 0.7
        containerView.insertSubview(snapshot!, aboveSubview: toVC.view)
        fromVC.view.isHidden = true
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                snapshot?.center.x += UIScreen.main.bounds.width * 0.9
                snapshot?.frame =  CGRect(x: (snapshot?.frame.minX)!, y: (snapshot?.bounds.height)! * 0.15, width: (snapshot?.bounds.width)! * 0.7, height: (snapshot?.bounds.height)! * 0.7)
        },
            completion: { _ in
                fromVC.view.isHidden = false
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
        
    }
    
    
    
}

class SnapShot:NSObject{
    
    static let snapshot = SnapShot()
    var snapshotView = UIView()
    
    
}
