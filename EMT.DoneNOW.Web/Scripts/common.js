
/**
 * ajax 加载数据
 * @param url 地址
 * @param data post数据
 * @param calBackFunction 回掉函数
 */
function requestData(url, data, calBackFunction) {
    url = "http://localhost:60242/" + url;
    $.ajax({
        type: "POST",
        url: url,
        data: data,
        dataType: "JSON",
        timeout: 20000,
        async: true,
        beforeSend : function(){
            //$("body").append(loadDialog);
        },
        success : function(json){
            calBackFunction(json);
            //$("#LoadingDialog").remove();
        },
        error : function(XMLHttpRequest){
            //$("#LoadingDialog").remove();
            //console.log(XMLHttpRequest);
            alert('请检查网络');
        }
    });
}

// 校验电话格式
function checkPhone(str) {
    var re = /^0\d{2,3}-?\d{7,8}$/;
    if (re.test(str)) {
        return true;
    } else {
        return false;
    }
}

// 校验邮箱
function checkEmail(str) {
    //var re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
    var re = '^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$';
    if (re.test(str)) {
        return true;
    } else {
        return false;
    }
}

// 校验邮编
function checkPostalCode(str) {
    var re = /^[1-9][0-9]{5}$/;
    if (re.test(str)) {
        return true;
    } else {
        return false;
    }
}
// 去除多余空格 可以更换第二个参数去替换别的
function Trim(str, is_global) {
    var result;
    result = str.replace(/(^\s+)|(\s+$)/g, "");
    if (is_global.toLowerCase() == "g") {
        result = result.replace(/\s/g, "");
    }
    return result;
}

function chooseCompany() {
    window.open("../Common/SelectCallBack.aspx?cat=728&field=ParentComoanyName", 'new', 'left=200,top=200,width=600,height=800', false);
    //window.open(url, "newwindow", "height=200,width=400", "toolbar =no", "menubar=no", "scrollbars=no", "resizable=no", "location=no", "status=no");
    //这些要写在一行
}
// 检查日期是否正确。正确返回true
function check(date) {
    return (new Date(date).getDate() == date.substring(date.length - 2));
}
// 保留两位小数
function toDecimal2(x) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return false;
    }
    var f = Math.round(x * 100) / 100;
    var s = f.toString();
    var rs = s.indexOf('.');
    if (rs < 0) {
        rs = s.length;
        s += '.';
    }
    while (s.length <= rs + 2) {
        s += '0';
    }
    return s;
}

