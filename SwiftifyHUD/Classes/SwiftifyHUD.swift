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
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public enum HUDType {
    case loader
    case loaderWith(title: String)
    case text(title: String)
}

public class SwiftifyHUD {
    
    //Views
    private var mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    private var subContainer = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 3.0, height: SCREEN_WIDTH / 4.0))
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
    
    public init() {
        configureMainContainer()
        configureSubContainer()
        configureTextLabel()
    }
    
    func configureMainContainer() {
        mainContainer.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
    }
    
    func configureSubContainer() {
        subContainer.layer.cornerRadius = 5.0
        subContainer.layer.masksToBounds = true
        subContainer.backgroundColor = background //
        subContainer.addBlurEffect()
    }
    
    func configureTextLabel() {
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        if #available(iOS 13.0, *) {
            textLabel.textColor = UIColor.label
        } else {
            textLabel.textColor = textColor //
        }
        textLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    var subContainerWidth: CGFloat {
        var width: CGFloat = textLabel.intrinsicContentSize.width
        if width > SCREEN_WIDTH {
            width = SCREEN_WIDTH/2 + 150
        } else {
            width += 30
        }
        return width
    }
    
    func drawTextLabel(_ title: String, showLoader: Bool) {
        textLabel.text = title
        
        let height: CGFloat = subContainer.bounds.height - activityIndicatorView.bounds.height - 10.0
        
        
        if showLoader {
            subContainer.frame = CGRect(x: 10, y: 0, width: subContainerWidth, height: SCREEN_WIDTH / 4.0)
            textLabel.frame = CGRect(x: 0, y: 10 + activityIndicatorView.bounds.height, width: subContainer.bounds.width , height: height - 5.0)
        } else {
            subContainer.frame = CGRect(x: 10, y: 0, width: subContainerWidth, height: SCREEN_WIDTH / 4.0 - 10)
            textLabel.frame = CGRect(x: 0, y: 10, width: subContainer.bounds.width, height: subContainer.bounds.height - 20)
        }
        
        subContainer.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        subContainer.addSubview(textLabel)
    }
    
    func addMainContainerInWindow() {
        if let window = getKeyWindow() {
            window.addSubview(mainContainer)
        }
        mainContainer.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: {
            self.mainContainer.alpha = 1.0
        })
    }
    
    public func show(_ type: HUDType, hideAfter: TimeInterval = 0.0) {
        
        mainContainer.addSubview(subContainer)
        
        switch type {
            
        case .text(let title):
            drawTextLabel(title, showLoader: false)
            
        case .loaderWith(let title):
            subContainer.addSubview(activityIndicator)
            drawTextLabel(title, showLoader: true)
            activityIndicator.startAnimating()
            
        default:
            print("handle default")
        }
        addMainContainerInWindow()
    }
    
    public func hide() {
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
        if #available(iOS 13.0, *) {
            activityIndicatorView.color = UIColor.label
            activityIndicatorView.style = .medium
        } else {
            activityIndicatorView.color = textColor
            activityIndicatorView.style = .gray
        }
        
        activityIndicatorView.frame = CGRect(x: 0, y: 10, width: subContainer.bounds.width, height: subContainer.bounds.height / 3.0)
        activityIndicatorView.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y)
        return activityIndicatorView
    }
}

private func getKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        return window
    } else {
        let app = UIApplication.shared.delegate
        return app?.window ?? nil
    }
}

extension UIView {
    func addBlurEffect() {
        let blurEffect: UIBlurEffect
        
        if #available(iOS 13.0, *) {
            blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(visualEffectView)
    }
}
