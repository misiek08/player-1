package com.longtailvideo.plugins.flow
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.parsers.*;
    import com.wessite.coverflow.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;

    public class Flow extends Sprite implements PluginInterface
    {
        public var config:Object;
        private var view:AbstractView;
        private var coverFlow:CoverFlow;
        protected var back:Sprite;
        private var masker:Sprite;
        private var textField:TextField;
        private var timer:Timer;
        private var controlIcon:FlowBarIcon;
        private var playlist:Vector.<Object>;
        private var showText:Boolean;
        private var indexMap:Array;
        private var bufferIcon:BufferIcon;

        public function Flow()
        {
            this.config = {size:150, defaultcover:"http://p.d.plxe.tv/img/defaultc.jpg", xposition:0, yposition:0, coverwidth:150, coverheight:"auto", covergap:40, coverangle:60, coverdepth:150, coveroffset:60, focallength:500, opacitydecrease:0.1, reflectionopacity:0.3, reflectionratio:155, reflectionoffset:0, showtext:true, textstyle:"div{color:#f1f1f1; textAlign:center; fontFamily:Arial Rounded MT Bold;} h1{fontSize:13; leading:5;} h2{fontSize:11;}", textoffset:0, tweentime:0.8, framerate:60, rotatedelay:0, controlbaricon:false, buffericon:false, file:undefined, backgroundcolor:undefined};
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            this.view = param1;
            var _loc_2:* = Capabilities.version.split(",")[0].split(" ")[1];
            if (_loc_2 < 10 || !transform.perspectiveProjection)
            {
                return;
            }
            if (this.config.backgroundcolor == undefined)
            {
                this.config.backgroundcolor = this.view.config["screencolor"] ? (this.view.config["screencolor"]) : ("0x000000");
            }
            this.config.backgroundcolor = this.config.backgroundcolor.indexOf("0x") != -1 ? (uint(this.config.backgroundcolor)) : (uint("0x" + this.config.backgroundcolor));
            this.showText = this.config.showtext;
            this.back = new Sprite();
            this.back.graphics.clear();
            this.back.graphics.beginFill(this.config.backgroundcolor);
            this.back.graphics.drawRect(0, 0, this.config["width"], this.config["height"]);
            this.back.graphics.endFill();
            addChild(this.back);
            this.masker = new Sprite();
            this.masker.graphics.clear();
            this.masker.graphics.beginFill(0);
            this.masker.graphics.drawRect(0, 0, this.config["width"], this.config["height"]);
            this.masker.graphics.endFill();
            this.parent.addChild(this.masker);
            this.mask = this.masker;
            this.view.addControllerListener(ControllerEvent.PLAYLIST, this.playlistHandler);
            this.view.addControllerListener(ControllerEvent.ITEM, this.itemHandler);
            this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
            this.view.addModelListener(ModelEvent.STATE, this.stateHandler);
            this.view.addViewListener(ViewEvent.STOP, this.stopHandler);
            stage.frameRate = this.config.framerate;
            if (this.config.controlbaricon == true && this.view.getPlugin("controlbar"))
            {
                this.controlIcon = new FlowBarIcon();
                this.view.getPlugin("controlbar").addButton(this.controlIcon, "flow", this.clickHandler);
            }
            if (this.config.buffericon == true)
            {
                this.bufferIcon = new BufferIcon();
                this.bufferIcon.visible = false;
            }
            return;
        }// end function

        private function clickHandler(event:Event = null) : void
        {
            if (!this.view.playlist[this.view.config["item"]]["ova.hidden"])
            {
                if (visible && this.coverFlow.alpha == 1)
                {
                    this.hide();
                }
                else if (this.back.alpha == 0)
                {
                    this.show();
                }
            }
            return;
        }// end function

        public function hide() : void
        {
            if (this.controlIcon)
            {
                this.controlIcon.alpha = 0.5;
            }
            if (this.showText == true)
            {
                new GTween(this.textField, 0.7, {alpha:0}, {ease:Linear.easeNone});
            }
            var _loc_1:* = new GTween(this.back, 0.7, {alpha:0}, {ease:Linear.easeNone, autoPlay:false, onComplete:this.hideTweenCall});
            var _loc_2:* = new GTween(this.coverFlow, 0.7, {alpha:0}, {ease:Linear.easeNone, nextTween:_loc_1});
            return;
        }// end function

        private function hideTweenCall(param1:GTween) : void
        {
            visible = false;
            stage.frameRate = 30;
            return;
        }// end function

        public function show() : void
        {
            visible = true;
            if (this.view.config["fullscreen"] && (this.config["position"] == "left" || this.config["position"] == "right" || this.config["position"] == "top" || this.config["position"] == "bottom"))
            {
                visible = false;
            }
            stage.frameRate = this.config.framerate;
            if (this.controlIcon)
            {
                this.controlIcon.alpha = 1;
            }
            new GTween(this.back, 0.7, {alpha:1}, {ease:Linear.easeNone, onComplete:this.showTweenCall});
            return;
        }// end function

        private function showTweenCall(param1:GTween) : void
        {
            if (this.showText == true)
            {
                new GTween(this.textField, 0.7, {alpha:1}, {ease:Linear.easeNone});
            }
            new GTween(this.coverFlow, 0.7, {alpha:1}, {ease:Linear.easeNone});
            return;
        }// end function

        private function coverFocus(param1:int) : void
        {
            var _loc_2:Object = null;
            if (this.showText == true)
            {
                _loc_2 = this.playlist[param1];
                this.textField.htmlText = "<div><h1>" + (_loc_2.title == undefined ? ("") : (_loc_2.title)) + "</h1>";
                this.textField.htmlText = this.textField.htmlText + ("<h2>" + (_loc_2.description == undefined ? ("") : (_loc_2.description)) + "</h2></div>");
            }
            return;
        }// end function

        private function coverClick(param1:int) : void
        {
            if (this.config.rotatedelay > 0 && this.timer)
            {
                this.timer.stop();
            }
            if (this.config.file == undefined)
            {
                if (this.indexMap[param1] != this.view.config["item"])
                {
                    this.view.sendEvent("ITEM", this.indexMap[param1]);
                }
                else if (this.view.config["state"] == ModelStates.PLAYING)
                {
                    this.view.sendEvent("PLAY", false);
                }
                else
                {
                    this.view.sendEvent("PLAY", true);
                }
            }
            else
            {
                if (this.playlist[param1].link)
                {
                    navigateToURL(new URLRequest(this.playlist[param1].link), this.view.config["linktarget"]);
                }
                if (this.playlist[param1].file)
                {
                    this.view.sendEvent("LOAD", {file:this.playlist[param1].file, image:this.playlist[param1].image});
                    this.view.sendEvent("PLAY", true);
                }
            }
            return;
        }// end function

        private function playlistHandler(event:ControllerEvent = null) : void
        {
            var _loc_2:int = 0;
            var _loc_3:Vector.<String> = null;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:URLLoader = null;
            if (this.coverFlow && contains(this.coverFlow))
            {
                removeChild(this.coverFlow);
            }
            if (this.textField && contains(this.textField))
            {
                removeChild(this.textField);
            }
            this.config.coverheight = this.config.coverheight == "auto" ? (this.config["height"] * 0.5) : (this.config.coverheight);
            if (this.config.file == undefined)
            {
                _loc_2 = this.view.playlist.length;
                _loc_3 = new Vector.<String>(_loc_5);
                this.playlist = new Vector.<Object>(_loc_5);
                this.indexMap = [];
                _loc_4 = 0;
                _loc_5 = 0;
                while (_loc_5 < _loc_2)
                {
                    
                    if (!this.view.playlist[_loc_5]["ova.hidden"])
                    {
                        _loc_3[_loc_4] = this.view.playlist[_loc_5]["image"] ? (this.view.playlist[_loc_5]["image"]) : (this.config.defaultcover);
                        this.playlist[_loc_4] = {title:this.view.playlist[_loc_5]["title"], description:this.view.playlist[_loc_5]["description"]};
                        this.indexMap[_loc_4] = _loc_5;
                        _loc_4++;
                    }
                    _loc_5++;
                }
                this.coverFlow = new CoverFlow(_loc_3, this.config.coverwidth, this.config.coverheight, this.config.covergap, this.config.coverangle, this.config.coverdepth, this.config.coveroffset, this.config.opacitydecrease, this.config.backgroundcolor, this.config.reflectionopacity, this.config.reflectionratio, this.config.reflectionoffset, this.config.tweentime, this.config.focallength, this.coverFocus, this.coverClick);
                addChild(this.coverFlow);
                this.afterCoverFlow();
            }
            else
            {
                _loc_6 = new URLLoader();
                _loc_6.addEventListener(Event.COMPLETE, this.relatedComplete);
                _loc_6.load(new URLRequest(this.config.file));
            }
            return;
        }// end function

        private function relatedComplete(event:Event) : void
        {
            var dat:XML;
            var fmt:String;
            var evt:* = event;
            try
            {
                dat = XML(evt.target.data);
                fmt = dat.localName().toLowerCase();
            }
            catch (err:Error)
            {
                view.sendEvent(ControllerEvent.ERROR, {message:"This playlist is not a valid XML file."});
                return;
            }
            switch(fmt)
            {
                case "rss":
                {
                    this.relatedHandler(RSSParser.parse(dat));
                    break;
                }
                case "playlist":
                {
                    this.relatedHandler(XSPFParser.parse(dat));
                    break;
                }
                case "asx":
                {
                    this.relatedHandler(ASXParser.parse(dat));
                    break;
                }
                case "smil":
                {
                    this.relatedHandler(SMILParser.parse(dat));
                    break;
                }
                case "feed":
                {
                    this.relatedHandler(ATOMParser.parse(dat));
                    break;
                }
                default:
                {
                    this.view.sendEvent(ControllerEvent.ERROR, {message:"Unknown playlist format: " + fmt});
                    return;
                    break;
                }
            }
            return;
        }// end function

        private function relatedHandler(param1:Array) : void
        {
            var _loc_4:int = 0;
            var _loc_2:* = param1.length;
            var _loc_3:* = new Vector.<String>(_loc_4);
            this.playlist = new Vector.<Object>(_loc_4);
            _loc_4 = 0;
            while (_loc_4 < _loc_2)
            {
                
                _loc_3[_loc_4] = param1[_loc_4].image ? (param1[_loc_4].image) : (this.config.defaultcover);
                this.playlist[_loc_4] = {title:param1[_loc_4].title, description:param1[_loc_4].description, link:param1[_loc_4].link, file:param1[_loc_4].file, image:_loc_3[_loc_4]};
                _loc_4++;
            }
            this.coverFlow = new CoverFlow(_loc_3, this.config.coverwidth, this.config.coverheight, this.config.covergap, this.config.coverangle, this.config.coverdepth, this.config.coveroffset, this.config.opacitydecrease, this.config.backgroundcolor, this.config.reflectionopacity, this.config.reflectionratio, this.config.reflectionoffset, this.config.tweentime, this.config.focallength, this.coverFocus, this.coverClick);
            addChild(this.coverFlow);
            this.afterCoverFlow();
            this.coverFlow.to(0);
            return;
        }// end function

        private function afterCoverFlow() : void
        {
            var _loc_1:StyleSheet = null;
            if (this.showText == true)
            {
                _loc_1 = new StyleSheet();
                _loc_1.parseCSS(this.config.textstyle);
                this.textField = new TextField();
                if (_loc_1.getStyle("div").fontFamily == "Arial Rounded MT Bold")
                {
                    this.textField.embedFonts = true;
                    this.textField.antiAliasType = AntiAliasType.ADVANCED;
                    Font.registerFont(EmbedArialRoundedMTBold);
                }
                this.textField.styleSheet = _loc_1;
                this.textField.selectable = false;
                this.textField.wordWrap = true;
                addChild(this.textField);
                this.textField.addEventListener(MouseEvent.MOUSE_UP, this.disableFocus);
            }
            if (this.config.buffericon == true && this.bufferIcon)
            {
                this.coverFlow.addChild(this.bufferIcon);
            }
            this.resizeHandler();
            this.itemHandler();
            if (this.config.onidle == "hide")
            {
                visible = false;
                this.textField.alpha = 0;
                this.coverFlow.alpha = 0;
                this.back.alpha = 0;
                stage.frameRate = 30;
            }
            if (this.config.rotatedelay > 0)
            {
                this.timer = new Timer(this.config.rotatedelay);
                this.timer.start();
                this.timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
                addEventListener(MouseEvent.CLICK, this.stopTimer, false, 0, true);
            }
            return;
        }// end function

        private function disableFocus(event:MouseEvent = null) : void
        {
            stage.focus = null;
            return;
        }// end function

        private function stopTimer(event:MouseEvent = null) : void
        {
            this.timer.stop();
            return;
        }// end function

        private function timerHandler(event:TimerEvent = null) : void
        {
            this.coverFlow.next();
            return;
        }// end function

        private function itemHandler(event:ControllerEvent = null) : void
        {
            if (this.view.playlist[this.view.config["item"]]["ova.hidden"])
            {
                this.hide();
            }
            else if (this.config.file == undefined)
            {
                this.coverFlow.to(this.indexMap.indexOf(this.view.config["item"]));
            }
            return;
        }// end function

        public function left() : void
        {
            this.coverFlow.left();
            return;
        }// end function

        public function right() : void
        {
            this.coverFlow.right();
            return;
        }// end function

        public function next() : void
        {
            this.coverFlow.next();
            return;
        }// end function

        public function to(param1:int) : void
        {
            this.coverFlow.to(param1);
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent = null) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            visible = this.config["visible"];
            if (this.coverFlow && this.coverFlow.alpha == 0)
            {
                visible = false;
            }
            if (this.config["visible"] == true)
            {
                _loc_2 = this.config["width"];
                _loc_3 = this.config["height"];
                x = this.config["x"];
                y = this.config["y"];
                if (mask)
                {
                    mask.width = _loc_2;
                    mask.height = _loc_3;
                    mask.x = x;
                    mask.y = y;
                }
                if (this.back)
                {
                    this.back.width = _loc_2;
                    this.back.height = _loc_3;
                }
                if (this.coverFlow)
                {
                    this.coverFlow.x = _loc_2 * 0.5 + this.config.xposition;
                    this.coverFlow.y = _loc_3 * 0.5 + this.config.yposition;
                }
                if (this.textField)
                {
                    this.textField.width = _loc_2;
                    this.textField.y = this.coverFlow.y + this.config.coverheight * 0.5 + this.config.textoffset + 5;
                }
            }
            return;
        }// end function

        private function stopHandler(event:ViewEvent = null) : void
        {
            if (this.config.onidle == "show" && visible == false)
            {
                this.show();
            }
            else if (this.config.onidle == "hide")
            {
                this.hide();
            }
            return;
        }// end function

        private function stateHandler(event:ModelEvent) : void
        {
            switch(event.data.newstate)
            {
                case ModelStates.PAUSED:
                {
                    if (this.bufferIcon)
                    {
                        this.bufferIcon.visible = false;
                    }
                    if (this.config.onpaused == "show" && visible == false)
                    {
                        this.show();
                    }
                    else if (this.config.onpaused == "hide")
                    {
                        this.hide();
                    }
                    break;
                }
                case ModelStates.COMPLETED:
                {
                    if (this.bufferIcon)
                    {
                        this.bufferIcon.visible = false;
                    }
                    if (this.config.oncompleted == "show" && visible == false)
                    {
                        this.show();
                    }
                    else if (this.config.oncompleted == "hide")
                    {
                        this.hide();
                    }
                    break;
                }
                case ModelStates.PLAYING:
                {
                    if (this.bufferIcon)
                    {
                        this.bufferIcon.visible = false;
                    }
                    if (this.config.onplaying == "show" && visible == false)
                    {
                        this.show();
                    }
                    else if (this.config.onplaying == "hide")
                    {
                        this.hide();
                    }
                    break;
                }
                case ModelStates.BUFFERING:
                {
                    if (this.bufferIcon)
                    {
                        this.bufferIcon.visible = true;
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}
