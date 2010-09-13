package com.jeroenwijering.parsers
{
    import com.jeroenwijering.utils.*;

    public class XSPFParser extends Object
    {

        public function XSPFParser()
        {
            return;
        }// end function

        public static function parse(param1:XML) : Array
        {
            var _loc_3:XML = null;
            var _loc_4:XML = null;
            var _loc_2:* = new Array();
            for each (_loc_3 in param1.children())
            {
                
                if (_loc_3.localName().toLowerCase() == "tracklist")
                {
                    for each (_loc_4 in _loc_3.children())
                    {
                        
                        _loc_2.push(XSPFParser.parseItem(_loc_4));
                    }
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
                    case "location":
                    {
                        _loc_2["file"] = _loc_3.text().toString();
                        break;
                    }
                    case "title":
                    {
                        _loc_2["title"] = _loc_3.text().toString();
                        break;
                    }
                    case "annotation":
                    {
                        _loc_2["description"] = _loc_3.text().toString();
                        break;
                    }
                    case "info":
                    {
                        _loc_2["link"] = _loc_3.text().toString();
                        break;
                    }
                    case "image":
                    {
                        _loc_2["image"] = _loc_3.text().toString();
                        break;
                    }
                    case "creator":
                    {
                        _loc_2["author"] = _loc_3.text().toString();
                        break;
                    }
                    case "duration":
                    {
                        _loc_2["duration"] = Strings.seconds(_loc_3.text());
                        break;
                    }
                    case "meta":
                    {
                        _loc_2[_loc_3.@rel] = _loc_3.text().toString();
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
