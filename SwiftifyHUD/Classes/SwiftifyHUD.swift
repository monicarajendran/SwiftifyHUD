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
    
    open var textFont: UIFont {
        get {
            return textLabel.font
        } set {
            textLabel.font = newValue
        }
    }
    
    public init() {
        defaultConfig()
        configureMainContainer()
        configureSubContainer()
        configureTextLabel()
    }
    
    func defaultConfig() {
        textColor = .white
        activityIndicator.style = .whiteLarge
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
    
    public func show(_ type: HUDType, hideAfter: TimeInterval = .infinity) {
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideAfter) {
            self.hide()
        }
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
            activityIndicatorView.style = .white
        }
        
        activityIndicatorView.frame = CGRect(x: 0, y: 15, width: subContainer.bounds.width, height: subContainer.bounds.height / 3.0)
        activityIndicatorView.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y)
        return activityIndicatorView
    }
}

private func getKeyWindow() -> UIWindow? {
    if #available(iOS 13.0, *), let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
        .filter({$0.isKeyWindow}).first {
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
            blurEffect = UIBlurEffect(style: .systemMaterialDark)
        } else {
            blurEffect = UIBlurEffect(style: .dark)
        }
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(visualEffectView)
    }
}
