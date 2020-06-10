//
//  OverRSRViewController.swift
//  RSR Pechhulp - Burak Donat
//
//  Created by Burak Donat on 17.03.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit

class OverRSRViewController: UIViewController {

    @IBOutlet weak var overTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        openUpBrowser()
    }
    //opening up the browser
    func openUpBrowser() {
        overTextView.text = Localizable.OverPage.overText.localized
        // Set how links should appear: blue and underlined
        self.overTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
}
