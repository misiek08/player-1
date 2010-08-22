package com.jeroenwijering.parsers
{
    import com.jeroenwijering.utils.*;

    public class ASXParser extends Object
    {

        public function ASXParser()
        {
            return;
        }// end function

        public static function parse(param1:XML) : Array
        {
            var _loc_3:XML = null;
            var _loc_2:* = new Array();
            for each (_loc_3 in param1.children())
            {
                
                if (_loc_3.localName() == "entry")
                {
                    _loc_2.push(ASXParser.parseItem(_loc_3));
                }
            }
            return _loc_2;
        }// end function

        public static function parseItem(param1:XML) : Object
        {
            var _loc_3:XML = null;
            var _loc_2:* = new Object();
            for each (_loc_3 in param1.children())
            {
                
                if (!_loc_3.localName())
                {
                    break;
                }
                switch(_loc_3.localName().toLowerCase())
                {
                    case "ref":
                    {
                        _loc_2["file"] = _loc_3.@href.toString();
                        break;
                    }
                    case "title":
                    {
                        _loc_2["title"] = _loc_3.text().toString();
                        break;
                    }
                    case "moreinfo":
                    {
                        _loc_2["link"] = _loc_3.@href.toString();
                        break;
                    }
                    case "abstract":
                    {
                        _loc_2["description"] = _loc_3.text().toString();
                        break;
                    }
                    case "author":
                    {
                        _loc_2["author"] = _loc_3.text().toString();
                        break;
                    }
                    case "duration":
                    {
                        _loc_2["duration"] = Strings.seconds(_loc_3.@value.toString());
                        break;
                    }
                    case "starttime":
                    {
                        _loc_2["start"] = Strings.seconds(_loc_3.@value.toString());
                        break;
                    }
                    case "param":
                    {
                        _loc_2[_loc_3.@name] = _loc_3.@value.toString();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            _loc_2 = JWParser.parseEntry(param1, _loc_2);
            return _loc_2;
        }// end function

    }
}
