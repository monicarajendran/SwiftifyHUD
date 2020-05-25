//
//  SwiftifyHUD.swift
//  Pods-SwiftifyHUD_Example
//
//  Created by Monica on 02/05/20.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SIZE_CONSTANT = 375.0

public enum HUDType {
    case loader
    case loaderWith(title: String)
    case text(title: String)
}

public class SwiftifyHUD {
    
    var mainView: UIView
    
    //Views
    private var mainContainer: UIView
    private var subContainer: UIView
    private var activityIndicatorView = UIActivityIndicatorView()
    private var textLabel = UILabel()
    
    open var background: UIColor {
        get {
            return subContainer.backgroundColor ?? .clear
        } set {
            subContainer.backgroundColor = newValue
        }
    }
    
    open var textColor: UIColor {
        get {
            return textLabel.textColor
        } set {
            textLabel.textColor = newValue
        }
    }
    
    open var textFont: UIFont {
        get {
            return textLabel.font
        } set {
            textLabel.font = newValue
        }
    }
    
    public init(view: UIView) {
        self.mainView = view
        self.mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: mainView.frame.height))
        self.subContainer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 3.0, height: SCREEN_WIDTH / 4.0))
        self.configViews()
    }

    func configViews() {
        defaultConfig()
        configureMainContainer()
        configureSubContainer()
        configureTextLabel()
    }
    
    func defaultConfig() {
        textLabel.textColor = .white
        activityIndicator.style = .whiteLarge
    }
    
    func configureMainContainer() {
        mainContainer.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
    }
    
    func configureSubContainer() {
        subContainer.layer.cornerRadius = 5.0
        subContainer.layer.masksToBounds = true
        subContainer.backgroundColor = background
        subContainer.addBlurEffect()
    }
    
    func configureTextLabel() {
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        textLabel.textColor = textColor
        textLabel.font = textFont
    }
    
    var subContainerWidth: CGFloat {
        let width: CGFloat = textLabel.intrinsicContentSize.width + 30
        if width > SCREEN_WIDTH {
            return SCREEN_WIDTH/2 + 150
        } else {
            return width
        }
    }
    
    func drawTextLabel(_ title: String, showLoader: Bool) {
        textLabel.text = title
        
        let height: CGFloat = subContainer.bounds.height - activityIndicatorView.bounds.height - 10.0
        
        
        if showLoader {
            subContainer.frame = CGRect(x: 10, y: 0, width: subContainerWidth, height: SCREEN_WIDTH / 4.0)
            textLabel.frame = CGRect(x: 0, y: 10 + activityIndicatorView.bounds.height, width: subContainer.bounds.width , height: height - 5.0)
        } else {
            subContainer.frame = CGRect(x: 10, y: 0, width: subContainerWidth, height: SCREEN_WIDTH / 4.0 - 30)
            textLabel.frame = CGRect(x: 0, y: 10, width: subContainer.bounds.width, height: subContainer.bounds.height - 20)
        }
        
        subContainer.center = CGPoint(x: SCREEN_WIDTH / 2, y: mainView.frame.height / 2)
        subContainer.addSubview(textLabel)
    }
    
    func addMainContainerInMainView() {
        self.mainView.addSubview(mainContainer)
        mainContainer.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.mainContainer.alpha = 1.0
        })
    }
    
    public func show(_ type: HUDType, hideAfter: TimeInterval = .infinity) {
        self.mainView.isUserInteractionEnabled = false
        
        mainContainer.addSubview(subContainer)
        
        switch type {
            
        case .text(let title):
            self.activityIndicatorView.removeFromSuperview()
            drawTextLabel(title, showLoader: false)
            
        case .loaderWith(let title):
            subContainer.addSubview(activityIndicator)
            drawTextLabel(title, showLoader: true)
            activityIndicator.startAnimating()
            
        default:
            print("handle default")
        }
        addMainContainerInMainView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideAfter) {
            self.hide()
        }
    }
    
    public func hide() {
        self.mainView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mainContainer.alpha = 0.0
        }) { finished in
            self.activityIndicatorView.stopAnimating()
            
            self.activityIndicatorView.removeFromSuperview()
            self.textLabel.removeFromSuperview()
            self.subContainer.removeFromSuperview()
            self.mainContainer.removeFromSuperview()
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = textColor
        activityIndicatorView.style = .whiteLarge
        
        activityIndicatorView.frame = CGRect(x: 0, y: 15, width: subContainer.bounds.width, height: subContainer.bounds.height / 3.0)
        activityIndicatorView.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y)
        return activityIndicatorView
    }
}

extension UIView {
    func addBlurEffect() {
        let blurEffect: UIBlurEffect
        blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(visualEffectView)
    }
}
