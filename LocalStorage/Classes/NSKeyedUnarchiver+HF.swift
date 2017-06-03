//
//  NSKeyedUnarchiver+HF.swift
//  Pods
//
//  Created by DragonCherry on 7/19/16.
//
//

import Foundation

extension NSKeyedUnarchiver {
    
    @discardableResult
    public class func unarchive(_ path: String, key: String) -> Any? {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            return unarchiver.decodeObject(forKey: key)
        } else {
            return nil
        }
    }
}
