//
//  AudioUnitPracticeController.swift
//  AudioVideoDemo
//
//  Created by LangFZ on 2019/9/3.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation

class AudioUnitPracticeController: BaseViewController {
    
    // MARK: - 懒加载
    private lazy var audio_session: AVAudioSession = {
        
        let audio_session = AVAudioSession.sharedInstance()

        do {
            try audio_session.setCategory(.playAndRecord)
            try audio_session.setPreferredIOBufferDuration(TimeInterval.init(0.002))
            try audio_session.setPreferredSampleRate(Double.init(44100))
            try audio_session.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        } catch { }

        return audio_session
    }()
    
    private lazy var ioUnitInstance: AudioUnit = {

        var ioUnitInstance:AudioUnit?
        
        var ioUnitDescription = AudioComponentDescription.init(componentType: OSType.init(bitPattern: Int32(kAudioUnitType_Output)), componentSubType: OSType.init(bitPattern: Int32(kAudioUnitSubType_RemoteIO)), componentManufacturer: OSType.init(bitPattern: Int32(kAudioUnitManufacturer_Apple)), componentFlags: 0, componentFlagsMask: 0)
        var ioUnitRef = AudioComponentFindNext(nil, &ioUnitDescription)
        
        AudioComponentInstanceNew(ioUnitRef!, &ioUnitInstance)
        
        return ioUnitInstance!
    }()
    private lazy var ioUnit: AudioUnit = {
        
        var processingGraph:AUGraph?
        NewAUGraph(&processingGraph)
        
        var ioNode:AUNode?
        var ioUnitDescription = AudioComponentDescription.init(componentType: OSType.init(bitPattern: Int32(kAudioUnitType_Output)), componentSubType: OSType.init(bitPattern: Int32(kAudioUnitSubType_RemoteIO)), componentManufacturer: OSType.init(bitPattern: Int32(kAudioUnitManufacturer_Apple)), componentFlags: 0, componentFlagsMask: 0)
        AUGraphAddNode(processingGraph!, &ioUnitDescription, &ioNode!)
        
        AUGraphOpen(processingGraph!)
        
        var ioUnit:AudioUnit?
        AUGraphNodeInfo(processingGraph!, ioNode!, nil, &ioUnit)
        
        return ioUnit!
    }()
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("AudioUnitPracticeController-deinit")
    }
}

extension AudioUnitPracticeController {
    
    
}
