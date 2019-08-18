//
//  RootTabBar.swift
//  AudioVideoDemo
//
//  Created by LFZ on 2019/6/1.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import SnapKit

private let item_num = CGFloat(2)

class RootTabBar: UIView {

    public var selected_item_single:((_ index:Int) -> ())?
    
    private var current_index:Int = 0
    
    // MARK: - 模糊背景
    private lazy var visual: UIVisualEffectView = {
        
        let visual = UIVisualEffectView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kTabBarH))
        let effect = UIBlurEffect.init(style: .light)
        visual.effect = effect
        visual.alpha = 0.98
        
        visual.layer.shadowColor = UIColor.black.cgColor
        visual.layer.shadowOffset = CGSize(width: 0, height: -2.5)
        visual.layer.shadowOpacity = 0.15
        
        return visual
    }()
    
    // MARK: - AudioVideo
    private lazy var audioVideo: UIView = {
        let audioVideo = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW/item_num, height: kTabBarH))
        let single = UITapGestureRecognizer.init(target: self, action: #selector(selectedAudioVideo(_:)))
        audioVideo.addGestureRecognizer(single)
        audioVideo.addSubview(audioVideo_icon)
        audioVideo.addSubview(audioVideo_title)
        return audioVideo
    }()
    private lazy var audioVideo_icon: UIImageView = {
        let audioVideo_icon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        audioVideo_icon.center = CGPoint.init(x: kScreenW/item_num/2, y: 16)
        audioVideo_icon.image = UIImage.init(named: "tabbar_audio_video_normal")
        return audioVideo_icon
    }()
    private lazy var audioVideo_title: UILabel = {
        let audioVideo_title = UILabel.init()
        audioVideo_title.textColor = UIColor.init("323232")
        audioVideo_title.textAlignment = .center
        audioVideo_title.font = UIFont.customFont_real(FontName.PFSC_Light, 11)
        audioVideo_title.text = LocalizationTool.getStr("root.tab.bar.audio.video")
        return audioVideo_title
    }()
    
    // MARK: - setting
    private lazy var setting: UIView = {
        let setting = UIView.init(frame: CGRect.init(x: kScreenW/item_num, y: 0, width: kScreenW/item_num, height: kTabBarH))
        let single = UITapGestureRecognizer.init(target: self, action: #selector(selectedSetting(_:)))
        setting.addGestureRecognizer(single)
        setting.addSubview(setting_icon)
        setting.addSubview(setting_title)
        return setting
    }()
    private lazy var setting_icon: UIImageView = {
        let setting_icon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        setting_icon.center = CGPoint.init(x: kScreenW/item_num/2, y: 16)
        setting_icon.image = UIImage.init(named: "tabbar_setting_normal")
        return setting_icon
    }()
    private lazy var setting_title: UILabel = {
        let setting_title = UILabel.init()
        setting_title.textColor = UIColor.init("323232")
        setting_title.textAlignment = .center
        setting_title.font = UIFont.customFont_real(FontName.PFSC_Light, 11)
        setting_title.text = LocalizationTool.getStr("root.tab.bar.setting")
        return setting_title
    }()
    
    
    // MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kTabBarH))
        
        self.backgroundColor = UIColor.init(white: 1, alpha: 0.8)
        self.isUserInteractionEnabled = true
        self.createRootTabBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: Language_Changed_Notification, object: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc public func changedLanguage() {
        audioVideo_title.text = LocalizationTool.getStr("root.tab.bar.audio.video")
        setting_title.text = LocalizationTool.getStr("root.tab.bar.setting")
    }
}

extension RootTabBar {
    
    //TODO: 初始化视图
    private func createRootTabBar() {
        
        self.addSubview(self.visual)
        
        self.addSubview(audioVideo)
        self.addSubview(setting)
        
        self.setup_UI()
    }
    
    //TODO: 约束
    private func setup_UI() {
        
        audioVideo_title.snp.makeConstraints { (make) in
            make.centerX.equalTo(audioVideo.snp.centerX)
            make.centerY.equalTo(audioVideo.snp.top).offset(38)
        }
        setting_title.snp.makeConstraints { (make) in
            make.centerX.equalTo(setting.snp.centerX)
            make.centerY.equalTo(audioVideo_title.snp.centerY)
        }
    }
    
    //TODO: 选中某个 tabBar
    @objc public func selectedItem(_ index:Int, block_action:Bool = true) {
        
        if block_action {
            self.selected_item_single?(index)
        }
        
        current_index = index
        
        if index != index_audioVideo {
            audioVideo_icon.image = UIImage.init(named: "tabbar_audio_video_normal")
            audioVideo_title.textColor = UIColor.init("323232")
            audioVideo_title.font = UIFont.customFont_real(FontName.PFSC_Light, 11)
        }
        if index != index_setting {
            setting_icon.image = UIImage.init(named: "tabbar_setting_normal")
            setting_title.textColor = UIColor.init("323232")
            setting_title.font = UIFont.customFont_real(FontName.PFSC_Light, 11)
        }
        
        switch index {
        case index_audioVideo:
            audioVideo_icon.image = UIImage.init(named: "tabbar_audio_video_highlight")
            audioVideo_title.textColor = UIColor.init("283282")
            audioVideo_title.font = UIFont.customFont_real(FontName.PFSC_Medium, 11)
        case index_setting:
            setting_icon.image = UIImage.init(named: "tabbar_setting_highlight")
            setting_title.textColor = UIColor.init("283282")
            setting_title.font = UIFont.customFont_real(FontName.PFSC_Medium, 11)
        default:
            break
        }
        
        UserDefaults.standard.set(NSNumber.init(value: index), forKey: last_identifier)
        UserDefaults.standard.synchronize()
    }
}

extension RootTabBar {
    
    @objc private func selectedAudioVideo(_ ges:UITapGestureRecognizer) {
        selectedItem(index_audioVideo)
    }
    @objc private func selectedSetting(_ ges:UITapGestureRecognizer) {
        selectedItem(index_setting)
    }
}
