//
//  LocalStorage.swift
//
//  Created by DragonCherry on 7/19/16.
//

import Foundation
import SwiftKeychainWrapper
import OptionalTypes
import TinyLog

open class LocalStorage {
    
    /// default file name to manage storage in document folder
    fileprivate var localStorageFile: String
    
    /// internal object key where actual directory archive reside in
    fileprivate var kLocalStorageKey                  = "kLocalStorageKey"
    
    /// status key for synchronizing keychain
    fileprivate var kLocalStorageKeychainSync         = "kLocalStorageKeychainSync"
    
    /// flag key for synchronizing flag
    fileprivate var kLocalStorageKeychainSyncStatus   = "kLocalStorageKeychainSyncStatus"
    
    // MARK: - Variables
    fileprivate var directoryType: FileManager.SearchPathDirectory
    fileprivate var dictionary: NSMutableDictionary!
    fileprivate var fullPath: String? {
        if let directory = NSSearchPathForDirectoriesInDomains(directoryType, .userDomainMask, true).first as NSString? {
            return directory.appendingPathExtension(localStorageFile)
        } else {
            loge("Failed to create path at library directory.")
            return nil
        }
    }
    
    // MARK: - Initializer
    public init(fileName: String, directoryType: FileManager.SearchPathDirectory, storageKey: String? = nil, syncKey: String? = nil, syncStatusKey: String? = nil) {
        self.localStorageFile = fileName
        self.directoryType = directoryType
        if let storageKey = storageKey { self.kLocalStorageKey = storageKey }
        if let syncKey = syncKey { self.kLocalStorageKeychainSync = syncKey }
        if let syncStatusKey = syncStatusKey { self.kLocalStorageKeychainSyncStatus = syncStatusKey }
        loadArchive()
    }
    
    
    // MARK: - APIs
    
    /// returns all keys in LocalStorage
    open var allKeys: [Any]? { return self.dictionary.allKeys }
    
    open func load(_ key: String, isInKeychain: Bool = false) -> Any? {
        
        var target: Any? = nil
        
        if isInKeychain {
            
            let objectFromDocument = synchronizedDictionary.object(forKey: key)
            
            if Bool(dictionary!.value(forKey: kLocalStorageKeychainSyncStatus)) {
                
                // synchronized successfully on last synchronization
                if let syncDict = KeychainWrapper.standard.object(forKey: kLocalStorageKeychainSync) as? NSMutableDictionary {
                    if let objectFromKeychain = syncDict.object(forKey: key) {
                        
                        // target retrieved from keychain
                        target = objectFromKeychain
                    } else {
                        
                        // return target retrieved from document if failed to access keychain (or nil same as document)
                        target = objectFromDocument
                    }
                }
                
            } else {
                
                // failed to synchronize on last synchronization, refer to document
                target = objectFromDocument
            }
            
        } else {
            
            // target from shared dictionary
            target = self.dictionary!.value(forKey: key) as Any?
        }
        
        return target
    }
    
    open func save(_ value: Any?, forKey key: String, isInKeychain: Bool = false) {
        
        if isInKeychain {
            
            // set object to synchronizer dictionary
            if let value = value {
                synchronizedDictionary.setValue(value, forKey: key)
            } else {
                synchronizedDictionary.removeObject(forKey: key)
            }
            
            // save synchronizer dictionary to keychain
            let saved = KeychainWrapper.standard.set(synchronizedDictionary, forKey: kLocalStorageKeychainSync)
            
            // save sync status
            dictionary.setValue(saved, forKey: kLocalStorageKeychainSyncStatus)
            
        } else {
            
            if let value = value {
                dictionary.setValue(value, forKey: key)
            } else {
                dictionary.removeObject(forKey: key)
            }
        }
        _ = saveArchive()
    }
    
    open func deleteStorage() {
        guard let fullPath = self.fullPath else {
            return
        }
        if FileManager.default.isDeletableFile(atPath: fullPath) {
            do {
                try FileManager.default.removeItem(atPath: fullPath)
            } catch {
                loge("\(error)")
            }
        } else {
            logw("Given path is not deletable: \(fullPath)")
        }
    }
    
    fileprivate var synchronizedDictionary: NSMutableDictionary {
        guard let syncDict = dictionary.value(forKey: kLocalStorageKeychainSync) as? NSMutableDictionary else {
            loge("Critical error while retrieving synchronized dictionary at saveObject()")
            return NSMutableDictionary()
        }
        return syncDict
    }
    
    // MARK: - Archiving Utility
    fileprivate func loadArchive() {
        guard let fullPath = self.fullPath else {
            return
        }
        if let dictionary = NSKeyedUnarchiver.unarchive(fullPath, key: kLocalStorageKey) {
            self.dictionary = dictionary
        } else {
            // create new dictionary for first use
            self.dictionary = NSMutableDictionary()
        }
        if dictionary.object(forKey: kLocalStorageKeychainSync) == nil {
            dictionary.setObject(NSMutableDictionary(), forKey: kLocalStorageKeychainSync as NSCopying)
            dictionary.setObject(true, forKey: kLocalStorageKeychainSyncStatus as NSCopying)
        }
        _ = NSKeyedArchiver.archive(self.dictionary!, path: fullPath, key: kLocalStorageKey)
    }
    
    @discardableResult
    fileprivate func saveArchive() -> Bool {
        if let fullPath = self.fullPath, let dictionary = self.dictionary {
            return NSKeyedArchiver.archive(dictionary, path: fullPath, key: kLocalStorageKey)
        }
        return false
    }
}
