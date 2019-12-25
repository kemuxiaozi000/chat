//时间格式化
function timestamp2Date(timestamp) {
    var date = new Date();
    date.setTime(timestamp);
    return date;
}

function formatDate(date, fmt) {
    var o = {
        "M+": date.getMonth() + 1, //月份
        "d+": date.getDate(), //日
        "h+": date.getHours(), //小时
        "m+": date.getMinutes(), //分
        "s+": date.getSeconds(), //秒
        "q+": Math.floor((date.getMonth() + 3) / 3), //季度
        "S": date.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        }
    }
    return fmt;
}

function timestamp2FormatDate(timestamp, fmt) {
    var date = timestamp2Date(timestamp);
    var res = formatDate(date, fmt);
    return res;
}

//数组内元素位置调整
function swapArr(arr, index) {
    var tmp_arr = clone(arr);
    tmp_arr.splice(index, 1);
    tmp_arr.splice(0, 0, arr[index]);
    return tmp_arr;
}

// 将msg按照｜分成3分
function divideMsgIntoParts(msg, num_of_parts) {
    var arr = []
    var part_1, part_2, part_3
    var index, index_1
    if (num_of_parts == 2) {
        index = msg.lastIndexOf("|");
        part_1 = msg.substring(0, index);
        part_2 = msg.substring(index + 1, msg.length);
        arr.push(part_1)
        arr.push(part_2)
    } else if (num_of_parts == 3) {
        index = msg.lastIndexOf("|");
        part_3 = msg.substring(index + 1, msg.length);
        let msgContentTmp = msg.substring(0, index);
        index_1 = msgContentTmp.lastIndexOf("|");
        part_2 = msgContentTmp.substring(index_1 + 1, msgContentTmp.length);
        part_1 = msgContentTmp.substring(0, index_1);
        arr.push(part_1)
        arr.push(part_2)
        arr.push(part_3)
    }
    return arr
}

function blobToDataURI(blob, callback) {
    var reader = new FileReader();
    reader.onload = function(e) {
        callback(e.target.result);
    }
    reader.readAsDataURL(blob);
}


function clone(obj) {
    if (obj === null) return null
    if (typeof obj !== 'object') return obj;
    if (obj.constructor === Date) return new Date(obj);
    if (obj.constructor === RegExp) return new RegExp(obj);
    var newObj = new obj.constructor(); //保持继承链
    for (var key in obj) {    
        if (obj.hasOwnProperty(key)) { //不遍历其原型链上的属性
            var val = obj[key];
            newObj[key] = typeof val === 'object' ? arguments.callee(val) : val; // 使用arguments.callee解除与函数名的耦合
                
        }
    }
    return newObj;
};