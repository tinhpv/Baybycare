//
//  SettingViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/25/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class SettingViewController: UITableViewController {
    
    // MARK: - IBOutlet declaration
    @IBOutlet var settingTableView: UITableView!
    @IBOutlet weak var alarmSoundSelected: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var recorderButton: UIButton!
    @IBOutlet weak var videoLabel: UILabel!
    
    // MARK: - IBOutlet declaration
    let settings = UserDefaults.standard
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    //var meterTimer: Timer!
    var isAudioRecordingGranted: Bool!
    
    let videoHelper = VideoHelper()
    
    var fileRecordingName: String = "MyRecording.\(Constant.soundExtension.caf)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initEverything()
        
        videoHelper.viewController = self
        videoHelper.completionHandler = { (videoName) in
            let setting = UserDefaults.standard
            setting.set(videoName, forKey: Constant.KeySetting.video)
            self.videoLabel.isHidden = false
        } // end completion
    }
    
    func initEverything() {
        // for a long press to record
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        recorderButton.addGestureRecognizer(longGesture)
        self.isGrantForRecording()
        
        if settings.string(forKey: Constant.KeySetting.alarm) == nil {
            settings.set("abcd.mp3", forKey: Constant.KeySetting.alarm)
        }
        
        self.switchButton.setOn(settings.bool(forKey: Constant.KeySetting.vibration), animated: false)
        self.volumeSlider.value = settings.float(forKey: Constant.KeySetting.volume)
        alarmSoundSelected.text = settings.string(forKey: Constant.KeySetting.alarm)
        
        videoLabel.isHidden = true
    }
    
    // MARK: - custome function
  
    func isGrantForRecording() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            }) // end request
            break
        default:
            break
        } // end switch
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL {
        let dataManager = DataManager.sharedInstance
        dataManager.createDirectory(fileType: .audio)
        let filePath = dataManager.getFileUrl(fileType: .audio).appendingPathComponent(self.fileRecordingName)
        return filePath
    }
    
    
    func displayAlert(msg_title : String , msg_desc : String ,action_title : String) {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default) { (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    func setupRecording() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                displayAlert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        } else {
            displayAlert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    
    func finishAudioRecording(success: Bool) {
        if success {
            audioRecorder.stop()
            audioRecorder = nil
            print("recorded successfully.")
        } else {
            displayAlert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    // MARK: - IBAction
    
    @objc func longTap(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            print("UIGestureRecognizerStateBegan")
            setupRecording()
            audioRecorder.record()
            
        } else if sender.state == .ended {
            print("UIGestureRecognizerStateEnded.")
            finishAudioRecording(success: true)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.setNamePopupVC) as! SetNameForRecordingViewController
            vc.getFileNameDelegate = self
            present(vc, animated: true)
        }
    }
    
    @IBAction func switchButton(_ sender: Any) {
        if switchButton.isOn {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))           
            settings.set(switchButton.isOn, forKey: Constant.KeySetting.vibration)
        } else {
            settings.set(switchButton.isOn, forKey: Constant.KeySetting.vibration)
        }
    }
    
    @IBAction func volumeSliderDrag(_ sender: Any) {
        let value = Float(volumeSlider.value)
        settings.set(value, forKey: Constant.KeySetting.volume)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 3:
            videoHelper.presentActionSheet(from: self)
            
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.Storyboard.soundSelectionVC) as! SoundViewController
            vc.soundDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        default: break
            
        }
        
        
        
    } //end function
}

extension SettingViewController: SoundPickingDelegate {
    func selectSound(selectedSoundName: String) {
        self.alarmSoundSelected.text = selectedSoundName
        settings.set("\(selectedSoundName)", forKey: Constant.KeySetting.alarm)
        settings.set(nil, forKey: Constant.KeySetting.video)
    }
}


extension SettingViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishAudioRecording(success: false)
        }
    }
}


extension SettingViewController: GetNameOfFileRecordingDelegate {
    
    func getNameOfFile(fileName: String) {
        // RENAME FILE
        do {
            let originPath = getFileUrl()
            self.fileRecordingName = "\(fileName).\(Constant.soundExtension.caf)"
            let destinationPath = getFileUrl()
            
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
            
            
        } catch {
            print(error)
        } // end do catch
        
        self.alarmSoundSelected.text = self.fileRecordingName
        settings.set(self.alarmSoundSelected.text, forKey: Constant.KeySetting.alarm)
        
    } // end method
}
