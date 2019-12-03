function dealImage(base64, w, callback) {
  if (base64.length / 1024 < 500) {
    console.log("<500")
    callback(base64);
    return;
  }
  console.log(base64.length / 1024)
  var newImage = new Image();
  var quality = 0.9;    //压缩系数0-1之间
  newImage.src = base64;
  newImage.setAttribute("crossOrigin", 'Anonymous');	//url为外域时需要
  var imgWidth, imgHeight;
  newImage.onload = function () {
    imgWidth = this.width;
    imgHeight = this.height;
    var canvas = document.createElement("canvas");
    var ctx = canvas.getContext("2d");
    if (Math.max(imgWidth, imgHeight) > w) {
      if (imgWidth > imgHeight) {
        canvas.width = w;
        canvas.height = w * imgHeight / imgWidth;
      } else {
        canvas.height = w;
        canvas.width = w * imgWidth / imgHeight;
      }
    } else {
      canvas.width = imgWidth;
      canvas.height = imgHeight;
      quality = 0.6;
    }
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(this, 0, 0, canvas.width, canvas.height);
    var base64 = canvas.toDataURL("image/jpeg", quality); //压缩语句
    // 如想确保图片压缩到自己想要的尺寸,如要求在50-150kb之间，请加以下语句，quality初始值根据情况自定
    var n1 = 0;
    var n2 = 0;
    while (base64.length / 1024 > 500) {
      quality -= 0.01;
      n1 = n1 + 1;
      console.log(">500")
      console.log(base64.length / 1024)
      base64 = canvas.toDataURL("image/jpeg", quality);
    }
    // 防止最后一次压缩低于最低尺寸，只要quality递减合理，无需考虑
    while (base64.length / 1024 < 50) {
      quality += 0.01;
      n2 = n2 + 1;
      console.log("<50")
      console.log(base64.length / 1024)
      base64 = canvas.toDataURL("image/jpeg", quality);
    }
    console.log("n1=" + n1 + ", n2=" + n2)
    callback(base64);//必须通过回调函数返回，否则无法及时拿到该值
  }
}
