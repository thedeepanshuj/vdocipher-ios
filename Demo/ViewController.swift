//
//  ViewController.swift
//  Demo
//
//  Created by Deepanshu Jain on 05/02/19.
//  Copyright © 2019 Deepanshu Jain. All rights reserved.
//

import UIKit
import AVFoundation
import VdoCipherKit

class ViewController: UIViewController {

    @IBOutlet weak var playerViewOl: VdoPlayerView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        progressSlider.isEnabled = false
        try! playerViewOl.loadVideo(
            otp: "OTP",
            playbackInfo: "PLAYBACKINFO",
            onPlayerReady: {() in
                print("loading complete")
                let duration : CMTime = (self.playerViewOl.player!.currentItem?.asset.duration)!
                let seconds : Float64 = CMTimeGetSeconds(duration)
                self.progressSlider!.maximumValue = Float(seconds)
                self.progressSlider.isEnabled = true
                self.playerViewOl.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                    if self.playerViewOl.player!.currentItem?.status == .readyToPlay {
                        let time : Float64 = CMTimeGetSeconds(self.playerViewOl.player!.currentTime());
                        self.progressSlider!.value = Float (time);
                        self.currentTime!.text = self.playerViewOl.player!.currentTime().durationText
                        self.duration!.text = self.playerViewOl.player!.currentItem?.asset.duration.durationText
                    }
                }
        }
        )
    }
    @IBAction func sliderChange(_ sender: UISlider) {
        let seconds : Int64 = Int64(self.progressSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        self.playerViewOl.player!.seek(to: targetTime)
        
        if self.playerViewOl.player!.rate == 0
        {
            self.playerViewOl.player?.play()
        }
    }
    @IBAction func toggleButton(_ sender: UIButton) {
        if (sender.currentTitle == "Pause") {
            playerViewOl.player?.pause()
            sender.setTitle("Play", for: .normal)
        } else if (sender.currentTitle == "Play") {
            playerViewOl.player?.play()
            sender.setTitle("Pause", for: .normal)
        }
        
    }

}

extension CMTime {
    var durationText:String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours:Int = Int(totalSeconds / 3600)
        let minutes:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds:Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
