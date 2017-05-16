//
//  ViewController.swift
//  LocalStorage
//
//  Created by DragonCherry on 05/11/2017.
//  Copyright (c) 2017 DragonCherry. All rights reserved.
//

import UIKit
import LocalStorage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SharedPreference.default.save("TEST_STRING", forKey: "MY_STRING_KEY")
        SharedPreference.default.save(["TEST_KEY": "TEST_VALUE"], forKey: "MY_DICTIONARY_KEY")
        SharedPreference.default.save([100, 10, 1], forKey: "MY_ARRAY_KEY")
        
        print("\(SharedPreference.default.load("MY_STRING_KEY").debugDescription)")
        print("\(SharedPreference.default.load("MY_DICTIONARY_KEY").debugDescription)")
        print("\(SharedPreference.default.load("MY_ARRAY_KEY").debugDescription)")
    }
}


class SharedPreference {
    static let `default` = { return LocalStorage(fileName: "preference.db", directoryType: .libraryDirectory) }()
    private init() {}
}
