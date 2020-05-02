//
//  ViewController.swift
//  SwiftifyHUD
//
//  Created by monicarajendran on 04/29/2020.
//  Copyright (c) 2020 monicarajendran. All rights reserved.
//

import UIKit
import SwiftifyHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func showTextWithLoaderAction(_ sender: Any) {
        let hud = SwiftifyHUD()
        hud.show(.loaderWith(title: "Loading long texttttttttttttttttttttttttttttttttttttttttttt!!!!!!!!"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hud.hide()
        }
    }

    @IBAction func showTextAction(_ sender: Any) {
        let hud = SwiftifyHUD()
        hud.show(.text(title: "Loading..."))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hud.hide()
        }
    }
}
