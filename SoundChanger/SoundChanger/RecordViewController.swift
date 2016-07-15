//
//  ViewController.swift
//  SoundChanger
//
//  Created by Juntian Tao on 7/10/16.
//  Copyright © 2016 Juntian Tao. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: Outlets
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordLabl: UILabel!
    @IBOutlet weak var recordButton: UIButton!

    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
   
    // MARK: Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func Record(sender: AnyObject) {
        recordLabl.text = "Recording in Progress"
        stopButton.enabled = true
        recordButton.enabled = false
        
        // variables needed for path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //print(filePath)
        
        // record
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func Stop(sender: AnyObject) {
        recordLabl.text = "Tap to Record"
        stopButton.enabled = false
        recordButton.enabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Segue
    
    // perform the segue after recording's finished
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.performSegueWithIdentifier("recordFinished", sender: audioRecorder.url)
        } else {
            print("Saving Failed")
        }
    }
    
    //preparation for segue - bascially sending the audio url to PlaySoundViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "recordFinished" {
            let playSoundVC = segue.destinationViewController as! PlaySoundViewController
            let audioURL = sender as! NSURL
            playSoundVC.recordedAudioURL = audioURL
        }
    }
}

