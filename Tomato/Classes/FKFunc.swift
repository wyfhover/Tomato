//
//  FKFunc.swift
//  Tools
//
//  Created by Fine
//  Copyright © Fine. All rights reserved.
//

import UIKit

// MARK: - 线程相关

/// 切换全局子线程
public func g(_ closure:@escaping () -> ()) {
    DispatchQueue.global().async {
        closure()
    }
}

/// 切换主线程
public func m(_ closure:@escaping () -> ()) {
    DispatchQueue.main.async(execute: {
        closure()
    })
}

/// 子线程延迟
/// - Parameters:
///   - interval: 延迟时长
public func FKDelayG(_ interval: TimeInterval, action:@escaping () -> ()) {
    let when = DispatchTime.now() + interval
    DispatchQueue.global().asyncAfter(deadline: when, execute: action)
}

/// 主线程延迟
/// - Parameters:
///   - interval: 延迟时长
public func FKDelayM(_ interval: TimeInterval, closure:@escaping ()->()) {
    let when = DispatchTime.now() + interval
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

// MARK: - 线程锁
/// 线程锁
/// - Parameters:
///   - lock: 被锁对象
public func FKSynchronized(_ lock: Any, closure:()->()){
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

// MARK:  -  存储相关

/// 保存
public func FKSetUserDefault(_ key : String, _ value : Any?){
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

/// 获取
public func FKGetUserDefault(_ key : String) -> Any?{
    return UserDefaults.standard.object(forKey: key)
}

/// 移除
public func FKRemoveUserDefault(_ key : String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

// MARK: - 通知相关

/// 发送通知
/// - Parameters:
///   - key: 通知名
///   - userInfo: 参数
public func FKPostNotif(_ key: String, _ userInfo : [String: Any]? = nil){
    NotificationCenter.default.post(name: Notification.Name(key), object: nil, userInfo: userInfo)
}

/// 接收通知
/// - Parameters:
///   - observer: 接收对象
///   - selecter: 实现方法
///   - key: 通知名
public func FKAddObserver(_ observer: Any, _ selecter: Selector, _ key: String){
    NotificationCenter.default.addObserver(observer, selector: selecter, name: Notification.Name(key), object: nil)
}

/// 接收通知
/// - Parameters:
///   - observer: 接收对象
///   - selecter: 实现方法
///   - name: 通知名
///   - object: 携带参数
public func FKAddObserver(_ observer: Any, _ selecter: Selector, _ name: NSNotification.Name?, _ object: Any? = nil){
    NotificationCenter.default.addObserver(observer, selector: selecter, name: name, object: object)
}

/// 移除通知
/// - Parameters:
///   - observer: 接收对象
///   - key: 通知名
public func FKRemoveObserver(_ observer: Any, _ key: String? = nil ){
    if key == nil {
        NotificationCenter.default.removeObserver(observer)
    } else {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name(key!), object: nil)
    }
}

/// 有符号整形 转 无符号整形
/// - Parameters:
///   - signed: 有符号整形
///   - unsigned: 无符号整形
/// - Important: unsigned.max比signed值大。 即要求unsigned & signed二进制位相同 U.bitWidth == S.bitWidth (UInt8 -- Int8。 UInt16  -x- Int8 错误)
public func FKConvert<S: SignedInteger, U: UnsignedInteger>(signed: S, unsigned: inout U) where S: FixedWidthInteger, U: FixedWidthInteger {
    assert(U.bitWidth == S.bitWidth, "U的二进制位必须与S的二进制位相同,U.bitWidth == S.bitWidth")
    if signed >= 0 {
        unsigned = U(signed)
    } else { // 负数
        let absValue: U = U(abs(signed))
        let minusValue = ~absValue + 1
        unsigned = U(minusValue)
    }
}

/// 无符号 转 有符号
/// - Parameters:
///   - unsigned: 无符号整形
///   - signed: 有符号整形
/// - Important: 当unsigned二进制最到位为0时，比signed.max小。 即要求unsigned & signed二进制位相同 U.bitWidth == S.bitWidth (UInt8 -- Int8。 UInt16  -x- Int8 错误)
public func FKReconvert<U: UnsignedInteger, S: SignedInteger>(unsigned: U, signed: inout S) where S: FixedWidthInteger, U: FixedWidthInteger {
    assert(U.bitWidth == S.bitWidth, "U的二进制位必须与S的二进制位相同,U.bitWidth == S.bitWidth")
    if unsigned > S.max { //负数
        let signed_int = ~unsigned + 1
        var temp = signed_int << 1
        temp = temp >> 1
        
        let tValue: S = -S(temp)
        signed = tValue
    } else {
        signed = S(unsigned)
    }
}

/// 获取APP 名称
public func FKGetAppName() -> String {
    if let info = Bundle.main.infoDictionary, let value = info["CFBundleDisplayName"] as? String {
        return value
    } else {
        return ""
    }
}

/// 获取APP版本号
public func FKGetAppVersion() -> String {
    if let info = Bundle.main.infoDictionary, let value = info["CFBundleShortVersionString"] as? String {
        return value
    } else {
        return ""
    }
}

/// 获取build号
public func FKGetAppBuild() -> String {
    if let info = Bundle.main.infoDictionary, let value = info["CFBundleVersion"] as? String {
        return value
    } else {
        return ""
    }
}

/// 获取BundleID
public func FKGetBundleID() -> String {
    if let info = Bundle.main.infoDictionary, let value = info["CFBundleIdentifier"] as? String {
        return value
    } else {
        return ""
    }
}

/// 获取APP图标
public func FKGetAppIcon() -> UIImage {
    if  let infoPlist = Bundle.main.infoDictionary,
        let bundleIcons = infoPlist["CFBundleIcons"] as? [String : Any],
        let primaryIcon = bundleIcons["CFBundlePrimaryIcon"] as? [String : Any],
        let paths = primaryIcon["CFBundleIconFiles"] as? [String],
        let lastPath = paths.last,
        let image = UIImage(named: lastPath) {
        return image
    }
    return UIImage()
}

/// 截取屏幕
//public func FKScreenSnapshot(view: UIView) -> UIImage? {
//
//    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
//    view.layer.render(in: UIGraphicsGetCurrentContext()!)
//    let image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    //截取指定范围
//    return UIImage(data: image?.jpegData(compressionQuality: 0.5) ?? Data()) //image
//
//}

/// 检查APP更新
/// - Parameters:
///   - appID: appID
public func FKCheckAppUpgrade(appID: String, callback: @escaping ((Bool, String?, String?)->Void)){
    let url_str = "http://itunes.apple.com/cn/lookup?id=\(appID)"
    guard let url = URL(string: url_str) else { return }
    
    URLSession.shared.dataTask(with: url, completionHandler: { data, rsp, error in
        if error == nil, let tData = data {
            if let json = try? JSONSerialization.jsonObject(with: tData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any],
               let results = json!["results"] as? [[String: Any]],
               let kResults = results.first
            {
                let version = kResults["version"] as? String ?? "" // 版本号
                let releaseNotes = kResults["releaseNotes"] as? String ?? "" // 更新说明
                let link = kResults["trackViewUrl"] as? String // 下载地址
                
                let current_version = FKGetAppVersion()
                
                if current_version.compare(version) == .orderedAscending {
                    callback(true, releaseNotes, link)
                } else {
                    callback(false, nil, nil)
                }
                
            } else {
                callback(false, nil, nil)
            }
        } else {
            callback(false, nil, nil)
        }
    }).resume()
}
