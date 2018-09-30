//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Ivan Murashov on 29/08/2018.
//  Copyright © 2018 Ivan Murashov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer?
    var timer: Timer?
    var duration: TimeInterval = 0.0
    var progressValue: TimeInterval = 0.0
    
    @IBOutlet weak var progress: UISlider!
    
    @IBAction func updateProgressManually(_ sender: Any) {
        progressValue = TimeInterval((sender as! UISlider).value) * duration
        player?.currentTime = TimeInterval(progressValue)
    }
    
    @IBAction func play(_ sender: Any) {
        player?.play()
        if (timer == nil) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
                self.progressValue += 1
                self.progress.value = Float(self.progressValue / self.duration)
            })
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        player?.pause()
    }
    
    @IBAction func volume(_ sender: Any) {
        player?.volume = (sender as! UISlider).value * 100
    }
    
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let audioPath = Bundle.main.path(forResource: "Devil_Trigger", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            duration = player!.duration
            volumeSlider.value = player!.volume / 100
        } catch {
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

