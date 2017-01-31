# knoxcarey.com

This is a repo for my personal homepage. I'll describe some of the
techniques I used to make the site below.

## Banner image

The banner image is actually a small, 64x64 image, embeded as
base64-encoded data in the `<img>` element. When the image is finished
loading, it calls the Javascript function `imageToText()`, which draws
the image into an offscreen canvas, extracts its pixel values, and
then iterates over the pixels, drawing each one as a text character
with the pixel's color.

The code for `imageToText()` is minified in the `<head>`, but here is
the code I started with:

```javascript
function getPixels(image) {
    var offscreen = document.createElement('canvas');
    var offscreenCtx = offscreen.getContext('2d');
    offscreen.width = image.width;
    offscreen.height = image.height;
    offscreenCtx.drawImage(image, 0, 0);
    return offscreenCtx.getImageData(0, 0, image.width, image.height).data;
}

function renderAsText(pixels, canvas, font, text, width, height, dx, dy) {
    var ctx = canvas.getContext('2d');
    ctx.font = font;
    var w = canvas.width = width*dx;
    canvas.height = height*dy;

    for (var i = 0, x = 0, y = 0; i < pixels.length; x += dx) {
     	if (x >= w) {y += dy; x = 0;}
	ctx.fillStyle = ["rgba(", pixels[i++], ",", pixels[i++], ",",
		         pixels[i++], ",", pixels[i++], ")"].join('');
     	ctx.fillText(text, x, y);
     }
}

function imageToText(image, canvas, font, text, dx, dy) {
    renderAsText(getPixels(image), canvas, font, text,
    		 image.width, image.height, dx, dy);
}
```

## Contact info

I didn't want to put my email address in the page in the clear, so I
obfuscated it with a Caesar cipher. The follow code (which, again, is
in a minified form in the `<head>`) displays my email address:

```javascript
function contact() {
  var contactstr = cc("`cdm5`cdmXVgZn#Xdb", 11) 
  return contactstr;
}

function cc(s, off) {
  var rot = "";
  for(var i=0; i < s.length; i++) {
    rot += String.fromCharCode((s.charCodeAt(i) + off));
  }
  return rot;
}
```