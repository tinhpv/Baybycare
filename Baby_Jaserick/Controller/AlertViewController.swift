//
//  AlertViewController.swift
//  Baby_Jaserick
//
//  Created by TinhPV on 2/10/19.
//  Copyright © 2019 TinhPV. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import AudioToolbox

class AlertViewController: UIViewController {
    
    @IBOutlet weak var childCollectionView: UICollectionView!
    @IBOutlet weak var routeName: UILabel!
    @IBOutlet weak var slideButton: MMSlidingButton!
    @IBOutlet weak var rippleView: UIView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var timeUpView: UIView!
    
    var pulseLayers = [CAShapeLayer]()
    var currentRoute: Route?
    var timer = Timer()
    
    // sound
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        slideButton.delegate = self
        routeName.text = currentRoute?.routeName
        self.createPulse()
        self.videoPlayerView.isHidden = true
        
        if let videoName = UserDefaults.standard.string(forKey: Constant.KeySetting.video) {
            self.playVideo(videoName: videoName)
            self.videoPlayerView.isHidden = false
        } else {
            self.prepareForPlayingSound()
        }
        
        if UserDefaults.standard.bool(forKey: Constant.KeySetting.vibration) {
            playVibration()
        }
    }
    
    
    func playVibration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.playVib), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func playVib() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func createPulse() {
        timeUpView.layer.cornerRadius = timeUpView.frame.width / 2
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 2.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: rippleView.frame.size.width/2.0, y: rippleView.frame.size.width/2.0)
            rippleView.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animatePulse(index: 2)
                }
            }
        }
    }
    
    
    func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.black.cgColor
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.9
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
    
    func updateInactiveRoute() {
        // update the status of current route
        let updatingRoute = Route()
        updatingRoute.routeID = (currentRoute?.routeID)!
        updatingRoute.routeName = (currentRoute?.routeName)!
        updatingRoute.icon = (currentRoute?.icon) ?? nil
        updatingRoute.hour = (currentRoute?.hour) ?? nil
        updatingRoute.minute = (currentRoute?.minute) ?? nil
        updatingRoute.pickerWay = (currentRoute?.pickerWay) ?? nil
        updatingRoute.childList = (currentRoute?.childList)!
        
        updatingRoute.isActive = false
        DBManager.sharedInstance.updateRoute(with: (currentRoute?.routeID)!, newRouteForUpdate: updatingRoute)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    } // end method
    
    func prepareForPlayingSound() {
        let soundSetting = UserDefaults.standard
        if let soundName = soundSetting.value(forKey: Constant.KeySetting.alarm) as? String,
            let volume = soundSetting.value(forKey: Constant.KeySetting.volume) as? Float {
            if let url = Bundle.main.url(forResource: soundName, withExtension: "") {
                self.playSound(url: url)
            } else {
                let url = getDocumentsDirectory().appendingPathComponent("\(soundName)")
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.setVolume(volume, fadeDuration: 1)
                    player!.prepareToPlay()
                } catch{
                    print("Error")
                } // end do catch
                
                player?.play()
            }
        }
    }
    
    func playSound(url: URL) {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            let soundSetting = UserDefaults.standard
            if let volume = soundSetting.value(forKey: Constant.KeySetting.volume) as? Float {
                player.setVolume(volume, fadeDuration: 1)
            }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    } // end method
    
    private func playVideo(videoName: String) {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var fileURL = DataManager.sharedInstance.getFileUrl(fileType: .video)
            fileURL.appendPathComponent("\(videoName).MOV")
            
            let player = AVPlayer(url: fileURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoPlayerView.bounds
            self.videoPlayerView.layer.addSublayer(playerLayer)
            player.play()
        }
        
        
    
    }
}

extension AlertViewController: SlideButtonDelegate {
    
    func buttonStatus(status: String, sender: MMSlidingButton) {
        if status == "End" {
            let currentActiveRouteSave = UserDefaults.standard
            currentActiveRouteSave.setValue(nil, forKey: Constant.KeyProgram.activeRouteID)
            updateInactiveRoute()
            player?.pause()
            player = nil
            timer.invalidate()
            self.dismiss(animated: true, completion: nil)
        } // end if
        
    }
}

extension AlertViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.currentRoute?.childList.count)!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = childCollectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellID.activeChildCell, for: indexPath) as! ActiveChildCollectionViewCell
        cell.activeChild = self.currentRoute?.childList[indexPath.row]
        return cell
    }
    
}
