﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.ContractEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>合同编辑</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <link rel="stylesheet" href="../Content/NewConfigurationItem.css" />
</head>
<body>
    <form id="form1" runat="server">
        <!--顶部-->
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">合同编辑</span>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                    <span class="Icon SaveAndClone"></span>
                    <span class="Text">保存并关闭</span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <!--切换按钮-->
        <div class="TabBar">
            <a class="Button ButtonIcon SelectedState">
                <span class="Text">常规信息</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">自定义信息</span>
            </a>
        </div>
        <!--切换项-->
        <div class="TabContainer">
            <div class="DivScrollingContainer Tab">
                <div class="DivSectionWithHeader">
                    <!--头部-->
                    <div class="HeaderRow">
                        <div class="Toggle Collapse Toggle1">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="lblNormalClass">常规信息</span>
                    </div>
                    <div class="Content">
                        <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <table cellpadding="0" cellspacing="0" style="width:100%;">
                                                <tbody>
                                                <tr>
                                                    <td class="FieldLabel">
                                                        客户名称
                                                        <div>
                                                            <a class="ButtonIcon Link NormalState"><%=contract.accountName %></a>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">
                                                        合同状态
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <select name="status_id" class="txtBlack8Class" style="width: 265px;">
                                                                    <option <%if (contract.contract.status_id == 1) { %> selected="selected" <%} %> value="1">激活</option>
                                                                    <option <%if (contract.contract.status_id == 0) { %> selected="selected" <%} %> value="0">未激活</option>
                                                                </select>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel">
                                                        合同类型
                                                        <div>
                                                            <%=contractTypeName %>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel" style="width: 330px;">
                                                        合同种类
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <select name="cate_id" class="txtBlack8Class" style="width: 265px;">
                                                                    <%foreach (var cate in contractCate) {
                                                                            %>
                                                                    <option <%if (contract.contract.status_id.ToString().Equals(cate.val)) { %> selected="selected" <%} %> value="<%=cate.val %>"><%=cate.show %></option>
                                                                    <%
                                                                        } %>
                                                                </select>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel">
                                                        合同名称<span style="color: Red;">*</span>
                                                        <div>
                                                            <input type="text" id="name" name="name" style="width: 265px;" value="<%=contract.contract.name %>"/>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel" style="margin-left:2px;margin-bottom:-3px;">
                                                        联系人
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <asp:DropDownList ID="contact_id" runat="server"></asp:DropDownList>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel">
                                                        合同描述
                                                        <div>
                                                            <textarea name="description" style="height:90px;width:265px;resize:vertical;"><%=contract.contract.description %></textarea>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel" style="margin-left:2px;margin-bottom:-3px;">
                                                        商机
                                                        <div style="margin-bottom: 15px">
                                                            <span style="display: inline-block;">
                                                                <asp:DropDownList ID="opportunity_id" runat="server"></asp:DropDownList>
                                                            </span>
                                                        </div>
                                                        工时计费设置
                                                        <div>
                                                            <span style="display: inline-block;">
                                                                <select name="bill_post_type_id" class="txtBlack8Class" style="width: 265px;">
                                                                    <%foreach (var bill in billPostType) {
                                                                            %>
                                                                    <option value="<%=bill.val %>"><%=bill.show %></option>
                                                                    <%
                                                                        } %>
                                                                </select>
                                                            </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel">
                                                        外部合同号
                                                        <div>
                                                            <input type="text" name="external_no" style="width: 265px;" value="<%=contract.contract.external_no %>"/>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">
                                                        &nbsp;
                                                        <div>
                                                           <span style="display: inline-block;">
                                                               <span class="txtBlack8Class">
                                                                   <input name="" type="checkbox" style="vertical-align:middle;"/>
                                                                   <label>要求工时输入开始/结束时间</label>
                                                               </span>
                                                           </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="FieldLabel">
                                                        服务等级协议
                                                        <div>
                                                             <span style="display: inline-block;">
                                                                <select class="txtBlack8Class" name="sla_id" style="width: 280px;">
                                                                    <option value=""></option>
                                                                    <%foreach (var sla in slaList) {
                                                                            %>
                                                                    <option value="<%=sla.id %>"><%=sla.name %></option>
                                                                    <%
                                                                        } %>
                                                                </select>
                                                                <span style="display: inline-block"><img src="../Images/add.png" style="cursor: pointer;vertical-align: middle;"/></span>
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td class="FieldLabel">
                                                        &nbsp;
                                                        <div>
                                                           <span style="display: inline-block;">
                                                               <span class="txtBlack8Class">
                                                                   <input type="checkbox" name="is_sdt_default" style="vertical-align:middle;"/>
                                                                   <label>默认服务台合同</label>
                                                               </span>
                                                           </span>
                                                        </div>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="DivSectionWithHeader">
                    <!--头部-->
                    <div class="HeaderRow">
                        <div class="Toggle Collapse Toggle2">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="lblNormalClass">日期和计费</span>
                    </div>
                    <div class="Content">
                        <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <table cellpadding="0" cellspacing="0" style="width:100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            合同周期类型
                                                            <div>
                                                                <%if (contract.contract.period_type != null) { %><%=periodType.First(p=>p.val.Equals(contract.contract.period_type.ToString())).show %><%} %>
                                                            </div>
                                                        </td>
                                                        <td class="FieldLabel">
                                                            初始费用
                                                            <div>
                                                                <span style="display: inline-block;">
                                                                    <input type="text" name="setup_fee" value="<%=contract.contract.setup_fee %>"/>
                                                                </span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            开始日期
                                                            <div>
                                                                <input type="text" onclick="WdatePicker()" class="Wdate"/>
                                                            </div>
                                                        </td>
                                                        <td class="FieldLabel">
                                                            初始费用计费代码
                                                            <div>
                                                                <input type="text"  style="width: 265px;"/>
                                                                <span style="display: inline-block"><img src="../Images/data-selector.png" style="cursor: pointer;vertical-align: middle;"/></span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            <span style="display:inline-block;float: left;padding:26px 0 0 0;">
                                                                 <div style="vertical-align: middle">
                                                                     <input type="radio" name="date"/>
                                                                     结束日期
                                                                 </div>
                                                            </span>
                                                            <span style="display:inline-block;float: left;padding-left:90px;padding-top:18px;">
                                                                <div>
                                                                    <input type="text" onclick="WdatePicker()" class="Wdate"/>
                                                                </div>
                                                            </span>
                                                        </td>
                                                        <td class="FieldLabel">
                                                            计费客户
                                                            <div>
                                                                <input type="text"  style="width: 265px;"/>
                                                                <span style="display: inline-block"><img src="../Images/data-selector.png" style="cursor: pointer;vertical-align: middle;"/></span>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            <span style="display:inline-block;float: left;padding:26px 0 0 0;">
                                                                <div style="vertical-align: middle">
                                                                    <input type="radio" name="date" />
                                                                    结束于(服务周期)
                                                                </div>
                                                            </span>
                                                            <span style="display:inline-block;float: left;padding-left:45px;padding-top:18px;">
                                                                <div>
                                                                    <input type="text" disabled="disabled" />
                                                                </div>
                                                            </span>
                                                        </td>
                                                        <td class="FieldLabel">
                                                            合同通知联系人
                                                            <div>
                                                                <input type="text" style="width: 265px;" disabled="disabled"/>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            采购订单号
                                                            <div>
                                                                <input type="text" style="width: 265px;" value=""/>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="FieldLabel">
                                                            预估收入
                                                            <div>
                                                                <input type="text" style="width: 130px;" value="" disabled="disabled"/>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="TabContainer" style="display: none;">
            <div class="DivScrollingContainer Tab">
                <div class="DivSectionWithHeader">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle1">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">用户自定义</span>
                </div>
                <div class="Content">
                    <table class="Neweditsubsection" style="width: 720px;" cellpadding="0" cellspacing="0">
                        <tbody>
                        <tr>
                            <td>
                                <div>
                                    <table cellpadding="0" cellspacing="0" style="width:100%;">
                                        <tbody>
                                        <tr>
                                            <td class="FieldLabel">
                                                Test
                                                <div>
                                                    <input type="text" style="width: 265px;">
                                                </div>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            </div>
        </div>
    </form>
    <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/NewConfigurationItem.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
</body>
</html>
