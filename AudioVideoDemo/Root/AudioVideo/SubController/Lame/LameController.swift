//
//  LameController.swift
//  AudioVideoDemo
//
//  Created by LFZ on 2019/8/18.
//  Copyright © 2019 LFZ. All rights reserved.
//

import UIKit
import AVFoundation

class LameController: BaseViewController {

    private var pcm_arr:[String] = []
    
    private var audioRecorder: AVAudioRecorder?
    
    //录音
    private lazy var record: UIButton = {
        let record = UIButton.init(type: .custom)
        record.frame = CGRect.init(x: 50, y: 200, width: 100, height: 50)
        record.setTitle("录音", for: .normal)
        record.setTitleColor(UIColor("323232"), for: .normal)
        record.titleLabel?.font = UIFont.custom(FontName.PFSC_Regular, 15)
        record.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(recordAudioFile(_:))))
        return record
    }()
    //编码
    private lazy var encode: UIButton = {
        let encode = UIButton.init(type: .custom)
        encode.frame = CGRect.init(x: 50, y: 300, width: 100, height: 50)
        encode.setTitle("编码", for: .normal)
        encode.setTitleColor(UIColor("323232"), for: .normal)
        encode.titleLabel?.font = UIFont.custom(FontName.PFSC_Regular, 15)
        encode.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(encodeMp3)))
        return encode
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(record)
        view.addSubview(encode)
    }
    deinit {
        print("LameController-deinit")
    }
}

extension LameController {
    
    private func recordSetting() -> [String: Any] {
        
        var recordSetting = [String: Any]()
        //format of record
        /*
         kAudioFormatMPEG4AAC压缩格式能在显著减小文件的同时，保证音频的质量。
         */
        recordSetting[AVFormatIDKey] = NSNumber(value: kAudioFormatLinearPCM)
        //sampling rate of record
        /* 采样率越高，文件越大，质量越好，反之，文件小，质量相对差一些，但是低于普通的音频，人耳并不能明显的分辨出好坏。最终选取哪一种采样率，由我们的耳朵来判断。建议使用标准的采样率，8000、16000、22050、44100。
         */
        recordSetting[AVSampleRateKey] = NSNumber(value: 44100)
        //The quality of record
        recordSetting[AVEncoderAudioQualityKey] = NSNumber(value: AVAudioQuality.high.rawValue)
        //线性采样位数  8、16、24、32
        recordSetting[AVLinearPCMBitDepthKey] = NSNumber(value: 16)
        //录音通道数  1 或 2
        /*
         AVNumberOfChannelsKey用于指定记录音频的通道数。1为单声道，2为立体声。
         */
        recordSetting[AVNumberOfChannelsKey] = NSNumber(value: 2)
        
        return recordSetting
    }
    
    @objc private func recordAudioFile(_ long:UILongPressGestureRecognizer) {
        
        if long.state == .began {
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            let pcmPath = path.appending("/pcm_\(pcm_arr.count+1).pcm")
            pcm_arr.append("pcm_\(pcm_arr.count+1)")
            
            let recorder = try! AVAudioRecorder.init(url: URL.init(fileURLWithPath: pcmPath), settings: recordSetting())
            recorder.prepareToRecord()
            recorder.record()
            self.audioRecorder = nil
            self.audioRecorder = recorder
            
        } else if long.state == .ended {
            
            audioRecorder?.stop()
        }
    }
    
    @objc private func encodeMp3() {
        
        mp3_encoder_oc.encodePCM(toMP3: pcm_arr.last ?? "")
        pcm_arr.removeLast()
    }
}
