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
        
        var ioNode:AUNode = AUNode()
        var ioUnitDescription = AudioComponentDescription.init(componentType: OSType.init(bitPattern: Int32(kAudioUnitType_Output)), componentSubType: OSType.init(bitPattern: Int32(kAudioUnitSubType_RemoteIO)), componentManufacturer: OSType.init(bitPattern: Int32(kAudioUnitManufacturer_Apple)), componentFlags: 0, componentFlagsMask: 0)
        AUGraphAddNode(processingGraph!, &ioUnitDescription, &ioNode)

        AUGraphOpen(processingGraph!)

        var ioUnit:AudioUnit?
        AUGraphNodeInfo(processingGraph!, ioNode, nil, &ioUnit)
        
        return ioUnit!
    }()
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //使用扬声器
        var status:OSStatus = noErr
        var oneFlag = 1
        let busZero = 0
        status = AudioUnitSetProperty(ioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, AudioUnitElement(busZero), &oneFlag, UInt32(MemoryLayout.size(ofValue: oneFlag)))
        checkStatus(status, "Could not Connect To Speaker", true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        print("AudioUnitPracticeController-deinit")
    }
}

extension AudioUnitPracticeController {
    
    private func checkStatus(_ status:OSStatus, _ message:String, _ fatal:Bool) {
        
        if status != noErr {
            
            var fourCC:[Character] = [Character](repeating: Character(UnicodeScalar(0)), count: 16)
            fourCC[0] = Character(UnicodeScalar(CFSwapInt32HostToBig(UInt32(status))) ?? UnicodeScalar(0))
            fourCC[4] = Character(UnicodeScalar(0))
            
            if Bool(truncating: NSNumber(value: isprint(Int32(fourCC[0].unicodeScalars.first?.value ?? 0)))) && Bool(truncating: NSNumber(value: isprint(Int32(fourCC[1].unicodeScalars.first?.value ?? 0)))) && Bool(truncating: NSNumber(value: isprint(Int32(fourCC[2].unicodeScalars.first?.value ?? 0)))) && Bool(truncating: NSNumber(value: isprint(Int32(fourCC[3].unicodeScalars.first?.value ?? 0)))) {
                print("\(message) : " + String.init(format: "%s", fourCC))
            } else {
                print("\(message) : " + String.init(format: "%d", Int(status)))
            }
            
            if fatal {
                exit(-1)
            }
        }
    }
}
