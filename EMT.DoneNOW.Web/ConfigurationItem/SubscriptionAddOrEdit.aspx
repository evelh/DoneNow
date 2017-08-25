﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubscriptionAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.SubscriptionAddOrEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
       <title> <%=isAdd?"新建订阅":"编辑订阅" %></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <style>
body{
   /*overflow: hidden;*/
}
/*顶部内容和帮助*/
.TitleBar{
    color: #fff;
    background-color: #346a95;
    display: block;
    font-size: 15px;
    font-weight: bold;
    height: 36px;
    line-height: 38px;
    margin: 0 0 10px 0;
}
.TitleBar>.Title{
    top: 0;
    height: 36px;
    left: 10px;
    overflow: hidden;
    position: absolute;
    text-overflow: ellipsis;
    text-transform: uppercase;
    white-space: nowrap;
    width: 97%;
}
.text2{
    margin-left: 5px;
}
.help{
    background-image: url(../Images/help.png);
    cursor: pointer;
    display: inline-block;
    height: 16px;
    position: absolute;
    right: 10px;
    top: 10px;
    width: 16px;
    border-radius: 50%;
}
/*保存按钮*/
.ButtonContainer{
    padding: 0 10px 10px 10px;
    width: auto;
    height: 26px;
}
.ButtonContainer ul li .Button{
    margin-right: 5px;
    vertical-align: top;
}
li.Button{
    -ms-flex-align: center;
    align-items: center;
    background: #f0f0f0;
    background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
    background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
    background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
    background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
    border: 1px solid #d7d7d7;
    display: -ms-inline-flexbox;
    display: inline-flex;
    color: #4f4f4f;
    cursor: pointer;
    height: 24px;
    padding: 0 3px;
    position: relative;
    text-decoration: none;
}
.Button>.Icon{
    display: inline-block;
    flex: 0 0 auto;
    height: 16px;
    margin: 0 3px;
    width: 16px;
}
.Save,.SaveAndClone,.SaveAndNew{
    background-image: url("../Images/save.png");
}
.Cancel{
    background-image: url("../Images/cancel.png");
}
.Button>.Text{
    flex: 0 1 auto;
    font-size: 12px;
    font-weight: bold;
    overflow: hidden;
    padding: 0 3px;
    text-overflow: ellipsis;
    white-space: nowrap;
}
/*内容*/
.DivScrollingContainer.General {
    top: 82px;
}
.DivScrollingContainer {
    left: 0;
    overflow-x: auto;
    overflow-y: auto;
    position: fixed;
    right: 0;
    bottom: 0;
}
.DivSection {
    border: 1px solid #d3d3d3;
    margin: 0 10px 10px 10px;
    padding: 12px 28px 4px 28px;
}
.DivSection>table {
    border: 0;
    margin: 0;
    border-collapse: collapse;
}
.DivSection td[id="txtBlack8"], .DivSection td[class="FieldLabels"] {
    vertical-align: top;
}
.DivSection td {
    padding: 0;
    text-align: left;
}
.FieldLabels, .workspace .FieldLabels {
    font-size: 12px;
    color: #4F4F4F;
    font-weight: bold;
    line-height: 15px;
}
.DivSection td[class="fieldLabels"] input, .DivSection td[class="fieldLabels"] select, .DivSection td[class="FieldLabels"] input, .DivSection td[class="FieldLabels"] select, .WizardSection td[class="fieldLabels"] input, .WizardSection td[class="fieldLabels"] select, .WizardSection td[class="FieldLabels"] input, .WizardSection td[class="FieldLabels"] select {
    margin-right: 1px;
}
.DivSection .FieldLabels div, .DivSection td[class="fieldLabels"] div, .DivSectionWithHeader td[class="fieldLabels"] div {
    margin-top: 1px;
    padding-bottom: 11px;
    font-weight: 100;
}
input[type=text], select, textarea {
    border: solid 1px #D7D7D7;
    font-size: 12px;
    color: #333;
    margin: 0;
}
input[type=text] {
    height: 22px;
    padding: 0 6px;
}
select {
    height: 24px;
    padding: 0;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
     <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增订阅</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text"><asp:Button ID="save_click" runat="server" BorderStyle="None" Text="保存并关闭" OnClick="save_click_Click" /></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <span class="Icon SaveAndNew"></span>
                <span class="Text"><asp:Button ID="save_add" runat="server" BorderStyle="None" Text="保存并新建" OnClick="save_add_Click" /></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text" id="close">取消</span>
            </li>
        </ul>
    </div>
    <!--内容-->
    <div class="DivScrollingContainer General">
        <div class="DivSection">
            <table width="95%" border="0" cellspacing="0" cellpadding="2">
                <tbody>
                    <tr>
                        <td class="FieldLabels">
                            <input type="hidden" name="installed_product_id" value="<%=iProduct.id %>"/>
                            名称
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" id="name" name="name" value="<%=isAdd?"":subscription.name %>" style="width:255px">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            描述
                            <div>
                                <input type="text" style="width:255px"  id="description" name="description" value="<%=isAdd?"":subscription.description %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            周期类型
                            <div>
                                <asp:DropDownList ID="period_type_id" runat="server" Width="270px"></asp:DropDownList>
                        
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            有效日期
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" style="width:255px" onclick="WdatePicker()" class="Wdate Count"  id="effective_date" name="effective_date" value="<%=isAdd?"":subscription.effective_date.ToString("yyyy-MM-dd") %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            过期日期
                            <span style="color:red;">*</span>
                            <div>
                                <input type="text" style="width:255px" onclick="WdatePicker()" class="Wdate Count" id="expiration_date" name="expiration_date" value="<%=isAdd?"":subscription.expiration_date.ToString("yyyy-MM-dd") %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            周期价格
                            <span style="color:red;">*</span>
                            <div>
                                <input class="Number" type="text" style="width:255px;text-align: right;" id="period_price" name="period_price" value="<%=isAdd?"":subscription.period_price.ToString() %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            总价
                            <span style="color:red;">*</span>
                            <div>
                                <input  class="Number"  type="text" style="width:255px;text-align: right;" id="total_price" name="total_price" value="<%=isAdd?"":subscription.total_price.ToString() %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            物料成本代码
                            
                            <div> 
                                <!-- todo 物料代码名称的显示-->
                                <input type="text" style="width:255px;"  id="cost_code_id" name="" value="" />
                                <img src="../Images/data-selector.png" style="vertical-align: middle;">
                                <input type="hidden" name="cost_code_id" id="cost_code_idHidden" value="<%=isAdd?"":subscription.cost_code_id.ToString() %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            订单号
                            <div>
                                <input type="text" style="width:255px" name="purchase_order_number" id="purchase_order_number" value="<%=isAdd?"":subscription.purchase_order_number.ToString() %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            周期成本
                            <div>
                                <input  class="Number"  type="text" style="width:255px;text-align: right;"  name="period_cost" id="period_cost" value="<%=(!isAdd)&&subscription.period_cost!=null?((decimal)subscription.period_cost).ToString("0.00"):"" %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            总成本
                            <div>
                                <input class="Number"  type="text" style="width:255px;text-align: right;" name="total_cost" id="total_cost" value="<%=(!isAdd)&&subscription.total_cost!=null?((decimal)subscription.total_cost).ToString("0.00"):"" %>"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            状态
                            <div>
                                <asp:CheckBox ID="isActive" runat="server" />
                           <%--     <select style="width:270px">
                                    <option value="">Active</option>
                                    <option value="">Monthly</option>
                                    <option value="">Monthly</option>
                                    <option value="">Monthly</option>
                                </select>--%>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="DivSection">
            <table width="95%" border="0" cellspacing="0" cellpadding="2">
                <tbody>
                    <tr>
                        <td class="FieldLabels">
                           客户名称
                            <% var account = new EMT.DoneNOW.BLL.CompanyBLL().GetCompany((long)iProduct.account_id); %>
                            <div>
                               <%=account!=null?account.name:"" %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            配置项名称
                            <% var ivtdProduct = new EMT.DoneNOW.BLL.IVT.ProductBLL().GetProduct(iProduct.product_id); %>
                            <div>
                               <%=ivtdProduct!=null?ivtdProduct.product_name:"" %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            配置项序列号
                            <div>
                                <%=iProduct.serial_number %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                           配置项参考号
                            <div>
                                <%=iProduct.reference_number %>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="DivSection">
            <table width="95%" border="0" cellspacing="0" cellpadding="2">
                <tbody>
                    <tr>
                        <td class="FieldLabels">
                            订阅期数
                            <div>
                                <input type="text" id="subscription_period" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            首期结算日
                            <div>
                                <input type="text" id="firstTime" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            下期结算日
                            <div>
                                <input type="text" id="NextTime" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            最后一期结算日期
                            <div>
                                <input type="text" id="LastTime" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            已结算金额
                            <div>
                                <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color:transparent; text-align:left" value="¥0.00">
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $("#SaveAndCloneButton").on("mouseover", function () {
        $("#SaveAndCloneButton").css("background", "#fff");
    });
    $("#SaveAndCloneButton").on("mouseout", function () {
        $("#SaveAndCloneButton").css("background", "#f0f0f0");
    });
    $("#SaveAndNewButton").on("mouseover", function () {
        $("#SaveAndNewButton").css("background", "#fff");
    });
    $("#SaveAndNewButton").on("mouseout", function () {
        $("#SaveAndNewButton").css("background", "#f0f0f0");
    });
    $("#CancelButton").on("mouseover", function () {
        $("#CancelButton").css("background", "#fff");
    });
    $("#CancelButton").on("mouseout", function () {
        $("#CancelButton").css("background", "#f0f0f0");
    });
</script>

<script>

    $("#save_click").click(function () {
        if (!submitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_add").click(function () {
        if (!submitCheck()) {
            return false;
        }
        return true;
    })


    $(".Count").blur(function () {
        Subscription();
    })

    $("#period_type_id").change(function () {
        Subscription();
    })

    $(".Number").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && $.trim(value) != "") {
            $(this).val(toDecimal2(value));
        } else {
            $(this).val("");
        }

    })

    $("#period_price").blur(function () {
        var periods = $("#subscription_period").val(); // 期数
        if (periods == "") {
            periods = 1;
        }
        var period_price = $("#period_price").val();  // 周期价格
        var total_price = $("#total_price").val();    // 总价

        if (period_price == "") {
            $("#total_price").val("");
        }
        else {
            total_price = Number(period_price) * periods;
            $("#total_price").val(total_price);
        }
    })
    $("#total_price").blur(function () {
        var periods = $("#subscription_period").val(); // 期数
        if (periods == "") {
            periods = 1;
        }
        var period_price = $("#period_price").val();  // 周期价格
        var total_price = $("#total_price").val();    // 总价

        if (total_price == "") {
            $("#period_price").val("");
        }
        else {
            period_price = Number(total_price / periods).toFixed(2);
            $("#period_price").val(period_price);
        }
    })
    $("#period_cost").blur(function () {
        var periods = $("#subscription_period").val(); // 期数
        if (periods == "") {
            periods = 1;
        }
        var period_cost = $("#period_cost").val();  // 周期价格
        var total_cost = $("#total_cost").val();    // 总价

        if (period_cost == "") {
            $("#total_cost").val("");
        }
        else {
            total_cost = Number(period_cost) * periods;
            $("#total_cost").val(total_cost);
        }
    })
    $("#total_cost").blur(function () {
        var periods = $("#subscription_period").val(); // 期数
        if (periods == "") {
            periods = 1;
        }
        var period_cost = $("#period_cost").val();  // 周期价格
        var total_cost = $("#total_cost").val();    // 总价

        if (total_cost == "") {
            $("#period_cost").val("");
        }
        else {
            period_cost = Number(total_cost / periods).toFixed(2);
            $("#period_cost").val(period_cost);
        }
    })


    function submitCheck() {
        var name = $("#name").val();
        if (name == "") {
            alert("请填写名称");
            return false;
        }
        var period_type_id = $("#period_type_id").val();
        if (period_type_id == 0) {
            alert("请选择周期类型");
            return false;
        }
        var effective_date = $("#effective_date").val();
       
        if (effective_date == "") {
            alert("请填写有效日期");
            return false;
        }
        var expiration_date = $("#expiration_date").val();
        if (expiration_date == "") {
            alert("请填写过期日期");
            return false;
        }
        var period_price = $("#period_price").val();
        if (period_price == "") {
            alert("请填写周期价格");
            return false;
        }
        var total_price = $("#total_price").val();
        if (total_price == "") {
            alert("请填写总价");
            return false;
        }

        return true;
    }
    // 计算订阅期数还有
    function Subscription()
    {
        var periods = 1;       // 订阅期数
        var diffDay = 0;
        var firstDate = $("#effective_date").val();
        var lastDate = $("#expiration_date").val();
        var period_type_id = $("#period_type_id").val();
        if (firstDate != "" && lastDate != "") {
            diffDay = DateDiff(firstDate, lastDate);
            if (period_type_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME %>'){

            }
            else if (period_type_id =='<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH %>'){
                periods = Math.ceil(diffDay / 30);
            }
            else if (period_type_id =='<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER %>'){
                periods = Math.ceil(diffDay / 90);
            }
            else if (period_type_id =='<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR %>'){
                periods = Math.ceil(diffDay / 180);
            }
            else if (period_type_id =='<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR %>'){
                periods = Math.ceil(diffDay / 365);
            }

            $("#subscription_period").val(periods);
            $("#firstTime").val(firstDate);
            $("#NextTime").val(firstDate);
            var date = new Date().toLocaleDateString();
            if (firstDate < date) {
                $("#NextTime").css("color","red");
            }
            else {
                $("#NextTime").css("color", "");
            }
            $("#LastTime").val(lastDate);
            PriceCount();
        }
    }
    // 计算价格，总额相关
    function PriceCount() {
        debugger;
        var periods = $("#subscription_period").val(); // 期数
        if (periods == "") {
            periods = 1;
        }

        var period_price = $("#period_price").val();  // 周期价格
        var total_price = $("#total_price").val();    // 总价
        var period_cost = $("#period_cost").val();    // 周期成本
        var total_cost = $("#total_cost").val();      // 总成本

      
        if (total_price != "") {
            period_price = Number(total_price / periods).toFixed(2);
            $("#period_price").val(period_price);
        }

        if (total_cost != "") {
            period_cost = Number(total_cost / periods).toFixed(2);
            $("#period_cost").val(period_cost);
        }

    }



    function DateDiff(sDate1, sDate2) {  //sDate1和sDate2是yyyy-MM-dd格式

        var aDate, oDate1, oDate2, iDays;

        aDate = sDate1.split("-");

        oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式

        aDate = sDate2.split("-");

        oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);

        iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); //把相差的毫秒数转换为天数



        return iDays;  //返回相差天数

    }

</script>
