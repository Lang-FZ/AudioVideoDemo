//
//  RootTabBarController.swift
//  AudioVideoDemo
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

//上一次退出app的索引
public let last_identifier  = "iGola_last_selecte_tabBar_index"
public let index_audioVideo = 0
public let index_setting    = 1

class RootTabBarController: BaseTabBarController {
    
    //Flights
    private lazy var audioVideo = AudioVideoController()
    private lazy var audioVideoController: BaseNavigationController = {
        let audioVideoController = BaseNavigationController.init(rootViewController: audioVideo)
        audioVideoController.tabBarItem.isEnabled = false
        return audioVideoController
    }()
    //Explore
    private lazy var setting = SettingController()
    private lazy var settingController: BaseNavigationController = {
        let settingController = BaseNavigationController.init(rootViewController: setting)
        settingController.tabBarItem.isEnabled = false
        return settingController
    }()
    
    //TabBar
    private lazy var custom_tabBar: RootTabBar = {
        
        let custom_tabBar = RootTabBar.init(frame: CGRect.zero)
        
        custom_tabBar.selected_item_single = { [weak self] (index) in
            self?.selectedVC(index)
        }
        
        return custom_tabBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(audioVideoController)
        addChild(settingController)
        tabBar.addSubview(custom_tabBar)
        
        custom_tabBar.selectedItem(getLastIndex())
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RootTabBarController {
    
    //TODO: 获取上一次退出app的索引
    private func getLastIndex() -> Int {
        
        var last_index = index_audioVideo
        
        if let cache_index = UserDefaults.standard.value(forKey: last_identifier) as? Int {
            last_index = cache_index
        }
        
        return last_index
    }
}

// MARK: - 切换控制器、get当前控制器

extension RootTabBarController {
    
    //TODO: 外部修改当前选中
    public func changeCurrentVC(_ index:Int) {
        custom_tabBar.selectedItem(index)
    }
    
    //TODO: 切换 TabBar 选中
    private func selectedVC(_ index:Int) {
        self.selectedIndex = index
    }
    
    //TODO: 拿到当前VC
    public func currentViewController() -> UIViewController {

        if let modalVC = self.presentedViewController {
            return modalVC
        }
        
        switch selectedIndex {
        
        case index_audioVideo:
            return audioVideoController.topViewController ?? audioVideo
        
        case index_setting:
            return settingController.topViewController ?? setting
        
        default:
            return audioVideoController.topViewController ?? audioVideo
        }
    }
    
    //TODO: 拿到当前根VC
    public func currentRootViewController() -> UIViewController {
        
        switch selectedIndex {
            
        case index_audioVideo:
            return audioVideo
            
        case index_setting:
            return setting
            
        default:
            return audioVideo
        }
    }
    
    //TODO: 当前所在 navigationController
    public func currentNavigationController() -> BaseNavigationController {
        
        switch selectedIndex {
            
        case index_audioVideo:
            return audioVideoController
            
        case index_setting:
            return settingController
            
        default:
            return audioVideoController
        }
    }
}

// MARK: - 跳转

extension RootTabBarController {
    
    //TODO: AudioVideo
    @objc public func go_to_audioVideo(_ animated:Bool = false) {
        currentNavigationController().popToRootViewController(animated: animated)
        changeCurrentVC(index_audioVideo)
    }
    //TODO: setting
    @objc public func go_to_setting(_ animated:Bool = false) {
        currentNavigationController().popToRootViewController(animated: animated)
        changeCurrentVC(index_setting)
    }
}
