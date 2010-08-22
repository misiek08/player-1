package com.gskinner.motion
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class GTween extends Object
    {
        protected var _delay:Number = 0;
        protected var _values:Object;
        protected var _paused:Boolean = true;
        protected var _position:Number = 0;
        protected var _inited:Boolean;
        protected var _initValues:Object;
        protected var _rangeValues:Object;
        protected var _referenceTime:Number;
        public var autoPlay:Boolean = true;
        public var data:Object;
        public var duration:Number;
        public var ease:Function;
        public var nextTween:GTween;
        public var reflect:Boolean;
        public var repeatCount:int = 1;
        public var target:Object;
        public var positionOld:Number;
        public var ratio:Number;
        public var ratioOld:Number;
        public var calculatedPosition:Number;
        public var calculatedPositionOld:Number;
        public var suppressEvents:Boolean;
        public var onComplete:Function;
        public static var pauseAll:Boolean = false;
        public static var defaultEase:Function = expoEaseOut;
        public static var shape:Shape;
		public static var time:Number;
		public static var tickList:Dictionary = new Dictionary(true);
		public static var gcLockList:Dictionary = new Dictionary(false);

        public function GTween(param1:Object = null, param2:Number = 1, param3:Object = null, param4:Object = null)
        {
            var _loc_5:Boolean = false;
            this.ease = defaultEase;
            this.target = param1;
            this.duration = param2;
            if (param4)
            {
                _loc_5 = param4.swapValues;
                delete param4.swapValues;
            }
            this.copy(param4, this);
            this.resetValues(param3);
            if (this.duration == 0 && this.delay == 0 && this.autoPlay)
            {
                this.position = 0;
            }
            return;
        }// end function

        public function get paused() : Boolean
        {
            return this._paused;
        }// end function

        public function set paused(param1:Boolean) : void
        {
            if (param1 == this._paused)
            {
                return;
            }
            this._paused = param1;
            if (this._paused)
            {
                delete tickList[this];
                this.setGCLock(false);
            }
            else
            {
                if (this.repeatCount != 0 && this._position >= this.repeatCount * this.duration)
                {
                    this._inited = false;
                    this._position = -this.delay;
                }
                tickList[this] = true;
                this.setGCLock(true);
            }
            return;
        }// end function

        public function get position() : Number
        {
            return this._position;
        }// end function

        public function set position(param1:Number) : void
        {
            var _loc_4:String = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            this.positionOld = this._position;
            this.ratioOld = this.ratio;
            this.calculatedPositionOld = this.calculatedPosition;
            var _loc_2:* = this.repeatCount * this.duration;
            var _loc_3:* = param1 >= _loc_2 && this.repeatCount > 0;
            if (_loc_3)
            {
                if (this.calculatedPositionOld == _loc_2)
                {
                    return;
                }
                this._position = _loc_2;
                this.calculatedPosition = this.reflect && !(this.repeatCount & 1) ? (0) : (this.duration);
            }
            else
            {
                this._position = param1 < -this._delay ? (-this._delay) : (param1);
                this.calculatedPosition = this._position < 0 ? (0) : (this._position % this.duration);
                if (this.reflect && this._position / this.duration & 1)
                {
                    this.calculatedPosition = this.duration - this.calculatedPosition;
                }
            }
            this.ratio = this.duration == 0 && this._position >= 0 ? (1) : (this.ease(this.calculatedPosition / this.duration, 0, 1, 1));
            if (this.target && (this._position >= 0 || this.positionOld >= 0) && this._position != this.positionOld)
            {
                if (!this._inited)
                {
                    this.init();
                }
                for (_loc_4 in this._values)
                {
                    
                    _loc_5 = this._initValues[_loc_4];
                    _loc_6 = this._rangeValues[_loc_4];
                    _loc_7 = _loc_5 + _loc_6 * this.ratio;
                    this.target[_loc_4] = _loc_7;
                }
            }
            if (_loc_3)
            {
                this.paused = true;
                if (this.nextTween)
                {
                    this.nextTween.paused = false;
                }
                if (this.onComplete != null && !this.suppressEvents)
                {
                    this.onComplete(this);
                }
            }
            return;
        }// end function

        public function get delay() : Number
        {
            return this._delay;
        }// end function

        public function set delay(param1:Number) : void
        {
            if (this._position <= 0)
            {
                this._position = -param1;
            }
            this._delay = param1;
            return;
        }// end function

        public function setValue(param1:String, param2:Number) : void
        {
            this._values[param1] = param2;
            this.invalidate();
            return;
        }// end function

        public function getValue(param1:String) : Number
        {
            return this._values[param1];
        }// end function

        public function deleteValue(param1:String) : Boolean
        {
            delete this._rangeValues[param1];
            delete this._initValues[param1];
            return delete this._values[param1];
        }// end function

        public function setValues(param1:Object) : void
        {
            var _loc_2:String = null;
            for (_loc_2 in param1)
            {
                
                this._values[_loc_2] = param1[_loc_2];
            }
            this._inited = false;
            if (this._position > 0)
            {
                this._position = 0;
            }
            if (this.autoPlay)
            {
                this.paused = false;
            }
            return;
        }// end function

        public function resetValues(param1:Object = null) : void
        {
            this._values = {};
            this.setValues(param1);
            return;
        }// end function

        public function getValues() : Object
        {
            return this.copy(this._values, {});
        }// end function

        public function getInitValue(param1:String) : Number
        {
            return this._initValues[param1];
        }// end function

        public function init() : void
        {
            var _loc_1:String = null;
            this._inited = true;
            this._initValues = {};
            this._rangeValues = {};
            for (_loc_1 in this._values)
            {
                
                var _loc_4:* = this.target[_loc_1];
                this._initValues[_loc_1] = this.target[_loc_1];
                this._rangeValues[_loc_1] = this._values[_loc_1] - _loc_4;
            }
            return;
        }// end function

        public function beginning() : void
        {
            this.position = 0;
            this.paused = true;
            return;
        }// end function

        public function end() : void
        {
            this.position = this.repeatCount > 0 ? (this.repeatCount * this.duration) : (this.duration);
            return;
        }// end function

        protected function invalidate() : void
        {
            this._inited = false;
            if (this._position > 0)
            {
                this._position = 0;
            }
            if (this.autoPlay)
            {
                this.paused = false;
            }
            return;
        }// end function

        protected function setGCLock(param1:Boolean) : void
        {
            if (param1)
            {
                if (this.target is IEventDispatcher)
                {
                    this.target.addEventListener("_", this.setGCLock);
                }
                else
                {
                    gcLockList[this] = true;
                }
            }
            else
            {
                if (this.target is IEventDispatcher)
                {
                    this.target.removeEventListener("_", this.setGCLock);
                }
                delete gcLockList[this];
            }
            return;
        }// end function

        protected function copy(param1:Object, param2:Object, param3:Boolean = false) : Object
        {
            var _loc_4:String = null;
            for (_loc_4 in param1)
            {
                
                if (param3 && param1[_loc_4] == null)
                {
                    delete param2[_loc_4];
                    continue;
                }
                param2[_loc_4] = param1[_loc_4];
            }
            return param2;
        }// end function

        public static function linearEase(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return param1;
        }// end function

        public static function expoEaseOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return param1 == 1 ? (1) : (1 - Math.pow(2, -10 * param1));
        }// end function

		public static function staticInit() : void
        {
            var _loc_1:* = new Shape();
            shape = new Shape();
            _loc_1.addEventListener(Event.ENTER_FRAME, staticTick);
            time = getTimer() * 0.001;
            return;
        }// end function

		public static function staticTick(event:Event) : void
        {
            var _loc_4:Object = null;
            var _loc_5:GTween = null;
            var _loc_2:* = time;
            time = getTimer() * 0.001;
            if (pauseAll)
            {
                return;
            }
            var _loc_3:* = time - _loc_2;
            for (_loc_4 in tickList)
            {
                
                _loc_5 = _loc_4 as GTween;
                (_loc_4 as GTween).position = _loc_5._position + _loc_3;
            }
            return;
        }// end function

        staticInit();
    }
}
