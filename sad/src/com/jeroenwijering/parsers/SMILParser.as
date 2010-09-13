package com.jeroenwijering.parsers
{
    import com.jeroenwijering.utils.*;

    public class SMILParser extends Object
    {

        public function SMILParser()
        {
            return;
        }// end function

        public static function parse(param1:XML) : Array
        {
            var _loc_4:XML = null;
            var _loc_2:* = new Array();
            var _loc_3:* = param1.children()[1].children()[0];
            if (_loc_3.localName().toLowerCase() == "seq")
            {
                for each (_loc_4 in _loc_3.children())
                {
                    
                    _loc_2.push(SMILParser.parseSeq(_loc_4));
                }
            }
            else
            {
                _loc_2.push(SMILParser.parsePar(_loc_3));
            }
            return _loc_2;
        }// end function

        public static function parseSeq(param1:XML) : Object
        {
            var _loc_2:* = new Object();
            switch(param1.localName().toLowerCase())
            {
                case "par":
                {
                    _loc_2 = SMILParser.parsePar(param1);
                    break;
                }
                case "img":
                case "video":
                case "audio":
                {
                    _loc_2 = SMILParser.parseAttributes(param1, _loc_2);
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            return _loc_2;
        }// end function

        public static function parsePar(param1:XML) : Object
        {
            var _loc_3:XML = null;
            var _loc_2:* = new Object();
            for each (_loc_3 in param1.children())
            {
                
                switch(_loc_3.localName().toLowerCase())
                {
                    case "anchor":
                    {
                        _loc_2["link"] = _loc_3.@href.toString();
                        break;
                    }
                    case "img":
                    {
                        if (_loc_2["file"])
                        {
                            _loc_2["image"] = _loc_3.@src.toString();
                            break;
                        }
                        else
                        {
                            _loc_2 = SMILParser.parseAttributes(_loc_3, _loc_2);
                        }
                        break;
                    }
                    case "video":
                    case "audio":
                    {
                        _loc_2 = SMILParser.parseAttributes(_loc_3, _loc_2);
                        break;
                    }
                    default:
                    {
                        break;
                        break;
                    }
                }
            }
            _loc_2 = JWParser.parseEntry(param1, _loc_2);
            return _loc_2;
        }// end function

        public static function parseAttributes(param1:Object, param2:Object) : Object
        {
            var _loc_4:String = null;
            var _loc_3:Number = 0;
            while (_loc_3 < param1.attributes().length())
            {
                
                _loc_4 = param1.attributes()[_loc_3].name().toString();
                switch(_loc_4)
                {
                    case "begin":
                    {
                        param2["start"] = Strings.seconds(param1.@begin.toString());
                        break;
                    }
                    case "src":
                    {
                        param2["file"] = param1.@src.toString();
                        break;
                    }
                    case "dur":
                    {
                        param2["duration"] = Strings.seconds(param1.@dur.toString());
                        break;
                    }
                    case "alt":
                    {
                        param2["description"] = param1.@alt.toString();
                        break;
                    }
                    default:
                    {
                        param2[_loc_4] = param1.attributes()[_loc_3].toString();
                        break;
                        break;
                    }
                }
                _loc_3 = _loc_3 + 1;
            }
            return param2;
        }// end function

    }
}
