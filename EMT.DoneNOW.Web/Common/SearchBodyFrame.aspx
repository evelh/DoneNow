﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchBodyFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchBodyFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
	<link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/style.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css"/>
    <title></title>
</head>
<style>
    .searchcontent{
  OVERFLOW:   scroll;   width:   1800px;   height:   100%;
    }
    table{
        width:100%;
         
    }
    .searchcontent table th {
    background-color: #cbd9e4;
    border-color: #98b4ca;
    color: #64727a;
    height: 28px;
    line-height: 28px;
    text-align:center;
}
</style>
<body>
    <form id="form1">
        <div id="search_list">
            <input type="hidden" id="page_num" name="page_num" <%if (queryResult != null) {%>value="<%=queryResult.page %>"<%} %> />
            <input type="hidden" id="page_size" name="page_size" <%if (queryResult != null) {%>value="<%=queryResult.page_size %>"<%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null) {%>value="<%=queryResult.query_id %>"<%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null) {%>value="<%=queryResult.order_by %>"<%} %> />
            <input type="hidden" id="type" name="type" value="<%=queryPage %>" />
            <div id="conditions">
                <%foreach (var para in queryParaValue)
                    { %>
                <input type="hidden" name="<%=para.val %>" value="<%=para.show %>" />
                <%} %>
            </div>
        </div>
        <div class="contenttitle clear">
			<ul class="clear fl">
				<li onclick="Add()"><i style="background-image: url(../Images/new.png);"></i><span><%=this.addBtn %></span></li>
				<li><i style="background-image: url(../Images/new.png);"></i></li>
				<li onclick="javascript:window.open('ColumnSelector.aspx?type=<%=queryPage %>', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);"><i style="background-image: url(../Images/column-chooser.png);"></i></li>
				<li><i style="background-image: url(../Images/new.png);"></i></li>
			</ul>
            <%if (queryResult != null && queryResult.count>0)
                { %>
            <div class="page fl">
                <%
                                 int indexFrom = queryResult.page_size * (queryResult.page - 1) + 1;
                                 int indexTo = queryResult.page_size * queryResult.page;
                                 if (indexFrom > queryResult.count)
                                     indexFrom = queryResult.count;
                                 if (indexTo > queryResult.count)
                                     indexTo = queryResult.count;
                    %>
				<span>第<%=indexFrom %>-<%=indexTo %>&nbsp;总数&nbsp;<%=queryResult.count %></span>
				<span><%if (queryResult.page_size == 20)
                                 {
                      %>20<%}
                                 else
                                 {
                      %><a href="#" onclick="ChangePageSize(20)">20</a><%}
                      %>|<%if (queryResult.page_size == 50)
                                 {
                      %>50<%}
                                 else
                                 {
                      %><a href="#" onclick="ChangePageSize(50)">50</a><%}
                      %>|<%if (queryResult.page_size == 100)
                                 { %>100<%}
                                 else
                                 { %><a href="#" onclick="ChangePageSize(100)">100</a><%} %></span>
				<i onclick="ChangePage(1)"><<</i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page-1 %>)"><</i>
				<input type="text" style="width:30px;" value="<%=queryResult.page %>" />
                <span>&nbsp;/&nbsp;<%=queryResult.page_count %></span>
				<i onclick="ChangePage(<%=queryResult.page+1 %>)">></i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page_count %>)">>></i>
			</div>
            <%} %>
		</div>
        <%if (queryResult != null) { %>
			<div class="searchcontent" id="searchcontent">
				<table border="" cellspacing="0" cellpadding="0">
					<tr>
                        <%foreach(var para in resultPara)
                            {
                                if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                    || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                    || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                    continue;
                                string orderby = null;
                                string order = null;
                                if (!string.IsNullOrEmpty(queryResult.order_by))
                                {
                                    var strs = queryResult.order_by.Split(' ');
                                    orderby = strs[0];
                                    order = strs[1].ToLower();
                                }
                                %>
                        <th title="点击按此列排序"  onclick="ChangeOrder('<%=para.name %>')">
                            <%=para.name %>
                            <%if (orderby!=null && para.name.Equals(orderby))
                                { %><img src="../Images/sort-<%=order %>.png" /> 
                            <%} %></th>
                        <%} %>
					</tr>
                    <%
                        if (queryResult.count==0)
                        {
                            %>
                    <tr><td align="center" style="color:red;">选定的条件未查找到结果</td></tr>
                    <%
                        }
                        else
                        { 
                            var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                            foreach (var rslt in queryResult.result) {
                                string id = "0";
                                if (idPara != null)
                                    id = rslt[idPara.name].ToString();
                                %>
					    <tr onclick="View(<%=id %>)" title="右键显示操作菜单" data-val="<%=id %>" class="dn_tr">
                            <%foreach (var para in resultPara) { 
                                    if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                        continue;
                                    %>
						    <td><%=rslt[para.name] %></td>
                            <%} // foreach
                                %>
					    </tr>
                        <%} // foreach
                    } // else
                        %>
				</table>
			</div>
        <%} %>
    </form>
    <div id="menu">
		<ul style="width:220px;">
            <%foreach (var menu in contextMenu) { %>
            <li onclick="<%=menu.click_function %>"><i class="menu-i1"></i><%=menu.text %>
                <%if (menu.submenu != null) { %>
                <i class="menu-i2">>></i>
                <ul>
                    <%foreach (var submenu in menu.submenu) { %>
                    <li onclick="<%=submenu.click_function %>"><%=submenu.text %></li>
                    <%} %>
			    </ul>
            <%} %>
            </li>
            <%} %>
		</ul>
	</div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        <% if (queryPage.Equals("客户查询"))
        { %>
        function EditCompany() {
            OpenWindow("../Company/EditCompany.aspx?id=" + entityid);
        }
        function ViewCompany() {
            OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid);
        }
        function Add() {
            OpenWindow("../Company/AddCompany.aspx");
        }
        function DeleteCompany() {
            OpenWindow("../Company/DeleteCompany.aspx?id=" + entityid);
        }
        function View(id) {
            OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + id);
        }
        <%}
        else if (queryPage.Equals("联系人查询")) {
            %>
        function EditContact() {
            OpenWindow("../Contact/AddContact.aspx?id=" + entityid);
        }
        function ViewContact() {
            OpenWindow("../Contact/ViewContact.aspx?type=todo&id=" + entityid);
        }
        function View(id) {
            OpenWindow("../Contact/ViewContact.aspx?type=todo&id=" + id);
        }
        function DeleteContact() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=delete&id=" + entityid,             
                success: function (data) {
                    alert(data);
                }

            })
        }
        <%}
        else if (queryPage.Equals("商机查询")) {
            %>
        function EditOpp() {
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + entityid);
        }
        function ViewOpp() {
            OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + entityid);
        }
        function View(id) {
            OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + id);
        }
        function DeleteOpp() {
            $.ajax({
                type: "GET",
                url: "../Tools/OpportunityAjax.ashx?act=delete&id=" + entityid,
                success: function (data) {
                    alert(data);
                }
            })
        }
        <%
        }%>
        function openopenopen() {
            alert("暂未实现");
        }
    </script>
</body>
</html>
