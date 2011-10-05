# Overscore

Non-blocking underscore.js functions. This library lets you run javascript-intensive functions in the background, without locking up the browser, or making the dom update slowly. It uses setInterval under the hood to ensure that the javascript runtime never uses more than 75% of the browsers CPU time.

## Problem

I encountered this problem when writing the [Rankers App](http://itunes.apple.com/nz/app/rankers-app/id454894632?mt=8). I wrote my own geo-marker cluster that used underscore.js. The only problem is that the clusterer iterates over 3000 points, and doing this in one block of code made the map freeze up, so you'd be panning around, and then the map would freeze while I calculated the new points. This made the UI seem really sucky, so I created Overscore.

## Solution

Instead of iterating over the entire input array in one loop, use a regular `100ms` interval that iterates over a chunk of the array, then yields when it has used more than 75ms of browser time. From my own testing, this seems to allow the browser to stay responsive.

## API

I've gone for a chaining api. The only substantial difference from the underscore.js api is the `then` method. This is used for your final logic step. So for example:

    new Overscore(inputs).select(
      function(i){ return i.match(/beach/) }
    ).then(
      function(outputs){ console.log("found " + outputs.length + " beaches")}
    );
    
This, the very first release, contains only `map` and `select`.

## Future

 * Maybe add webworker support?
 * Less duplication of input and output arrays for more speed
 * Tests