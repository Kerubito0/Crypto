//
//  ContentModel.swift
//  Crypto
//
//  Created by kerubito on 2021/10/06.
//

import Foundation
import SwiftUI

internal class ContentModel: ObservableObject {
    @Published public var str: String = ""
    @Published public var isEnrypto: Bool = false
        
    internal init() {
    }
    
    internal func onCrypto() {
        if isEnrypto {
            str = Crypto.decrypt(str: str)
            isEnrypto = false
        } else {
            str = Crypto.encrypt(str: str)
            isEnrypto = true
        }
    }
}
