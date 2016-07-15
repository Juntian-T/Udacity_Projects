//
//  PlaySoundViewController.swift
//  SoundChanger
//
//  Created by Juntian Tao on 7/14/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var chipmunk: UIButton!
    @IBOutlet weak var vader: UIButton!
    @IBOutlet weak var rabbit: UIButton!
    @IBOutlet weak var snail: UIButton!
    @IBOutlet weak var echo: UIButton!
    @IBOutlet weak var reverb: UIButton!
    
    @IBOutlet weak var stop: UIButton!
    
    // MARK: - Properties
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    enum ButtonType: Int { case Chipmunk = 0, Vader, Fast, Slow, Echo, Reverb}
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up after view being loaded
        setupAudio()
    }

    override func viewWillAppear(animated: Bool) {
        //Enable the play sound buttons
        configureUI(.NotPlaying)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func PlaySoundButtonPressed(sender: AnyObject) {
        switch ButtonType(rawValue: sender.tag)! {
        case .Chipmunk:
            playSound(pitch: 1500)
        case .Vader:
            playSound(pitch: -1000)
        case .Fast:
            playSound(rate: 2.0)
        case .Slow:
            playSound(rate: 0.2)
        case .Echo:
            playSound(echo: true)
        case . Reverb:
            playSound(reverb: true)
            
        }
        //Disable the buttons while playing
        configureUI(.Playing)
    }

    @IBAction func StopButtonPressed(sender: AnyObject) {
        stopAudio()
    }

}
