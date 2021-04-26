// replaces the ' " & < > and C0 C1 control characters with their html entity
// for control characters the entity is based on the classic IBM Code Page 435

// https://en.wikipedia.org/wiki/Code_page_437#Character_set
// https://en.wikipedia.org/wiki/C0_and_C1_control_codes

function html_escape(str) {
    return str.replace(/['"&<>\x00-\x1F\x7F-\x9F]/g, function(c) {
        switch(c) {
            case "'": return'&#x27;';
            case '"': return'&quot;';
            case '&': return'&amp;';
            case '<': return'&lt;';
            case '>': return'&gt;';
            // c0
            case '\x00': return'&#x2400;';
            case '\x01': return'&#x263A;';
            case '\x02': return'&#x263B;';
            case '\x03': return'&#x2665;';
            case '\x04': return'&#x2666;';
            case '\x05': return'&#x2663;';
            case '\x06': return'&#x2660;';
            case '\x07': return'&#x2022;';
            case '\x08': return'&#x25D8;';
            case '\x09': return'&#x25CB;';
            case '\x0A': return'&#x25D9;';
            case '\x0B': return'&#x2642;';
            case '\x0C': return'&#x2640;';
            case '\x0D': return'&#x266A;';
            case '\x0E': return'&#x266B;';
            case '\x0F': return'&#x263C;';
            case '\x10': return'&#x25BA;';
            case '\x11': return'&#x25C4;';
            case '\x12': return'&#x2195;';
            case '\x13': return'&#x203C;';
            case '\x14': return'&#xB6;';
            case '\x15': return'&#xA7;';
            case '\x16': return'&#x25AC;';
            case '\x17': return'&#x21A8;';
            case '\x18': return'&#x2191;';
            case '\x19': return'&#x2193;';
            case '\x1A': return'&#x2192;';
            case '\x1B': return'&#x2190;';
            case '\x1C': return'&#x221F;';
            case '\x1D': return'&#x2194;';
            case '\x1E': return'&#x25B2;';
            case '\x1F': return'&#x25BC;';
            // c1
            case '\x7F': return'&#x2302;';
            case '\x80': return'&#xC7;';
            case '\x81': return'&#xFC;';
            case '\x82': return'&#xE9;';
            case '\x83': return'&#xE2;';
            case '\x84': return'&#xE4;';
            case '\x85': return'&#xE0;';
            case '\x86': return'&#xE5;';
            case '\x87': return'&#xE7;';
            case '\x88': return'&#xEA;';
            case '\x89': return'&#xEB;';
            case '\x8A': return'&#xE0;';
            case '\x8B': return'&#xEF;';
            case '\x8C': return'&#xEE;';
            case '\x8D': return'&#xEC;';
            case '\x8E': return'&#xC4;';
            case '\x8F': return'&#xC5;';
            case '\x90': return'&#xC9;';
            case '\x91': return'&#xE6;';
            case '\x92': return'&#xC6;';
            case '\x93': return'&#xF4;';
            case '\x94': return'&#xF6;';
            case '\x95': return'&#xF2;';
            case '\x96': return'&#xFB;';
            case '\x97': return'&#xF9;';
            case '\x98': return'&#xFF;';
            case '\x99': return'&#xD6;';
            case '\x9A': return'&#xDC;';
            case '\x9B': return'&#xA2;';
            case '\x9C': return'&#xA3;';
            case '\x9D': return'&#xA5;';
            case '\x9E': return'&#x20A7;';
            case '\x9F': return'&#x192;';
        }
    });
}

