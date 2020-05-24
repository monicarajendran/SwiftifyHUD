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

    var hud: SwiftifyHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud = SwiftifyHUD(view: self.view)
    }

    @IBAction func showTextWithLoaderAction(_ sender: Any) {
        hud.show(.loaderWith(title: "Loading long texttttttttttttttttttttttttttttttttttttttttttt!!!!!!!!"))
    }

    @IBAction func showTextAction(_ sender: Any) {
        hud.show(.text(title: "Loading..."))
    }
}
