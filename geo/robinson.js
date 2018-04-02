// Coefficients of a quartic polynomial that converts latitude to the
// length of the parallel at that latitude. These are interpolated
// from Robinson's original table. (See link below).
const l2w = [7.83346998046090e-09, -1.34341109302735e-06, 5.02672267158769e-06, -5.22182883485412e-04, 1.00070746827543e+00];

// Coefficients of a quartic polynomial that converts latitude to the
// distance of the parallel at that latitude from the equator.
const l2h = [-4.18845882434522e-09, 4.72679820142469e-07, -1.83886091361865e-05, 6.53655003052467e-03, -5.75140420220607e-04];

// Dimensions of the map image
const mapHeight = 520;
const mapWidth  = 1024;

// Horner's rule for polynomial evaluation
function polyval(p, x) {
  return p.reduce((a, c) => {return c + a*x;}, 0.0);
}

// Compute the length of the parallel at the given latitude.
function parallelWidth(l) {
    return polyval(l2w, Math.abs(l));
}

// Compute the distance of a parallel from the equator.
function parallelHeight(l) {
    return polyval(l2h, Math.abs(l));
}

// Compute x coordinate of location @ (lat, lon) given
// width w and height h of the map image.
function x(lat, lon, w, h) {
    return w/2 * (1 + parallelWidth(lat)*lon/180);
}

// Compute y coordinate of location @ (lat, lon) given
// width w and height h of the map image.
function y(lat, lon, w, h) {
    return h/2 * (1 - Math.sign(lat) * 1.9716 * parallelHeight(lat));
}

function showLocations(ctx) {
    return function() {
	locations = JSON.parse(this.responseText);
	for (p in locations) {
	    if (locations[p].loc) {
		coords = locations[p].loc.split(',');
		lat = coords[0];
		lon = coords[1];
		xp = x(lat, lon, mapWidth, mapHeight);
		yp = y(lat, lon, mapWidth, mapHeight);
		
		ctx.fillStyle = "#FF1C0A";
		ctx.beginPath();
		ctx.arc(xp, yp, 5, 0, Math.PI*2, true); 
		ctx.closePath();
		ctx.fill();
	    }
	}
    };
}

function draw(e) {
    canvas = document.getElementById("canvas");
    ctx = canvas.getContext("2d");

    canvas.width = mapWidth;
    canvas.height = mapHeight;

    background = document.getElementById("map");

    ctx.drawImage(background, 0, 0, mapWidth, mapHeight);

    var req = new XMLHttpRequest();
    req.addEventListener("load", showLocations(ctx));
    req.open("GET", "sshban");
    req.send();
}
