package com.jeroenwijering.parsers
{

    public class ATOMParser extends Object
    {

        public function ATOMParser()
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
                    _loc_2.push(ATOMParser.parseItem(_loc_3));
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
                
                switch(_loc_3.localName().toLowerCase())
                {
                    case "author":
                    {
                        _loc_2["author"] = _loc_3.children()[0].text().toString();
                        break;
                    }
                    case "title":
                    {
                        _loc_2["title"] = _loc_3.text().toString();
                        break;
                    }
                    case "summary":
                    {
                        _loc_2["description"] = _loc_3.text().toString();
                        break;
                    }
                    case "link":
                    {
                        if (_loc_3.@rel == "alternate")
                        {
                            _loc_2["link"] = _loc_3.@href.toString();
                        }
                        else if (_loc_3.@rel == "enclosure")
                        {
                            _loc_2["file"] = _loc_3.@href.toString();
                        }
                        break;
                    }
                    case "published":
                    {
                        _loc_2["date"] = _loc_3.text().toString();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            _loc_2 = MediaParser.parseGroup(param1, _loc_2);
            _loc_2 = JWParser.parseEntry(param1, _loc_2);
            return _loc_2;
        }// end function

    }
}
