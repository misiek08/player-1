package com.jeroenwijering.parsers
{

    public class RSSParser extends Object
    {

        public function RSSParser()
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
                
                if (_loc_3.localName() == "channel")
                {
                    for each (_loc_4 in _loc_3.children())
                    {
                        
                        if (_loc_4.name() == "item")
                        {
                            _loc_2.push(RSSParser.parseItem(_loc_4));
                        }
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
                
                switch(_loc_3.localName().toLowerCase())
                {
                    case "enclosure":
                    {
                        _loc_2["file"] = _loc_3.@url.toString();
                        break;
                    }
                    case "title":
                    {
                        _loc_2["title"] = _loc_3.text().toString();
                        break;
                    }
                    case "pubDate":
                    {
                        _loc_2["date"] = _loc_3.text().toString();
                        break;
                    }
                    case "description":
                    {
                        _loc_2["description"] = _loc_3.text().toString();
                        break;
                    }
                    case "link":
                    {
                        _loc_2["link"] = _loc_3.text().toString();
                        break;
                    }
                    case "category":
                    {
                        if (_loc_2["tags"])
                        {
                            _loc_2["tags"] = _loc_2["tags"] + _loc_3.text().toString();
                        }
                        else
                        {
                            _loc_2["tags"] = _loc_3.text().toString();
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            _loc_2 = ItunesParser.parseEntry(param1, _loc_2);
            _loc_2 = MediaParser.parseGroup(param1, _loc_2);
            _loc_2 = JWParser.parseEntry(param1, _loc_2);
            return _loc_2;
        }// end function

    }
}
