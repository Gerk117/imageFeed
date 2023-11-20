//
//  UIBlockingProgressHUD.swift
//  imageFeed
//
//  Created by Георгий Ксенодохов on 31.10.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
        
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
    
}
