var canvas = $('#editor')[0];
var cHeight = canvas.height;
var cWidth = canvas.width;
var ctx = canvas.getContext("2d");
// ctx.beginPath();
// ctx.rect(0, 0, 3000, 2600);
// ctx.fillStyle = 'white';
// ctx.shadowColor = '#444';
// ctx.shadowBlur = 30;
// ctx.fill();
// ctx.stroke();

var img = new Image();
img.onload = function() {
  ctx.beginPath();
  ctx.shadowBlur = 0;
  ctx.drawImage(img, 30, 30);
  ctx.stroke();
}

img.src = "http://localhost:3000/images/settings-gear.svg";
// ctx.setLineDash([10,5]);
// ctx.lineWidth = 1;
// ctx.scale(1, 1);
// for (var i = 0; i < cHeight; i += 2200) {
//   ctx.beginPath();
//   ctx.moveTo(0,i);
//   ctx.lineTo(cWidth, i);
//   ctx.stroke();
// }
//
// for (var i = 0; i < cWidth; i += 1700) {
//   ctx.beginPath();
//   ctx.moveTo(i,0);
//   ctx.lineTo(i, cHeight);
//   ctx.stroke();
// }
