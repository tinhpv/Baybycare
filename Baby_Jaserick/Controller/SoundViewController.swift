//
//  SoundViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 1/25/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import AVFoundation

protocol SoundPickingDelegate {
    func selectSound(selectedSoundName: String)
}

class SoundViewController: UIViewController {

    @IBOutlet weak var soundTableView: UITableView!
    
    var soundNameList: [String] = []
    var player: AVAudioPlayer?
    var selectedSoundIndex: Int = 0
    let settings = UserDefaults.standard

    var soundDelegate: SoundPickingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }
    
    func getSoundRecordedInDocuments() {
        let fm = FileManager.default
        let path = DataManager.sharedInstance.getFileUrl(fileType: .audio)
        
        do {
            let items = try fm.contentsOfDirectory(at: path, includingPropertiesForKeys: nil, options: [])
            let recordingFiles = items.filter{ $0.pathExtension == Constant.soundExtension.caf }
            let fileNames = recordingFiles.map{ $0.deletingPathExtension().lastPathComponent }
            soundNameList.append(contentsOf: fileNames)
        } catch {
            // failed to read directory – bad permissions, perhaps?
            print("fail")
        }
    }
    
    private func fetchData() {
        
        self.getSoundRecordedInDocuments()
        
        let nameList = [
            "abcd",
            "happylife",
            "vietnam",
            "anthem",
            "japan",
            "lookforsomething",
            "haha",
            "alsogood"
        ]
        soundNameList.append(contentsOf: nameList)
        
        soundTableView.tableFooterView = UIView.init(frame: .zero)
        soundTableView.tableHeaderView = UIView.init(frame: .zero)
    }
    
    func playSound(url: URL) {
       
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    } // end method
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    } // end method

}

extension SoundViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = soundTableView.dequeueReusableCell(withIdentifier: Constant.CellID.soundCell, for: indexPath) as! SoundTableViewCell
        cell.soundName.text = soundNameList[indexPath.row]
        if soundNameList[indexPath.row] == settings.string(forKey: Constant.KeySetting.alarm) {
            cell.isSelectedSound = true
        } else {
            cell.isSelectedSound = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundName = soundNameList[indexPath.row]
        var selectedSoundName: String?
        
        if let url = Bundle.main.url(forResource: soundName, withExtension: Constant.soundExtension.mp3) {
            selectedSoundName = "\(soundName).\(Constant.soundExtension.mp3)"
            self.playSound(url: url)
        } else {
            selectedSoundName = "\(soundName).\(Constant.soundExtension.caf)"
            let url = DataManager.sharedInstance.getFileUrl(fileType: .audio).appendingPathComponent("\(soundName).\(Constant.soundExtension.caf)")
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player!.prepareToPlay()
            } catch{
                print("Error")
            } // end do catch

            player?.play()
        }
    
        var cell = soundTableView.cellForRow(at: IndexPath(row: selectedSoundIndex, section: 0)) as! SoundTableViewCell
        cell.isSelectedSound = false
        cell = soundTableView.cellForRow(at: indexPath) as! SoundTableViewCell
        cell.isSelectedSound = true
        
        selectedSoundIndex = indexPath.row
        soundDelegate?.selectSound(selectedSoundName: selectedSoundName!)
    }
       
}
