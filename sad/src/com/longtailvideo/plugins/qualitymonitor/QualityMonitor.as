package com.longtailvideo.plugins.qualitymonitor {


import com.longtailvideo.jwplayer.events.MediaEvent;
import com.longtailvideo.jwplayer.events.PlayerStateEvent;
import com.longtailvideo.jwplayer.player.IPlayer;
import com.longtailvideo.jwplayer.plugins.IPlugin;
import com.longtailvideo.jwplayer.plugins.PluginConfig;
import com.longtailvideo.plugins.qualitymonitor.Sparkline;

import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;
import flash.text.*;
import flash.utils.*;


/** Small plugin that displays bandwidth, screensize, droppedframes and quality level. **/
public class QualityMonitor extends Sprite implements IPlugin {


    /** Reference to the player. **/
    private var _player:IPlayer;
    /** Reference to the background clip. **/
    private var _back:Sprite;
    /** Reference to the textfield. **/
    private var _field:TextField;
    /** Reference to the transition-complete message. **/
    private var _transitioned:TextField;
    /** Reference to the checking interval. **/
    private var _interval:Number;
    /** List with sparkline instances. **/
    private var _lines:Array;


    /** Add sparklines to the plugin. **/
    private function addLine(max:Number,clr:Number):Sparkline {
        var lne:Sparkline = new Sparkline(200,90,0,max,clr);
        lne.x = 190;
        lne.y = 12;
        addChild(lne);
        return lne;
    };


    /** Build the plugin graphics. **/
    private function buildStage():void {
        mouseEnabled = false;
        mouseChildren = false;
        _back = new Sprite();
        _back.graphics.beginFill(0x000000,0.8);
        _back.graphics.drawRect(0,0,400,116);
        addChild(_back);
        _field = new TextField();
        _field.width = 180;
        var fmt:TextFormat = new TextFormat("_sans",11,0xFFFFFF);
        fmt.leading = 10;
        _field.defaultTextFormat = fmt;
        _field.multiline = true;
        _field.y = 12;
        _field.x = 16;
        addChild(_field);
        _transitioned = new TextField();
        var tfm:TextFormat = new TextFormat("_sans",15,0x00FF00,true);
        _transitioned.defaultTextFormat = tfm;
        _transitioned.width = 150;
        _transitioned.text = "Transition complete";
        _transitioned.visible = false;
        addChild(_transitioned);
        _lines = new Array(
            addLine(5000,0xFF0000),
            addLine(25,0x00FF00),
            addLine(6,0xFFFFFF),
            addLine(2000,0x0000FF)
        );
    };


    /** Update quality metrics **/
    private function checkQuality():void {
        var arr:Array = _player.playlist.currentItem.levels;
        var idx:Number = _player.playlist.currentItem.currentLevel;
        var lvl:String = (idx+1) + ' of ' + arr.length;
        var drp:Number = 0;
        try { 
            lvl += ' (' + arr[idx]['bitrate'] + 'kbps, ' + arr[idx]['width'] + 'px)';
        } catch (e:Error) {}
        _field.htmlText = 
            '<font color="#FF0000"><b>Available Bandwidth:</b> ' + _player.config['bandwidth'] + ' kbps<br/></font>' +
            '<font color="#00FF00"><b># of Dropped Frames</b> ' + 0 + '<br/></font>' +
            '<font color="#FFFFFF"><b>Current Streaming Level</b> ' + lvl + '<br/></font>' +
            '<font color="#0000FF"><b>Width:</b> '+ _player.config['width'] + ' pixels</font>';
        _lines[0].spark(_player.config['bandwidth']);
        _lines[1].spark(drp);
        _lines[2].spark(arr.length - idx);
        _lines[3].spark(_player.config['width']);
    };


    /** Returns the plugin name. **/
    public function get id():String {
        return "qualitymonitor";
    };


    /** Called by the player to initialize; setup events and dock buttons.  */
    public function initPlugin(player:IPlayer, config:PluginConfig):void {
        _player = player;
        _player.addEventListener(MediaEvent.JWPLAYER_MEDIA_META,metaHandler);
        _player.addEventListener(PlayerStateEvent.JWPLAYER_PLAYER_STATE,stateHandler);
        buildStage();
        checkQuality();
    };


    /** Blip a transition complete text in the display. **/
    private function metaHandler(event:MediaEvent):void {
        if(event.metadata.code && event.metadata.code == 'NetStream.Play.TransitionComplete') {
            _transitioned.visible = true;
            setTimeout(transitionTimeout,2500);
        }
    };


    /** Only update the plugin when the video is playing. **/
    private function stateHandler(evt:PlayerStateEvent):void {
        if (evt.newstate == 'PLAYING') {
            _interval = setInterval(checkQuality,100);
        } else {
            clearInterval(_interval);
        }
    };


    /** Hide the transitioning text again. **/
    private function transitionTimeout():void {
        _transitioned.visible = false;
    };


    /** Reposition the monitor when the player resizes itself **/
    public function resize(wid:Number, hei:Number):void {
        _back.width = wid;
        _field.width = wid/2-10;
        for(var i:Number=0; i<_lines.length; i++) {
            _lines[i].resize(wid - 200);
        }
        _transitioned.x = wid / 2 - 75;
        _transitioned.y = hei / 2 - 10;
    };


}


}