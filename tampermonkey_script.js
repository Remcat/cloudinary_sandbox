// ==UserScript==
// @name         Cloudinary-ify
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Make images Cloudinary-ified
// @author       You
// @match        https://www.picturesof.net/
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // This fetches all of the <img> tags and stores them in "tags".
    var tags = document.getElementsByTagName('img');

    // This loops over all of the <img> tags.
    for (var i = 0; i < tags.length; i++) {

        // This replaces the src attribute of the tag with the modified one
        tags[i].src = "https://res.cloudinary.com/rabdelazim/image/fetch/" + tags[i].src;
    }
})();
