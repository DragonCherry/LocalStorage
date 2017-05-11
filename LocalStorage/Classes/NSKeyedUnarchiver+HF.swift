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
    public class func unarchive(_ path: String, key: String) -> NSMutableDictionary? {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let unarchiver: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data)
            guard let unarchivedObject = unarchiver.decodeObject(forKey: key) else {
                return nil
            }
            if let dictionary: NSMutableDictionary = unarchivedObject as? NSMutableDictionary {
                return dictionary
            }
        }
        return nil
    }
}
