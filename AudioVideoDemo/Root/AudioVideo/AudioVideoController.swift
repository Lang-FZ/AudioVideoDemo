//
//  AudioVideoController.swift
//  AudioVideoDemo
//
//  Created by LFZ on 2019/8/18.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit

private let AudioVideoListIdentifier = "AudioVideoListIdentifier"

class AudioVideoController: BaseViewController, HadTabBarProtocol {
    
    lazy private var model: BaseListModel = {
        
        let model = BaseListModel.init([:])
        
        let model1 = BaseListModel.init([:])
        model1.title = "audio.video.encoder.lame"
        model1.action = { [weak self] (title) in
            self?.pushLame(title)
        }
        model.data.append(model1)
        
        return model
    }()
    
    lazy private var audioVideo_table: UITableView = {
    
        let audioVideo_table = UITableView.init(frame: CGRect.init(x: 0, y: kNaviBarH, width: kScreenW, height: kScreenH-kNaviBarH-kTabBarH), style: .plain)
        audioVideo_table.delegate = self
        audioVideo_table.dataSource = self
        audioVideo_table.backgroundColor = UIColor.init("#F0F0F0", alpha: 0.8)
        audioVideo_table.separatorStyle = .none
        audioVideo_table.estimatedRowHeight = 44.0
        audioVideo_table.rowHeight = UITableView.automaticDimension
        audioVideo_table.scrollIndicatorInsets = UIEdgeInsets.zero
        
        audioVideo_table.register(BaseListCell.self, forCellReuseIdentifier: AudioVideoListIdentifier)
        
        return audioVideo_table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationTool.getStr("audio.video.root.title")
        navigationController?.tabBarItem.title = ""
        
        view.addSubview(audioVideo_table)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changedLanguage), name: Language_Changed_Notification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("AudioVideoController-deinit")
    }
}

extension AudioVideoController {
    
    @objc public func changedLanguage() {
        audioVideo_table.reloadData()
        title = LocalizationTool.getStr("audio.video.root.title")
        navigationController?.tabBarItem.title = ""
    }
}

extension AudioVideoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioVideoListIdentifier) as! BaseListCell
        cell.model = model.data[indexPath.row]
        cell.isLast = (indexPath.row == (model.data.count-1))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        model.data[indexPath.row].action?(LocalizationTool.getStr(model.data[indexPath.row].title))
    }
}

// MARK: - 跳转

extension AudioVideoController {
    
    //TODO: Lame MP3编码
    private func pushLame(_ title:String) {
        
        let lut = LameController()
        lut.title = title
        self.navigationController?.pushViewController(lut, animated: true)
    }
}

