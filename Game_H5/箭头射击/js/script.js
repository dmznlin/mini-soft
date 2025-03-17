"use strict"
		var stage = {
			w:1280,
			h:720
		}

		var _pexcanvas = document.getElementById("canvas");
		_pexcanvas.width = stage.w;
		_pexcanvas.height = stage.h;
		var ctx = _pexcanvas.getContext("2d");




		var pointer = {
			x:0,
			y:0
		}

		var scale = 1;
		var portrait = true;
		var loffset = 0;
		var toffset = 0;
		var mxpos = 0;
		var mypos = 0;


// ------------------------------------------------------------------------------- Gamy
function drawArrow(fromx, fromy, tox, toy,lw,hlen,color) {
	var dx = tox - fromx;
	var dy = toy - fromy;
	var angle = Math.atan2(dy, dx);
	ctx.fillStyle=color;
	ctx.strokeStyle=color;
	ctx.lineCap = "round";
	ctx.lineWidth = lw;
	ctx.beginPath();
	ctx.moveTo(fromx, fromy);
	ctx.lineTo(tox, toy);
	ctx.stroke();
	ctx.beginPath();
	ctx.moveTo(tox, toy);
	ctx.lineTo(tox - hlen * Math.cos(angle - Math.PI / 6), toy - hlen * Math.sin(angle - Math.PI / 6));
	ctx.lineTo(tox - hlen * Math.cos(angle)/2, toy - hlen * Math.sin(angle)/2);
	ctx.lineTo(tox - hlen * Math.cos(angle + Math.PI / 6), toy - hlen * Math.sin(angle + Math.PI / 6));
	ctx.closePath();
	ctx.stroke();
	ctx.fill();
}




var colors = ['#1abc9c','#1abc9c','#3498db','#9b59b6','#34495e','#16a085','#27ae60','#2980b9','#8e44ad','#2c3e50','#f1c40f','#e67e22','#e74c3c','#95a5a6','#f39c12','#d35400','#c0392b','#bdc3c7','#7f8c8d'];


ctx.clearRect(0,0,stage.w,stage.h);
for (var i =0;i<200;i++) {
	var angle = Math.random()*Math.PI*2;
	var length = Math.random()*250+50;
	var myx=360+Math.sin(angle)*length;
	var myy=360-Math.cos(angle)*length;
	drawArrow(myx,myy,myx+length/6*Math.sin(angle),myy-length/6*Math.cos(angle),length/30,length/30,'#c0392b');
}
var explode = new Image();
explode.src = canvas.toDataURL("image/png");

ctx.clearRect(0,0,stage.w,stage.h);
for (var i =0;i<200;i++) {
	var angle = Math.random()*Math.PI-Math.PI/2;
	var length = Math.random()*480+50;
	var myx=stage.w/2+Math.sin(angle)*length;
	var myy=stage.h-Math.cos(angle)*length;
	drawArrow(myx,myy,myx+length/6*Math.sin(angle),myy-length/6*Math.cos(angle),length/30,length/30,'#2c3e50');
}
var explodeb = new Image();
explodeb.src = canvas.toDataURL("image/png");


ctx.clearRect(0,0,stage.w,stage.h);
ctx.fillStyle = "rgba(236,240,241,1)";
ctx.fillRect(0,0,stage.w,stage.h);
for (var i =0;i<200;i++) {
	var angle = Math.random()*Math.PI/Math.PI*180;
	var length = Math.random()*250+50;
	var myx=Math.random()*stage.w;
	var myy=Math.random()*stage.h;
	drawArrow(myx,myy,myx+length/6*Math.sin(angle),myy-length/6*Math.cos(angle),length/30,length/30,colors[Math.floor(Math.random()*colors.length)]);
}

ctx.fillStyle = "rgba(236,240,241,0.9)";
ctx.fillRect(0,0,stage.w,stage.h);
var back = new Image();
back.src = canvas.toDataURL("image/png");

var angle=0;
var ai = true;
var ait = 0;
var btm=0;
var bullets = [];

function Bullet() {
	this.x=stage.w/2-Math.sin(angle)*150;
	this.y=stage.h-Math.cos(angle)*150;
	this.r=angle;
}

var enemies = [];
function Enemy() {
	this.r = Math.random()*Math.PI/(2.5/2)-Math.PI/2.5;
	this.dis = Math.random()*1280+720;
	this.x=stage.w/2-Math.sin(this.r)*this.dis;
	this.y=stage.h-Math.cos(this.r)*this.dis;
}
for(var i=0;i<10;i++) {
	enemies.push(new Enemy());
  
	enemies[i].x += Math.sin(enemies[i].r)*300;
	enemies[i].y += Math.cos(enemies[i].r)*300;
}



var explosions = [];
function Explosion(x,y,ty) {
	this.x=x;
	this.y=y;
	this.t=30;
	this.ty=ty;
}

var eturn = 0;
var cold = [];
function enginestep() {

	ctx.drawImage(back,0,0);
	if (!ai&&ait<Date.now()-3000) {
		ai = true;
	}
	btm++;
	if(btm>8){
		btm=0;
		bullets.push(new Bullet());
	}
	
	for (var i=0;i<bullets.length;i++) {
		bullets[i].x -= Math.sin(bullets[i].r)*20;
		bullets[i].y -= Math.cos(bullets[i].r)*20;
		drawArrow(bullets[i].x+Math.sin(bullets[i].r)*50,bullets[i].y+Math.cos(bullets[i].r)*50,bullets[i].x,bullets[i].y,8,8,'#2980b9');
		if(bullets[i].x<-100||bullets[i].x>stage.w+100){
			bullets.splice(i,1);
		}
		if(bullets[i].y<-100||bullets[i].y>stage.h+100){
			bullets.splice(i,1);
		}
		
	}
	
	
	for(var i=0;i<enemies.length;i++) {
		enemies[i].x += Math.sin(enemies[i].r)*3;
		enemies[i].y += Math.cos(enemies[i].r)*3;
		drawArrow(enemies[i].x-Math.sin(enemies[i].r)*100,enemies[i].y-Math.cos(enemies[i].r)*100,enemies[i].x,enemies[i].y,15,15,"#c0392b");
		if (enemies[i].y>stage.h) {
			enemies[i] = new Enemy();
			explosions.push(new Explosion(stage.w/2,stage.h,2));
				shake = true;
				shaket=0;
		}
		for (var b=0;b<bullets.length;b++) {
			var dx = enemies[i].x-bullets[b].x;
			var dy = enemies[i].y-bullets[b].y;
			var dis = dx*dx+dy*dy;
			if (dis<20*20) {
				explosions.push(new Explosion(enemies[i].x,enemies[i].y,1));
				enemies[i] = new Enemy();
				bullets.splice(b,1);
			}
		}
	}
	
	if (ai) {
		for(var l=0;l<enemies.length;l++) {
			var dx = enemies[l].x-stage.w/2;
			var dy = enemies[l].y-stage.h;
			var dis = Math.floor(Math.sqrt(dx*dx+dy*dy));
			var val1 = 100000+dis;
			var val2 = 1000+l;
			cold[l]=val1+'x'+val2;
		}



		cold.sort();
		eturn = parseInt(cold[0].slice(8,11));
		if (parseInt(cold[0].slice(1,6))<800) {
			angle += (enemies[eturn].r-angle)/8;
		}
	} else {

		var dx = pointer.x-stage.w/2;
		var dy = pointer.y-stage.h;
		angle = Math.atan(dx/dy);
	}
	
	drawArrow(stage.w/2,stage.h,stage.w/2-Math.sin(angle)*150,stage.h-Math.cos(angle)*150,30,20,'#2c3e50');



	for(var e=0;e<explosions.length;e++) {
		
		if (explosions[e].ty==1) {
			var myimg = explode;
			ctx.globalAlpha=1-(explosions[e].t/stage.h);
			ctx.drawImage(myimg,explosions[e].x-explosions[e].t/2,explosions[e].y-explosions[e].t/2,explosions[e].t*stage.w/stage.h,explosions[e].t);
			ctx.globalAlpha=1;
		} else {
			var myimg = explodeb;
			ctx.globalAlpha=1-(explosions[e].t/stage.h);
			ctx.drawImage(myimg,explosions[e].x-explosions[e].t*stage.w/stage.h/2,stage.h-explosions[e].t,explosions[e].t*stage.w/stage.h,explosions[e].t);
			ctx.globalAlpha=1;
		}

	}


	for(var e=0;e<explosions.length;e++) {
		explosions[e].t += 20;
		if (explosions[e].t>stage.h) {
			explosions.splice(e,1);
		}
	}
}


// ------------------------------------------------------------------------------- events
// ------------------------------------------------------------------------------- events
// ------------------------------------------------------------------------------- events
// ------------------------------------------------------------------------------- events

function toggleFullScreen() {
	var doc = window.document;
	var docEl = doc.documentElement;

	var requestFullScreen = docEl.requestFullscreen || docEl.mozRequestFullScreen || docEl.webkitRequestFullScreen || docEl.msRequestFullscreen;
	var cancelFullScreen = doc.exitFullscreen || doc.mozCancelFullScreen || doc.webkitExitFullscreen || doc.msExitFullscreen;

	if(!doc.fullscreenElement && !doc.mozFullScreenElement && !doc.webkitFullscreenElement && !doc.msFullscreenElement) {
		requestFullScreen.call(docEl);

	}
	else {
		cancelFullScreen.call(doc);

	}
}


function motchstart(e) {
	mxpos = (e.pageX-loffset)*scale;
	mypos = (e.pageY-toffset)*scale;




}

function motchmove(e) {
	mxpos = (e.pageX-loffset)*scale;
	mypos = (e.pageY-toffset)*scale;
	pointer.x = mxpos;
	pointer.y = mypos;
	ai = false;
	ait = Date.now();
}

function motchend(e) {

}






window.addEventListener('mousedown', function(e) {
	motchstart(e);
}, false);
window.addEventListener('mousemove', function(e) {
	motchmove(e);
}, false);
window.addEventListener('mouseup', function(e) {
	motchend(e);
}, false);
window.addEventListener('touchstart', function(e) {
	e.preventDefault();
	motchstart(e.touches[0]);
}, false);
window.addEventListener('touchmove', function(e) {
	e.preventDefault();
	motchmove(e.touches[0]);
}, false);
window.addEventListener('touchend', function(e) {
	e.preventDefault();
	motchend(e.touches[0]);
}, false);



// ------------------------------------------------------------------------ stager
// ------------------------------------------------------------------------ stager
// ------------------------------------------------------------------------ stager
// ------------------------------------------------------------------------ stager
function _pexresize() {
	var cw = window.innerWidth;
	var ch = window.innerHeight;
	if (cw<=ch*stage.w/stage.h) {
		portrait = true;
		scale = stage.w/cw;
		loffset = 0;
		toffset = Math.floor(ch-(cw*stage.h/stage.w))/2;
		_pexcanvas.style.width = cw + "px";
		_pexcanvas.style.height = Math.floor(cw*stage.h/stage.w) + "px";
		_pexcanvas.style.marginLeft = loffset +"px";
		_pexcanvas.style.marginTop = toffset +"px";
	} else {
		scale = stage.h/ch;
		portrait = false;
		loffset = Math.floor(cw-(ch*stage.w/stage.h))/2;
		toffset = 0;
		_pexcanvas.style.height = ch + "px";
		_pexcanvas.style.width = Math.floor(ch*stage.w/stage.h) + "px";
		_pexcanvas.style.marginLeft = loffset +"px";
		_pexcanvas.style.marginTop = toffset +"px";
	}
}


window.requestAnimFrame = (function(){
	return  window.requestAnimationFrame       ||
	window.webkitRequestAnimationFrame ||
	window.mozRequestAnimationFrame    ||
	window.oRequestAnimationFrame      ||
	window.msRequestAnimationFrame     ||
	function( callback ){
		window.setTimeout(callback, 1000 / 60);
	};})();



	function sfps(iny) {
		return(Math.floor(smoothfps)/60*iny);
	}



	var timebomb=0;
	var lastCalledTime;
	var fpcount = 0;
	var fpall = 0;
	var smoothfps = 60;
	var thisfps = 60;
	function fpscounter() {
		timebomb ++;
		if (!lastCalledTime) {
			lastCalledTime = Date.now();
			return;
		}
		var delta = (Date.now()-lastCalledTime)/1000;
		lastCalledTime = Date.now();
		var fps = 1/delta;
		fpcount ++;
		fpall += fps;
		if (timebomb>30) {
			thisfps = parseInt(fpall/fpcount*10)/10;
			fpcount = 0;
			fpall = 0;
			timebomb = 0;
		}
	}

	var shake = false;
	var shaket = 0;
	function animated() {
		requestAnimFrame(animated);
		if (shake) {
			var trax = Math.random()*60-30;
			var tray = Math.random()*60-30;
			ctx.translate(trax,tray);
		}
		// fpscounter();
    //ctx.clearRect(0,0,_pexcanvas.width,_pexcanvas.height);
    enginestep()
    // ctx.fillStyle='#8e44ad';
    // ctx.font = "24px arial";

    // ctx.textAlign = "left"; 
    // ctx.fillText(thisfps,20,50);
    // smoothfps += (thisfps-smoothfps)/100;
    // ctx.fillText(cold[0].slice(1,6),20,80);
   //  ctx.beginPath();
   //  ctx.arc(pointer.x, pointer.y, 50, 0, Math.PI*2,false);
   // ctx.closePath();
   // ctx.fill();
   if (shake) {
   	ctx.translate(-trax,-tray);
   	shaket ++;
   	if (shaket>20) {
   		shaket=0;
   		shake=false;
   	}
   }
}

_pexresize();
animated();