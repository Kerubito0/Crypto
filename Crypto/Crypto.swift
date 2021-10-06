//
//  Crypto.swift
//  Crypto
//
//  Created by kerubito on 2021/10/06.
//

import Foundation

internal class Crypto {
    
    internal static func encrypt(str: String) -> String {
        createPrivateKey()
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512
        guard let publickey = getPublicKey() else {
            return ""
        }
        guard SecKeyIsAlgorithmSupported(publickey, .encrypt, algorithm) else {
           return ""
        }
        guard (str.count < (SecKeyGetBlockSize(publickey)-130)) else {
            return ""
        }

        let plainTextData = str.data(using: .utf8)

        guard let cipherText = SecKeyCreateEncryptedData(
            publickey,
            algorithm,
            plainTextData! as CFData,
            nil ) else {
                return ""
            }

        let data = cipherText as Data
        return data.base64EncodedString()
    }
    
    internal static func decrypt(str: String) -> String {
        let decryptedCipherText = Data(base64Encoded: str, options: [])
        let algorithm: SecKeyAlgorithm = .rsaEncryptionOAEPSHA512

        guard let privateKey = getPrivateKey() else {
            return ""
        }
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
            return ""
        }
        guard let text = SecKeyCreateDecryptedData(
            privateKey,
            algorithm,
            decryptedCipherText! as CFData,
            nil ) else {
                    return ""
            }
        return String(data: text as Data, encoding: .utf8) ?? ""

    }
    
    private static func createPrivateKey() {
        let tagForPrivateKey = "com.example.keys.privatekey".data(using: .utf8)!

        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: tagForPrivateKey]
        ]

        var error: Unmanaged<CFError>?

        guard let generatedPrivateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            return
        }
    }
    
    private static func getPrivateKey() -> SecKey?{
        let tagForPrivateKey = "com.example.keys.privatekey".data(using: .utf8)!

        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tagForPrivateKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecReturnRef as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            return nil
        }

        let retrievedPrivateKey = item as! SecKey
        return retrievedPrivateKey
    }
    
    private static func getPublicKey() -> SecKey?{
        guard let privateKey = getPrivateKey() else {
            return nil
        }
        return SecKeyCopyPublicKey(privateKey)
    }
}
