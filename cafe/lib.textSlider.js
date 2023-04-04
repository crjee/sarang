/**
* 파일명: lib.textSlider.js
* 설  명: 뉴스 Ticker 라이브러리
**/

TextSlider = function(className) {
    document.write("<div class='land' id='TextSliderPLayer_"+ className +"'><div id='TextSliderLayer_"+ className +"'></div></div>");

    this.item = [];
    this.width = this.height = this.speed = this.pixel = this.interval =
        this.size = this.moveCount = this.X = this.Y = 0;
    this.direction = "";
    this.pLayer = document.getElementById("TextSliderPLayer_"+ className);
    this.layer = document.getElementById("TextSliderLayer_"+ className);
    this.align = "left";
    this.intervalId = null;
    this.className = className;
    this.isPause = false;
}
TextSlider.prototype.init = function() {
    with (this.pLayer.style) {
        width = this.width+"px";
        height = this.height+"px";
        overflow = "hidden";
    }
    with (this.layer.style) {
        width = this.direction=='up' || this.direction=='down' ? this.width+"px" : this.size*(this.item.length+1)+"px";
        height = this.direction=='up' || this.direction=='down' ? this.size*(this.item.length+1)+"px" : this.height+"px";
        top = 0;
        left = 0;
        position = "relative";
    }
    for (var i=0; i<parseInt(this.height / this.size, 10)+1; i++)
        this.item[this.item.length] = this.item[i];
    switch (this.direction) {
        case "up": this.X = this.Y = 0; break;
        case "down": this.X = 0; this.layer.style.top = this.Y = -this.size*(this.item.length-1); break;
        case "left": this.X = this.Y = 0; break;
        case "right": this.Y = 0; this.layer.style.left = this.X = -this.size*(this.item.length-1); break;
    }
    var __html = "<div onmouseover='"+this.className+".pause()' onmouseout='"+this.className+".unpause()'>";
    if (this.direction=='up' || this.direction=='down') {
        __html += "<table width='"+ this.layer.style.width +"' cellspacing='0' cellpadding='0' border='0'>";
        for (var i in this.item)
            __html += "<tr><td height='"+this.size+"' style='overflow:hidden' align='"+this.align+"' valign='middle'>"+this.item[i]+"</td></tr>";
        __html += "</table>";
    } else {
        __html += "<table cellspacing='0' cellpadding='0' border='0'><tr>";
        for (var i in this.item)
            __html += "<td width='"+this.size+"' height='"+ this.layer.style.height +"' align='"+this.align+"' \
                valign='top' style='overflow:hidden;'>"+this.item[i]+"</td>";
        __html += "</tr></table>";
    }
    __html += "</div>";
    this.layer.innerHTML = __html;
    this.start();
}
TextSlider.prototype.start = function() {
    this.intervalId = setInterval(this.className+".move()", this.speed);
}
TextSlider.prototype.move = function() {
    if (this.isPause) return;
    switch (this.direction) {
        case "up": this.Y -= this.pixel; break;
        case "down": this.Y += this.pixel; break;
        case "left": this.X -= this.pixel; break;
        case "right": this.X += this.pixel; break;
    }
    if (this.direction=='up' || this.direction=='down') {
        if (Math.abs(this.Y)%this.size==0) this.stop();
        this.layer.style.top = this.Y;
    } else {
        if (Math.abs(this.X)%this.size==0) this.stop();
        this.layer.style.left = this.X;
    }
}
TextSlider.prototype.stop = function() {
    clearInterval(this.intervalId);
    switch (this.direction) {
    case "up":
        if (Math.abs(this.Y) >= parseInt(this.layer.style.height,10)-this.size) this.Y = this.layer.style.top = 0;
        break;

    case "down":
        if (Math.abs(this.Y) <= 0) this.Y = this.layer.style.top = -this.size*(this.item.length-1);
        break;

    case "left":
        if (Math.abs(this.X) >= parseInt(this.layer.style.width,10)-this.size) this.X = this.layer.style.left = 0;
        break;

    case "right":
        if (Math.abs(this.X) <= 0) this.X = this.layer.style.left = -this.size*(this.item.length-1);
        break;
    }
    setTimeout(this.className+".start()", this.interval);
}
TextSlider.prototype.pause = function() {this.isPause = true;}
TextSlider.prototype.unpause = function() {this.isPause = false;}
