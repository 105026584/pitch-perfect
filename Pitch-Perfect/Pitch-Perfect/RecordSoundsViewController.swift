//
//  RecordSoundsViewController.swift
//  Pitch-Perfect
//
//  Created by Andreas Pfister on 10/04/15.
//  Copyright (c) 2015 General Electrics. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var isPaused:Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        isPaused = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        if (audioRecorder == nil) {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            
            audioRecorder.prepareToRecord()
        }
        
        if (audioRecorder.recording) {
            recordingLabel.text = "Recording paused...\n...tap again to continue recording"
            audioRecorder.pause()
            isPaused = true
            recordButton.setImage(UIImage(named: "microphone_continue"), forState: .Normal)
        } else if ((isPaused) != nil && isPaused == true) {
            recordingLabel.text = "Recording...\n...tap again to pause recording"
            audioRecorder.record()
            isPaused = false
            recordButton.setImage(UIImage(named: "microphone_pause"), forState: .Normal)
        } else {
            audioRecorder.record()
            stopButton.hidden = false
            recordingLabel.text = "Recording...\n...tap again to pause recording"
            recordButton.setImage(UIImage(named: "microphone_pause"), forState: .Normal)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Because of any reason recording was not possible...");
            recordingLabel.hidden = true
            stopButton.hidden = true
            recordButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            audioRecorder = nil
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordingLabel.text = "Tap to record"
        stopButton.hidden = true
        recordButton.enabled = true
        recordButton.setImage(UIImage(named: "microphone"), forState: .Normal)
        audioRecorder.stop()
        isPaused = false
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
}

