//
//  RTExporter.swift
//  iRingTunes Pro
//
//  Created by Dani Tox on 21/01/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import Foundation
import MediaPlayer

protocol ExporterDelegate {
    func exportDidFinish(withCode code: Int, andMsg msg: String?)
}

class RTExporter {
    
    var delegate : ExporterDelegate?
    
    
    var initialSong : URL               //L'URL DELLA CANZONE DA CUI PARTIRE    ---     SETTATA ALL'INIT
    var fadeIn : Bool                   //ATTIVA/DISATTIVA IL FADEIN            ---     SETTATA ALL'INIT
    var songAttributes : SongAttributes //CONTIENE IL NOME, TIMERANGE (DA CHE MINUTO A CHE MINUTO) E IL FADEIN_START? E FADEIN_DURATA?      ---     SETTATA ALL'INIT
    var exportPath : URL?               //DESTINAZIONE DEL FILE ESPORTATO       ---     NON SETTATA ALL'INIT
    
    var exportSession : AVAssetExportSession?       //IL VERO EXPORTER. DA ORA CHIAMATO EXPORTSESSION. NIL ALL'AVVIO/INIT
    private var exporterPrepared : Bool = false     //USATO PER VEDERE SE SELF È GIà STATO PREPARATO
    
    
    //INIZIALIZZA L'EXPORTER CON TUTTI GLI ATTRIBUTI NECESSARI
    init(initialSong: URL, fadeIn: Bool, songAttributes : SongAttributes) {
        self.initialSong = initialSong
        self.fadeIn = fadeIn
        self.songAttributes = songAttributes
    }
    
    func prepare() {
        //CREO UN ASSET DA ESPORTARE
        let asset = AVAsset(url: initialSong)
        
        //CREO LA SESSIONE DELL'EXPORTING - EXPORTSESSIONE
        exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
        exportSession?.outputFileType = .m4a
        
        //PRENDO IL NOME DELLA CANZONE DAGLI ATTRIBUTI CON CUI SONO STATO INIZIALIZZATO DALL'ESTERNO
        let nameSong = songAttributes.songName
        
        //OTTENGO L'OFFSET IN STRINGA DELLA DOCUMENT DIRECTORY
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
        
        //CREO LA PATH STRINGA COMPLETA DI NOME DEL FILE.ESTENSIONE
        let exportString = path.appending("/\(nameSong).m4r")
        
        //ELIMINO L'EVENTUALE FILE SE PRESENTE
        deleteFile(atPath: exportString)
        
        //SETTO L'EXPORTER (NON LA SESSIONE) OUTPUTH PATH IN FORMATO URL. È NIL ALTRIMENTI VISTO CHE NESSUNO L'HA ANCORA SETTATA
        self.exportPath = URL(fileURLWithPath: exportString)

        //CONTROLLO SE è NIL (INUTILE VISTO CHE L'HO APPENA SETTATA)
        if self.exportPath == nil {
            print("RTEXPORTER.prepare(): exportPath = nil")
            return
        }
        
        print("PATH: \(exportString)")
        print("URL: \(self.exportPath!)")
        
        //CHECK PER VEDERE SE L'EXPORTER (EXPOSRTSESSION) È NIL
        if exportSession == nil { print("RTExporter.prepare(): exportSession = nil") }
        
        //SETTO L'OUTPUT PATH DEL VERO EXPORTER (EXPORTSESSION)
        exportSession?.outputURL = self.exportPath!
        
        //CONTROLLO CHE IL TIMERANGE SIA NIL. SE NON LO È, LO DO AL VERO EXPORTER(EXPORTSESSION)
        if let timeRange = songAttributes.timeRange {
            exportSession?.timeRange = timeRange
        }
        
        //SE IL FADEIN è TRUE (OTTENUTO DA CHI MI HA INIZIALIZZATO), LO ATTIVO DANDO L'ASSET IN CUI LO ATTIVO
        if fadeIn { eneableFadeIn(asset: asset) }
        
        
        //SETTO CHE SONO PRONTO COSì SE UNO CHIAMA export() PUò FARLO SENZA PROBLEMI
        self.exporterPrepared = true
    }
    
    func export() {
        //CONTROLLO CHE IO SIA STATO PRIMA PREPARATO
        if self.exporterPrepared == false { print("RTExporter Error: You have to call prepare() before export()"); return }
        
        //CONTROLLO ANCORA CHE L'OUPUTH PATH NON SIA NIL
        guard let outputPath = self.exportSession?.outputURL?.absoluteString else {
            print("RTExporter.export(): can't get outputPath from exporter?.outputURL?.absolutString")
            return
        }
        
        //CONTROLLO SE ESISTE IL FILE NELLA DESTINAZIONE. SE ESISTE, RITORNO
        if FileManager.default.fileExists(atPath: outputPath) { print("File exists. Export aborted"); return }
        
        
        //INIZIO L'EXPORTING E MANDO I MESSAGGI AL DELEGATE
        self.exportSession?.exportAsynchronously(completionHandler: {
            guard let status = self.exportSession?.status else { return }
            switch status {
            case .completed:
                print (status.rawValue)
                self.delegate?.exportDidFinish(withCode: 0, andMsg: nil)
            case .exporting:
                print("exporting...")
            case .failed:
                print("RTEXpoert.export().failed")
                self.delegate?.exportDidFinish(withCode: 1, andMsg: "\(self.exportSession?.error ?? "nomsg" as! Error)")
            default:
                print("RTExporter.export(): È usito default nello switch del risultato dell'export. Errore")
            }
            
            
        })
    }
    
    
    
    
    private func eneableFadeIn(asset: AVAsset) {
        //CREO UN AUDIO MIX E OTTENGO LA TRACCIA DALL'ASSET
        let audioMix = AVMutableAudioMix()
        let track = asset.tracks(withMediaType: .audio).first
        
        //CONTROLLO CHE QUESTI DUE PARAMETRI SIANO STATI SETTATI DA CHI HA INIZIALIZZATO L'INTERA CLASSE CON I songAttributes
        guard let TEMPdurationFade = songAttributes.durationFade else { return }
        guard let TEMPstartFade = songAttributes.startFade else { return }
        
        //CONVERTO NEI VARI FORMATI NECESSARI
        let durationFade = CMTime(seconds: Double(TEMPdurationFade), preferredTimescale: 1)
        let startFade = CMTime(seconds: Double(TEMPstartFade), preferredTimescale: 1)
        
        let params = AVMutableAudioMixInputParameters(track: track)
        let fadeTimeRange = CMTimeRange(start: startFade, duration: durationFade)
        params.setVolumeRamp(fromStartVolume: 0.0, toEndVolume: 1.0, timeRange: fadeTimeRange)
        audioMix.inputParameters = [params]
        
        
        //SETTO L'AUDIO MIX ALL'EXPORT SESSION
        exportSession?.audioMix = audioMix
        
    }
    
    //UTILIZZATO PER ELIMINARE FILE
    private func deleteFile(atPath path : String) {
        let fl = FileManager.default
        if fl.fileExists(atPath: path) {
            print("RTExporter.deleteFile(atPath): FILE ESISTE. QUINDI ELIMINO A:\n\(path)")
            do {
                try fl.removeItem(atPath: path)
            }
            catch {
                print("RTExporter.deleteFile(atPath): ERRORE ELIMINAZIONE:\n\(error)\nFine error of RTExporter.deleteFile(atPath)")
            }
        }
    }
    
    
    
    //NON UTILIZZATO - FORSE NON FUNZIONANTE
    private func deleteFile(atURL url: URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.absoluteString) {
            do {
                try fileManager.removeItem(at: url)
            } catch {
                print("RTExporter.deleteFile(atURL) error:\n\(error)\nFine error of RTExporter.deleteFile(atURL)")
            }
        }
    }
    
    
}



