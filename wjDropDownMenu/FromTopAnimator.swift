//
//  FromTopAnimator.swift
//  wjDropDownMenu
//
//  Created by ulinix on 2017-11-20.
//  Copyright © 2017 wjq. All rights reserved.
//

import UIKit

class FromTopAnimator: UIPresentationController {
   
    var view_X: CGFloat?
    var view_Y: CGFloat?
    var isPresent: Bool = false
    var dismmingView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        //自定义样式
        presentedViewController.modalPresentationStyle = UIModalPresentationStyle.custom
    }
    
    
    // 呈现过渡即将开始的时候被调用的
    // 可以在此方法创建和设置自定义动画所需的view
    override func presentationTransitionWillBegin() {
        dismmingView = UIView()
        dismmingView.frame = (containerView?.bounds)!
        dismmingView.backgroundColor = UIColor.black
        dismmingView.isOpaque = false
        dismmingView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        
        //添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dismmingView.addGestureRecognizer(tap)
        
        //添加到容器视图
        containerView?.addSubview(dismmingView)
        
        //转场调度器: 可以在运行转场动画时并行的执行其他动画,转场调度器遵从UIViewControllerTransitionCoordinator协议
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        
        //蒙版动画
        coordinator.animate(alongsideTransition: { (_) in
            self.dismmingView.alpha = 0.5
        }, completion: nil)
        
    }
    @objc fileprivate func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    //present过渡效果结束时调用, bool 判断过渡效果是否完成
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            self.dismmingView = nil
        }
    }
    //MARK : -- 消失过渡即将开始的时候调用
    override func dismissalTransitionWillBegin() {
        guard let coordinator = self.presentingViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { (_) in
            self.dismmingView.alpha = 0.0
        }, completion: nil)
        
    }
    
    //dismiss 消失过渡完成之后调用
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed == true {
            self.dismmingView = nil
        }
    }
    //| --------以下四个方法，都是为了计算目标控制器View的frame的----------------
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container === self.presentedViewController {
            containerView?.setNeedsLayout()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === self.presentedViewController {
            return container.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    //在我们的自定义呈现中,被呈现的view并没有完全填充整个屏幕,被呈现的view的过渡动画之后的最终位置,是由UIPresentationViewController来负责的,我们重写该方法来定义这个最终位置
    override var frameOfPresentedViewInContainerView: CGRect{
        super.frameOfPresentedViewInContainerView
        let containerViewBounds = self.containerView?.bounds
        
        let presentedViewContentsize = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: (containerViewBounds?.size)!)
       
        var presentedViewControllerFrame = containerViewBounds


            //modal出来的控制器Y值
        presentedViewControllerFrame?.origin.y = self.view_Y ?? 0
        presentedViewControllerFrame?.origin.x = self.view_X ?? 
            (containerViewBounds!.size.width - presentedViewContentsize.width) * 0.5
      
        presentedViewControllerFrame?.size.height = presentedViewContentsize.height
        
        presentedViewControllerFrame?.size.width = presentedViewContentsize.width


       

        return presentedViewControllerFrame!
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.dismmingView.frame = (containerView?.frame)!
    }
    
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        assert(self.presentedViewController == presented, "You didn't initialize \(self) with the correct presentedViewController.  Expected \(presented), got \(self.presentedViewController).")
        return self
    }
}

extension FromTopAnimator : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent =  false
        return self
    }
}

extension FromTopAnimator : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return (transitionContext?.isAnimated)! ? 0.5 : 0
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        
        isPresent ? animateTransitionWithPresented(using: transitionContext) : animateTransitionWithDismiss(using: transitionContext)
    }
    
}
extension FromTopAnimator {
    //MARK: -- Present
     func animateTransitionWithPresented(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return  }
        
        transitionContext.containerView.addSubview(toView)
        
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        toView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3, animations: {
            toView.transform = CGAffineTransform.identity
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    
     func animateTransitionWithDismiss(using transitionContext: UIViewControllerContextTransitioning) {
        //从哪个视图控制器弹出的view
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        UIView.animate(withDuration: 0.3, animations: {
            //还原动画
            fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0000001)
        }) { (_) in
            //结束动画
            transitionContext.completeTransition(true)
        }
        
    }
}
