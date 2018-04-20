﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="EMT.DoneNOW.Web.Index" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DoneNOW</title>
    <link rel="stylesheet" type="text/css" href="Content/base.css" />
    <link rel="stylesheet" type="text/css" href="Content/index.css" />
    <style>
           /*黑色幕布*/
        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 99;
            position: absolute;
            top: 0;
            left: 0;
            display: none;
        }
        /*弹框*/
        .Dialog.Large {
            width: 876px;
            height: 450px;
            left: 50%;
            position: fixed;
            top: 50%;
            background-color: white;
            border: solid 4px #b9b9b9;
            display: none;
        }
         .CancelDialogButton {
            background-image: url(../Images/cancel1.png);
            background-position: 0 -32px;
            border-radius: 50%;
            cursor: pointer;
            height: 32px;
            position: absolute;
            right: -14px;
            top: -14px;
            width: 32px;
            z-index: 1;
        }
         .heard-title {
    font-size: 15px;
    font-weight: bold;
    height: 36px;
    text-align: left;
    width: 97%;
    background-color: #346a95;
    color: #fff;
    position: relative;
    padding-left: 10px;
    padding-top: 5px;
}
         #MoreBookDiv input[type=checkbox]{
             margin-top:5px;
         }
    </style>
</head>
<body>
    <!--导航栏-->
    <%="" %>
    <div id="SiteNavigationBar">
        <div class="Left">
            <div class="Logo Button ButtonIcon">
                <div class="Icon"></div>
            </div>
            <div class="Search">
                <input type="text" placeholder="搜索" maxlength="100" id="SearchText">
            </div>
            <div class="ButtonGroup ExecuteSearch" id="QuickSearchPage">
                <div class="Search Button ButtonIcon">
                    <div class="Icon"></div>
                </div>
            </div>
            <!--左边的6个图标-->
            <div class="ButtonGroup clear">
                <div class="Dashboard Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
                <div class="New Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
                <div class="My Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
                <div class="Recent Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
                <div class="Bookmark Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
                <div class="Calendar Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
            </div>
            <!--logo的下拉菜单-->
            <div class="ContextOverlayContainer">
                <div class="GuideOverlay ContextOverlay" style="left: 30px; top: 39px;">
                    <div class="Content">
                        <div class="Guide">
                            <!--第一级菜单-->
                            <div class="ButtonContainer">
                                <div class="GuideNavigation Button ButtonIcon SelectedState" id="HomePage">主页</div>
                                <%if (CheckAuth("MENU_CRM"))
                                { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">CRM</div>
                                <%} %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">目录</div>
                                <%if (CheckAuth("MENU_CONTRACT"))
                                    { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">合同</div>
                                <%} %>
                                <%if (CheckAuth("MENU_PROJECT"))
                                { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">项目</div>
                                <%} %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">服务台</div>
                                <div class="GuideNavigation Button ButtonIcon NormalState">工时</div>
                                <%if (CheckAuth("MENU_INVENTORY")) { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">库存</div>
                                <%} %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">报表</div>
                                <div class="GuideNavigation Button ButtonIcon NormalState">外包</div>
                                <%if (CheckAuth("MENU_SETTING"))
                                { %>
                                <div class="GuideNavigation Button ButtonIcon NormalState">系统设置</div>
                                <%} %>
                            </div>
                            <!--第二级菜单-->
                            <div class="ModuleContainer">
                                <!--第一个-->
                                <div class="Module Active">
                                </div>
                                <!--第二个-->
                                <%if (CheckAuth("MENU_CRM"))
                                { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">查看</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CRM_COMPANY"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>" target="PageFrame">
                                                        <span class="Text">客户管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_CONTACT"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT %>" target="PageFrame">
                                                        <span class="Text">联系人管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_CONFIGURATION_ITEM"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSTALLEDPRODUCT %>" target="PageFrame">
                                                        <span class="Text">配置项管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_NOTES"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CRM_NOTE_SEARCH %>" target="PageFrame">
                                                        <span class="Text">备注管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_OPPORTUNITY"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITY %>" target="PageFrame">
                                                        <span class="Text">商机管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_SALESORDER"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SALEORDER %>" target="PageFrame">
                                                        <span class="Text">销售订单管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_QUOTE"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE %>" target="PageFrame">
                                                        <span class="Text">报价管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_SUBSCRIPTION"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SUBSCRIPTION %>" target="PageFrame">
                                                        <span class="Text">订阅管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                                <%if (CheckAuth("MENU_CRM_TODOS"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TODOS %>" target="PageFrame">
                                                        <span class="Text">待办管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CRM_QUOTE_TEMPLATE"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE_TEMPLATE %>" target="PageFrame">
                                                        <span class="Text">报价模板管理</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                                <!--第三个-->
                                <div class="Module">
                                </div>
                                <!--第四个-->
                                <%if (CheckAuth("MENU_CONTRACT"))
                                    { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">搜索</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_CONTRACT"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT %>" target="PageFrame">
                                                        <span class="Text">合同管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">审批并提交</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_APPROVE_CHARGES"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_LABOUR %>" target="PageFrame">
                                                        <span class="Text">审批并提交</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">发票和工时调整</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_GENERATE_INVOICE"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Invoice/InvocieSearch.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.GENERATE_INVOICE %>" target="PageFrame">
                                                        <span class="Text">生成发票</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                                <%if (CheckAuth("MENU_CONTRACT_INVOICE_HISTORY"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_HISTORY %>" target="PageFrame">
                                                        <span class="Text">历史发票</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_CONTRACT_INVOICE_TEMPLATE"))
                                                    { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_TEMPLATE %>" target="PageFrame">
                                                        <span class="Text">发票模板</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%}%>
                                <!--第五个-->
                                <%if (CheckAuth("MENU_PROJECT"))
                                { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">搜索</div>
                                                </div>
                                                <%if (CheckAuth("SEARCH_PROJECT_PROJECT"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Project/ProjectSearch.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_SEARCH %>" target="PageFrame">
                                                        <span class="Text">项目管理</span>
                                                    </a>
                                                </div>
                                                <%}%>

                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_TEMP_SEARCH %>" target="PageFrame">
                                                        <span class="Text">项目模板管理</span>
                                                    </a>
                                                </div>

                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Project/ProjectSearch.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_PROPOSAL_SEARCH %>" target="PageFrame">
                                                        <span class="Text">项目提案管理</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%}%>
                                <!--第六个-->
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                              <div class="Group">
                                                  <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" onclick="window.open('../ServiceDesk/DispatchCalendar.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.DISPATCH_CALENDAR %>','left=0,top=0,width=1800,height=950', false);" >
                                                        <span class="Text">调度工作室</span>
                                                    </a>
                                                </div>
                                                    <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="ServiceDesk/MyQueueList.aspx" target="PageFrame">
                                                        <span class="Text">我的工作组和队列</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">查询</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SEARCH %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">工单</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.KNOWLEDGEBASE_ARTICLE %>" target="PageFrame">
                                                        <span class="Text">知识库</span>
                                                    </a>
                                                </div>
                                                 <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MASTER_TICKET_SEARCH %>" target="PageFrame">
                                                        <span class="Text">定期主工单</span>
                                                    </a>
                                                </div>
                                                 <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_SEARCH %>" target="PageFrame">
                                                        <span class="Text">服务预定</span>
                                                    </a>
                                                </div>
                                            </div>
                                           
                                        </div>
                                    </div>
                                </div>
                                <!--第七个-->
                                <div class="Module">
                                    
                                      <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">我的</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_MY_CURRENT %>&con2735=<%=LoginUserId %>" target="PageFrame">
                                                        <span class="Text">当前工时表</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_MY_REQUEST %>&con2743=<%=LoginUserId %>" target="PageFrame">
                                                        <span class="Text">休假请求</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="TimeSheet/MyTimeSummary" target="PageFrame">
                                                        <span class="Text">休假汇总</span>
                                                    </a>
                                                </div>
                                                <%if (CheckAuth("MENU_INVENTORY_PRODUCT")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.EXPENSE_REPORT %>" target="PageFrame">
                                                        <span class="Text">费用报表</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                  <div class="Heading">
                                                    <div class="Text">等待我审批的</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_WAIT_APPROVE %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">工时表</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_REQUEST_WAIT_APPROVE %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">休假请求</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MYAPPROVE_EXPENSE_REPORT %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">费用报表</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                  <div class="Heading">
                                                    <div class="Text">历史</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_SUBMITED %>" target="PageFrame">
                                                        <span class="Text">已提交工时表</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVED_REPORT %>" target="PageFrame">
                                                        <span class="Text">已审批费用报表</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">报表</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--第八个--> 
                                <%if (CheckAuth("MENU_INVENTORY")) { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">库存</div>
                                                </div>
                                                <%if (CheckAuth("MENU_INVENTORY_ITEM")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVENTORY_ITEM %>" target="PageFrame">
                                                        <span class="Text">库存产品管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_TRANSFER")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVENTORY_TRANSFER %>" target="PageFrame">
                                                        <span class="Text">库存转移和更新</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_LOCATION")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVENTORY_LOCATION %>" target="PageFrame">
                                                        <span class="Text">仓库管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PRODUCT")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT %>" target="PageFrame">
                                                        <span class="Text">产品管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">采购与交付</div>
                                                </div>
                                                <%if (CheckAuth("MENU_INVENTORY_PURCHASE_APPROVAL")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_APPROVAL %>&isCheck=1" target="PageFrame">
                                                        <span class="Text">采购审批</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PURCHASING")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASING_FULFILLMENT %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">待采购产品管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PURCHASE_ORDER")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ORDER %>" target="PageFrame"> 
                                                        <span class="Text">采购订单管理</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_RECEIVE")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_RECEIVE %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">采购接收</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_SHIPPINT_LIST")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SHIPPING_LIST %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">配送</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_SHIPED_LIST")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SHIPED_LIST %>&isCheck=1" target="PageFrame"> 
                                                        <span class="Text">已配送</span>
													                          </a>
                                                </div>
                                                <%} %>
                                                <%if (CheckAuth("MENU_INVENTORY_PUCHASE_ORDER_LIST")) { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ORDER_HISTORY %>" target="PageFrame"> 
                                                        <span class="Text">采购订单历史</span>
                                                    </a>
                                                </div>
                                                <%} %>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                                <!--第九个-->
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">报表种类</div>
                                                </div>
                                               
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage" target="PageFrame">
                                                        <span class="Text">CRM</span>
                                                    </a>
                                                </div>
                                               <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=Project" target="PageFrame">
                                                        <span class="Text">项目</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=ServiceDesk" target="PageFrame">
                                                        <span class="Text">服务台</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=ContractBill" target="PageFrame">
                                                        <span class="Text">合同计费</span>
                                                    </a>
                                                </div>
                                               <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Reports/ReportHomePage?SearchType=Other" target="PageFrame">
                                                        <span class="Text">其他</span>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">搜索</div>
                                                </div>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">工具</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--第10个-->
                                <div class="Module">
                                    
                                
                                </div>
                                <!--第11个-->
                                <%if (CheckAuth("MENU_SETTING"))
                                { %>
                                <div class="Module">
                                    <div class="Normal ContextOverlayColumn">
                                        <div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">视图</div>
                                                </div>
                                                <%if (CheckAuth("MENU_SETTING_SETTING"))
                                                { %>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="SysSetting/Admin" target="PageFrame">
                                                        <span class="Text">设置</span>
                                                    </a>
                                                </div>
                                                <%}%>
                                            </div>
                                            <div class="Group">
                                                <div class="Heading">
                                                    <div class="Text">常用</div>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE %>" target="PageFrame">
                                                        <span class="Text">员工(用户)</span>
                                                    </a>
                                                </div>
                                                <div class="Content">
                                                    <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.WORKFLOW_RULE %>" target="PageFrame">
                                                        <span class="Text">工作流规则</span>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%}%>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--搜索的下拉菜单-->
            <div class="ContextOverlayContainer">
                <div class="SearchOverlay ContextOverlay" style="left: 77px; top: 39px;">
                    <div class="Content">
                        <div class="ColumnSet">
                            <div class="Normal ContextOverlayColumn">
                                <div>
                                    <div class="Group">
                                        <div class="Content">
                                            <div class="SearchRadioButton">
                                                <input checked="checked" type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="Company" />
                                                <label>客户</label>
                                            </div>
                                            <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="ContactName" />
                                                <label>联系人姓名</label>
                                            </div>
                                            <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="ContactEmail" />
                                                <label>联系人邮箱</label>
                                            </div>
                                            <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="TicketNo" />
                                                <label>工单编号</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="TicketIn24" />
                                                <label>工单(24个月内创建)</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="Project" />
                                                <label>项目</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="TaskNo" />
                                                <label>任务编号</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="InsPro" />
                                                <label>配置项</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="InsProUdf" />
                                                <label>配置项（包括自定义字段）</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="OpportunityName" />
                                                <label>商机名称</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="QuoteName" />
                                                <label>报价名称</label>
                                            </div>
                                            <%-- <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="HelpOnLine" />
                                                <label>在线帮助</label>
                                            </div>--%>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="Knowledge" />
                                                <label>知识库</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="Community" />
                                                <label>社区</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="InvoiceNo" />
                                                <label>发票编号</label>
                                            </div>
                                             <div class="SearchRadioButton">
                                                <input type="radio" class="QuickSearch" name="SearchTypeRadioButton" style="margin-top:5px;" value="InvoiceId" />
                                                <label>发票ID</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <div class="Normal ContextOverlayColumn">
                                    <div>
                                        <div class="Group">
                                            <div class="Heading" id="SearchHisDiv">
                                                <div class="Text">历史纪录搜索</div>
                                            </div>
                                         
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--新增的下拉菜单-->
            <div class="ContextOverlayContainer">
                <div class="NewOverlay ContextOverlay" style="left: 318px; top: 39px;">
                    <div class="Content">
                        <div class="Title">新增...</div>
                        <div class="ColumnSet">
                            <div class="Normal ContextOverlayColumn">
                                <div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">服务台</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('ticket')">
                                                <span class="Text">工单</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('masterTicket')">
                                                <span class="Text">定期服务工单</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('serviceCall')">
                                                <span class="Text">服务预定</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('knowledge')">
                                                <span class="Text">知识库文档</span>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">CRM</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('account')">
                                                <span class="Text">客户</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('contact')">
                                                <span class="Text">联系人</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('opportunity')">
                                                <span class="Text">商机</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('quote')">
                                                <span class="Text">报价</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('todo')">
                                                <span class="Text">待办</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('appoint')">
                                                <span class="Text">约会</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('note')">
                                                <span class="Text">备注</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal ContextOverlayColumn">
                                <div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">工时表</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('taskLabour')">
                                                <span class="Text">项目任务工时</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('generalLabour')">
                                                <span class="Text">常规工时</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('leaveRequest')">
                                                <span class="Text">请假申请</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('costReport')">
                                                <span class="Text">费用报表</span>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">合同</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('serviceContract')">
                                                <span class="Text">定期服务合同</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('timeMaterialsContract')">
                                                <span class="Text">工时和物料合同</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('fixedPriceContract')">
                                                <span class="Text">固定价格合同</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('retainerContract')">
                                                <span class="Text">预付费用合同</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('blockHoursContract')">
                                                <span class="Text">预付时间合同</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('perTicketContract')">
                                                <span class="Text">预付工单合同</span>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">项目</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('project')">
                                                <span class="Text">项目</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('projectFromTemp')">
                                                <span class="Text">从模板中新增项目</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('yuan')">
                                                <span class="Text">预案</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" onclick="AddObject('projectTemp')">
                                                <span class="Text">项目模板</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--我的下拉菜单-->
            <div class="ContextOverlayContainer">
                <div class="MyOverlay ContextOverlay" style="left: 355px; top: 39px;">
                    <div class="Content">
                        <div class="Title">我的...</div>
                        <div class="ColumnSet">
                            <div class="Normal ContextOverlayColumn">
                                <div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">服务台</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET %>" target="PageFrame">
                                                <span class="Text">任务和工单(<%=searchCountDic["myTaskTicket"] %>)</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="ServiceDesk/MyQueueList.aspx" target="PageFrame">
                                                <span class="Text">我的工作区和队列</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=215&isCheck=1" target="PageFrame">
                                                <span class="Text">我的处理中工单(<%=searchCountDic["activeTicket"] %>)</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=230&param1=2733&param2=2&isCheck=1" target="PageFrame">
                                                <span class="Text">我的过期工单(<%=searchCountDic["overTicket"] %>)</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_MY_TICKET %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_MY_TICKET %>&isCheck=1" target="PageFrame">
                                                <span class="Text">我创建的工单(<%=searchCountDic["myTicket"] %>)</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET %>" target="PageFrame">
                                                <span class="Text">我的客户的工单</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_ACTIVE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_ACTIVE %>&group=230&param1=2733&param2=3&isCheck=1&" target="PageFrame">
                                                <span class="Text">我的已关闭工单</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALL_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.SERVICE_CALL_SEARCH %>&param1=1" target="PageFrame">
                                                <span class="Text">我的服务预定(<%=searchCountDic["myCall"] %>)</span>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">CRM</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>" target="PageFrame">
                                                <span class="Text">我的客户(<%=searchCountDic["MyAccount"] %>)</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT %>&param1=2755&param2=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的联系人(<%=searchCountDic["MyContact"] %>)</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITY %>&param1=274&param2=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的商机(<%=searchCountDic["MyOpportunity"] %>)</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState">
                                                <span class="Text">我的过期商机</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SALEORDER %>&param1=2756&param2=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的销售订单(<%=searchCountDic["MySale"] %>)</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.QUOTE %>&param1=2759&param2=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的报价(<%=searchCountDic["MyQuote"] %>)</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CRM_NOTE_SEARCH %>&param1=649&param2=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的备注(<%=searchCountDic["MyNote"] %>)</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TODOS %>&param1=662&param2=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的待办(<%=searchCountDic["MyTodo"] %>)</span>
                                            </a>
                                        </div>
                                    </div>
                                     <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">工时表</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_MY_CURRENT %>&con2735=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的当前工时表</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_MY_REQUEST %>&con2743=<%=LoginUserId %>" target="PageFrame">
                                                <span class="Text">我的休假申请(<%=searchCountDic["RequestCount"] %>)</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="TimeSheet/MyTimeSummary" target="PageFrame">
                                                <span class="Text">我的休假汇总</span>
                                            </a>
                                        </div>
                                          <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.EXPENSE_REPORT %>" target="PageFrame">
                                                <span class="Text">我的费用报表</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal ContextOverlayColumn">
                                <div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">等待我审批</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_WAIT_APPROVE %>&isCheck=1" target="PageFrame">
                                                <span class="Text">工时表(<%=searchCountDic["waitLabour"] %>)</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_REQUEST_WAIT_APPROVE %>&isCheck=1" target="PageFrame">
                                                <span class="Text">休假申请(<%=searchCountDic["waitRequest"] %>)</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MYAPPROVE_EXPENSE_REPORT %>&isCheck=1" target="PageFrame">
                                                <span class="Text">费用报表(<%=searchCountDic["waitExpense"] %>)</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState" href="../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_QUEUE_CHANGE_APPROVEL %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.MY_QUEUE_CHANGE_APPROVEL %>&param1=1" target="PageFrame">
                                                <span class="Text">变更申请(<%=searchCountDic["waitChange"] %>)</span>
                                            </a>
                                        </div>
                                    </div>
                                    <div class="Group">
                                        <div class="Heading">
                                            <div class="Text">其他</div>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState">
                                                <span class="Text">项目</span>
                                            </a>
                                        </div>
                                        <div class="Content">
                                            <a class="Button ButtonIcon NormalState">
                                                <span class="Text">日历</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState">
                                                <span class="Text">自定义模板</span>
                                            </a>
                                        </div>
                                         <div class="Content">
                                            <a class="Button ButtonIcon NormalState">
                                                <span class="Text">个人信息</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--历史纪录的下拉菜单-->
            <div class="ContextOverlayContainer">
                <div class="RecentOverlay ContextOverlay" style="left: 390px; top: 39px;">
                    <div class="Content">
                        <div class="Title">历史</div>
                        <div class="RecentItemsContainer">
                            <div class="ColumnSet">
                                <div class="Large ContextOverlayColumn">
                                    <div>
                                        <div class="Group" id="BrowerHistoryDiv">
                                         
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="SiteNavigationFooterSeparator"></div>
                            <div class="ColumnSet">
                                <div class="Normal ContextOverlayColumn">
                                    <div>
                                        <div class="Group">
                                            <div class="Content">
                                                <a class="Button ButtonIcon Link NormalState" onclick="ClearBrowerHistory()">清除
                                                </a>
                                            </div>
                                            
                                            <div class="Content" id="ShowHistoryFifty" style="display:none;">
                                                <a class="Button ButtonIcon Link NormalState" onclick="ShowMoreHistory()">查看更多
                                                </a>
                                            </div>
                                           
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
             <!--书签的下拉菜单-->
            <div class="ContextOverlayContainer">
                <div class="BookmarkDiv ContextOverlay" style="left: 426px; top: 39px;">
                    <div class="Content">
                        <div class="Title">书签</div>
                        <div class="RecentItemsContainer">
                            <div class="ColumnSet">
                                <div class="Large ContextOverlayColumn">
                                    <div>
                                        <div class="Group" id="BookDropListDiv">
                                         
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="SiteNavigationFooterSeparator"></div>
                            <div class="ColumnSet">
                                <div class="Normal ContextOverlayColumn">
                                    <div>
                                        <div class="Group">
                                            <div class="Content" id="ManageBookDiv">
                                                <a class="Button ButtonIcon Link NormalState" onclick="ShowManageBook()">管理书签
                                                </a>
                                            </div>
                                           
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Right">
            <div class="User">
                <div class="Name">
                    <a class="Button ButtonIcon Link"><%=LoginUser.name %></a>
                </div>
                <div class="Separator">
                    <div class="VerticalBar"></div>
                </div>
                <div class="SignOut">
                    <a class="Button ButtonIcon Link" onclick="javaScript:window.location.href='login?action=Logout'">退出</a>
                </div>
            </div>
            <!--右边的三个图标-->
            <div class="ButtonGroup clear">
                <div class="LiveLinks Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
                <div class="Community Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
                <div class="Help Button ButtonIcon PrimaryActionEnabled">
                    <div class="Icon"></div>
                </div>
            </div>
        </div>
    </div>

     <div id="BackgroundOverLay"></div>
    <% if (isFromLogin && notList != null && notList.Count > 0)
        {
            var noUrlNotList = notList.Where(_ => string.IsNullOrEmpty(_.url)).ToList();
            var urlNotList = notList.Where(_ => !string.IsNullOrEmpty(_.url)).ToList();
            int navNum = 1;
            foreach (var notice in noUrlNotList)
            {
                navNum++;
                %>
     <div class="Dialog Notice Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; width: 400px; height: 400px;" id="Nav<%=navNum %>">
        <div class="CancelDialogButton" onclick="CancelDialog('Nav<%=navNum %>')"></div>
        <div class="heard-title" style="height: 30px;"><%=notice.title %></div>
        <div style="margin:10px;height:300px;"><%=notice.description %></div>
         <div style="margin-left:10px;">
             <p><span style="display:inline-block;"><input type="checkbox" class="AlertNext" value="<%=notice.id %>"/></span><span>下次提醒我</span></p>
         </div>
    </div>
    <%
        }
        foreach (var notice in urlNotList)
        {
            navNum++;
                %>
     <div class="Dialog Notice Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; width: 400px; height: 400px;" id="Nav<%=navNum %>">
        <div class="CancelDialogButton" onclick="CancelDialog('Nav<%=navNum %>')"></div>
        <div class="heard-title" style="height: 30px;"><%=notice.title %></div>
        <div style="margin:10px;height:300px;"><iframe id="NavFrame<%=navNum %>" name="NavFrame<%=navNum %>" style="width: 100%;" src="<%=notice.url+((notice.url.Contains('?')?"":"?")+$"&Nav=Nav"+navNum.ToString()) %>"></iframe></div>
         <div style="margin-left:10px;">
             <p><span style="display:inline-block;"><input type="checkbox" class="AlertNext" value="<%=notice.id %>"/></span><span>下次提醒我</span></p>
         </div>
    </div>
    <% }
            } %>

      <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; width: 400px; height: 400px;" id="NoticeHistory">
           <div class="CancelDialogButton" onclick="CancelSingleDialog('NoticeHistory')"></div>
           <div class="heard-title" style="height: 30px;">更多的浏览历史</div>
          <div class="DialogHeadingContainer">
              <div class="ButtonContainer"><a class="Button ButtonIcon NormalState" id="ClearButton" tabindex="0" onclick="ClearBrowerHistory()">
                  <span class="Icon"></span><span class="Text">清除</span></a></div><div class="Instructions" style="padding-left:10px;">
                      <div class="InstructionItem">下面是你最近浏览的部分页面。你可以通过点击链接回到这些页面。</div>
                </div>
          </div>
          <div class="ScrollingContentContainer">
              <div class="ScrollingContainer" style="padding-left: 12px;overflow-x: auto;overflow-y: auto;height: 210px;">
                  <div class="Normal NoHeading Section">
                      <div class="Content">
                          <div class="Large Column">
                              <div class="PageNavigationLinkGroup">
                                  <div class="PageNavigationLinkColumn Large" id="MoreHistoryDiv">

                                    </div>
                              </div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
    <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; width: 400px; height: 400px;" id="BookManageNav">
           <div class="CancelDialogButton" onclick="CancelSingleDialog('BookManageNav')"></div>
           <div class="heard-title" style="height: 30px;">书签</div>
          <div class="DialogHeadingContainer">
              <div class="ButtonContainer">
                  <a class="Button ButtonIcon NormalState" tabindex="0" onclick="DeleteChooseBook()">
                  <span class="Icon"></span><span class="Text">删除选中</span></a>
                  <a class="Button ButtonIcon NormalState" tabindex="0" onclick="DeleteAllBook()">
                  <span class="Icon"></span><span class="Text">删除全部</span></a>
              </div>
          </div>
          <div class="ScrollingContentContainer">
              <div class="ScrollingContainer" style="padding-left: 12px;overflow-x: auto;overflow-y: auto;height: 210px;">
                  <div class="Normal NoHeading Section">
                      <div class="Content">
                          <div class="Large Column">
                              <div class="PageNavigationLinkGroup">
                                  <div class="PageNavigationLinkColumn Large" id="MoreBookDiv">

                                    </div>
                              </div>
                          </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>

    <!--背景布-->
    <div id="WorkspaceContainer">
        <div id="yibiaopan" >
          <img src="Images/background.jpg" style="width:100%;height:100%;" />
            <div id="DashboardContainer" style="display:none;">
                <div class="DashboardTitleBar ThemePrimaryColor">
                    <div class="DashboardButtonContainer">
                        <div class="DashboardTabButtonContainer">
                            <div class="ButtonIcon Button SelectDashboardTab SelectedState">仪表盘1</div>
                            <div class="ButtonIcon Button SelectDashboardTab">仪表盘2</div>
                            <div class="ButtonIcon Button SelectDashboardTab">仪表盘3</div>
                            <div class="ButtonIcon Button SelectDashboardTab">仪表盘4</div>
                            <div class="ButtonIcon Button SelectDashboardTab">仪表盘5</div>
                            <div class="ButtonIcon Button SelectDashboardTab">仪表盘6</div>
                        </div>
                        <div class="ButtonIcon Button CreateDashboardTab">
                            <div class="HorizontalLine"></div>
                            <div class="VerticalLine"></div>
                        </div>
                    </div>
                    <div class="DashboardContextMenuContainer"></div>
                </div>
                <div class="DashboardTabContainer" id="DashboardTabContainer">
                    <div class="ContentContainer">
                        <div id="DashboardTabContainerContent">
                            <div class="LivelyTheme AutoFlow DashboardTab">
                                暂无（以后开发）
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="cont" style="display: none;">
        <div class="header" id="SearchTitle" style="display:none;height: 40px;line-height: 40px;background: #346A95;padding: 0 10px;font-size: 18px;color: #FFFFFF;"></div>
        <iframe id="PageFrame" name="PageFrame" style="width: 100%;"></iframe>
    </div>
</body>
<script src="Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
<script src="Scripts/common.js"></script>
<script>
    $(window).resize(function () {
        var Height = $(window).height() - 66 + "px";
        $("#PageFrame").css("height", Height);
    })
    var Height = $(window).height() - 66 + "px";
    $("#PageFrame").css("height", Height);
    LoadHistory();
    LoadBrowerHistory();
    LoadBook();
    // 搜索相关
    $("#QuickSearchPage").click(function () {
        var searchText = $("#SearchText").val();
        if (searchText == "" || $.trim(searchText) == "") {
            alert("请输入搜索内容！");
            return;
        }
        var searchType = $('input[type=radio]:checked').eq(0).val();
        var searchTypeName = $('input[type=radio]:checked').eq(0).next().text();
        // todo 新增查询历史
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=SearchHistoryManage&searchText=" + searchText + "&searchType=" + searchType + "&searchTypeName=" + searchTypeName + "&url=<%=Request.Url.LocalPath %>",
            dataType: "json",
            success: function (data) {
               
               
            },
        });
        
        SearchByNameType(searchText, searchType);
    })
    function SearchByHistory(historyId, text, type) {
        if (historyId == "") {
            return;
        }
        // todo 更新查询的 update_time
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=SearchHistoryManage&id=" + historyId ,
            dataType: "json",
            success: function (data) {


            },
        });
        $("#SearchText").val(text);
        // todo radio 赋值
        $("input[name='SearchTypeRadioButton'][value=" + type + "]").prop("checked", true); 
        SearchByNameType(text, type);
    }

    function LoadHistory()
    {
        var url = '<%=Request.Url.LocalPath %>';
        $("#SearchHisDiv").nextAll().remove();
        var html = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=LoadSearchHistory&url=" + url,
            dataType: "json",
            success: function (data) {
                if (data != null) {
                    for (var i = 0; i < data.length; i++) {
                        //var obj = data[i].conditions.parseJSON();
                        var obj = JSON.parse(data[i].conditions);
                        html += "<div class='Content'><a class='Button ButtonIcon NormalState' onclick=\"SearchByHistory('" + data[i].id + "','" + obj.Condition + "','" + obj.SearchType + "')\"><span class='Text'>" + obj.Condition + "(" + obj.Name+")</span></a></div>";
                    }
                }
            },
        });
        $("#SearchHisDiv").after(html);
    }

    function SearchByNameType(text, type) {
        setTimeout(function () { LoadHistory(); }, 300);
       
        if (text == "" || type == "") {
            return;
        }
        
        $("#SearchTitle").show();
        $("#SearchTitle").text("");
        setTimeout(function () {
            $(".cont").show();
            $(".SearchOverlay").hide();
        }, 300);
        setTimeout(function () {
            $("#yibiaopan").hide();
        }, 100);
        var url = "";
        var title = "";
        if (type == "Company")
        {
            title = "客户";
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Company %>&group=4&con5=" + text;
        }
        else if (type == "ContactName")
        {
            title = "联系人";
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Contact %>&group=5&con30=" + text;
        }
        else if (type == "ContactEmail")
        {
            title = "联系人";
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Contact %>&group=5&con33=" + text;
        }
        else if (type == "TicketNo")
        {
            $("#SearchTitle").hide();
            url = "Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_SEARCH %>&param1=1611&param2=" + text + "&param3=SearchNow";
        }
        else if (type == "TicketIn24")
        {
            $("#SearchTitle").hide();
            url = "Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_SEARCH %>&param1=1630&param2=<%=DateTime.Now.AddYears(-2).ToString("yyyy-MM-dd") %>&param3=SearchNow";
        }
        else if (type == "Project")
        {
            title = "项目";
            url = "Project/ProjectSearchResult.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_SEARCH %>&param1=2749&param2=" + text;
        }
        else if (type == "TaskNo")
        {
            title = "任务编号";
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TASK_SEARCH_NO %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TASK_SEARCH_NO %>&con2754=" + text;
        }
        else if (type == "InsPro")
        {
            $("#SearchTitle").hide();
            url = "Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSTALLEDPRODUCT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.InstalledProductView %>&param1=2750&param2=" + text +"&isShow=Search";
        }
        else if (type == "InsProUdf")
        {
            $("#SearchTitle").hide();
            url = "Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INSTALLEDPRODUCT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.InstalledProductView %>&param1=2750&param2=" + text + "&isShow=Search";
        }
        else if (type == "OpportunityName")
        {
            $("#SearchTitle").hide();
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.OPPORTUNITY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Opportunity %>&group=9&con261=" + text;
        }
        else if (type == "QuoteName")
        {
            title = "报价名称";
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Company %>&group=4&con5=" + text;
        }
      
        else if (type == "Knowledge")
        {
            title = "知识库";
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.KNOWLEDGEBASE_ARTICLE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.KnowledgebaseArticle %>&param1=2751&param2=" + text ;
        }
        else if (type == "Community")
        {
            title = "社区";
            url = "";
        }
        else if (type == "InvoiceNo")
        {
            $("#SearchTitle").hide();
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_HISTORY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Invoice_History %>&param1=2752&param2=" + text;
        }
        else if (type == "InvoiceId")
        {
            $("#SearchTitle").hide();
            url = "Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.INVOICE_HISTORY %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.Invoice_History %>&param1=2753&param2=" + text;
        }
        else {
            return;
        } 
        $("#SearchTitle").text(title);
        $("#PageFrame").attr("src", url);
    }
    <%if (isFromLogin && notList != null && notList.Count > 0)
    { %>
    $(".Notice").show();
    $("#BackgroundOverLay").show();
    <%}%>

    // 关闭弹窗
    function CancelDialog(navId) {
        $("#" + navId).hide();
        var allLength = $(".Notice").length;
        var hiddenLength = $(".Notice:hidden").length;
        if (allLength == hiddenLength) {
            $("#BackgroundOverLay").hide();
        }
    }
    function CancelSingleDialog(navId) {
        $("#" + navId).hide();
        $("#BackgroundOverLay").hide();
    }
    // 下次提醒我
    $(".AlertNext").click(function () {
        var isAlert = "";
        var thisValue = $(this).val();
        if ($(this).is(":checked")) {
            isAlert = "1";
        }
        else {
            isAlert = "0";
        }
        if (thisValue != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/IndexAjax.ashx?act=ChangeNoticeNext&id=" + thisValue + "&isAlert=" + isAlert,
                dataType: "json",
                success: function (data) {
                    
                },
            });
        }

    })

    function AddObject(objectType) {
        if (objectType == "ticket") {
            window.open('../ServiceDesk/TicketManage', windowType.ticket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
        }
        else if (objectType == "masterTicket") {
            window.open("../ServiceDesk/MasterTicket", windowType.masterTicket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
        }
        else if (objectType == "serviceCall") {
            window.open("../ServiceDesk/ServiceCall", windowType.serviceCall + windowType.add, 'left=200,top=200,width=1280,height=800', false);
        }
        else if (objectType == "knowledge") {
            window.open("../ServiceDesk/AddRepository.aspx", "_blank", "toolbar=yes, location=yes, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=no, copyhistory=yes, width=800,height=700");
        }
        else if (objectType == "account") {
            window.open("../Company/AddCompany.aspx", windowObj.company + windowType.add, 'left=0,top=0,width=900,height=750,resizable=yes', false);
        }
        else if (objectType == "contact") {
            window.open("../Contact/AddContact.aspx", windowObj.contact + windowType.add, 'left=0,top=0,width=900,height=750,resizable=yes', false);
        }
        else if (objectType == "opportunity") {
            window.open("../Opportunity/OpportunityAddAndEdit.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>', 'left=0,top=0,width=900,height=750,resizable=yes', false);
        }
        else if (objectType == "quote") {
            window.open("../Quote/QuoteAddAndUpdate.aspx", windowObj.quote + windowType.add, 'left=0,top=0,width=900,height=750,resizable=yes', false);
        }
        else if (objectType == "todo") {
            window.open("../Activity/Todos.aspx", windowObj.todos + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
        }
        else if (objectType == "appoint") {
            window.open("../ServiceDesk/AppointmentsManage.aspx", windowObj.appointment + windowType.add, 'left=200,top=200,width=600,height=800', false);
        }
        else if (objectType == "note") {
            window.open("../Activity/Notes.aspx", windowObj.notes + windowType.add, 'left=0,top=0,location=no,status=no,width=730,height=750', false);
        }
        else if (objectType == "taskLabour") {
            window.open("../Project/WorkEntry.aspx", windowObj.workEntry + windowType.add, 'left=200,top=200,width=1080,height=800', false);
        }
        else if (objectType == "generalLabour") {
            window.open("../TimeSheet/RegularTimeAddEdit.aspx", windowObj.workEntry + windowType.add, 'left=0,top=0,location=no,status=no,width=1080,height=750', false);
        }
        else if (objectType == "leaveRequest") {
            window.open("../TimeSheet/TimeoffRequestAdd.aspx", windowObj.timeoffRequest + windowType.add, 'left=0,top=0,location=no,status=no,width=850,height=750', false);
        }
        else if (objectType == "costReport") {
            window.open("../Project/ExpenseReportManage.aspx", windowObj.expenseReport + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=250', false);
        }
        else if (objectType == "serviceContract") {
            window.open("../Contract/ContractAdd.aspx?type=<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.SERVICE %>", windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "timeMaterialsContract") {
            window.open("../Contract/ContractAdd.aspx?type=<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.TIME_MATERIALS %>", windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "fixedPriceContract") {
            window.open("../Contract/ContractAdd.aspx?type=<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.FIXED_PRICE %>", windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "retainerContract") {
            window.open("../Contract/ContractAdd.aspx?type=<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER %>", windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "blockHoursContract") {
            window.open("../Contract/ContractAdd.aspx?type=<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS %>", windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "perTicketContract") {
            window.open("../Contract/ContractAdd.aspx?type=<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.PER_TICKET %>", windowObj.contract + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "project") {
            window.open("../Project/ProjectAddOrEdit?type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT %>", windowObj.project + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "projectFromTemp") {
            window.open("../Project/ProjectAddOrEdit?type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT %>&isFromTemp=1" , windowObj.project + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "yuan") {
            window.open("../Project/ProjectAddOrEdit?type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.PROJECT_DAY %>", windowObj.project + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        else if (objectType == "projectTemp") {
            window.open("../Project/ProjectAddOrEdit?isTemp=1", windowObj.project + windowType.add, 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        // 
    }
    // 清除浏览记录
    function ClearBrowerHistory() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=ClearHistory",
            dataType: "json",
            success: function (data) {
                if (data) {
                    $("#BrowerHistoryDiv").html("");
                }
            },
        });
    }
    // 
    function ShowMoreHistory() {
        var browerHistoryTwtenHtml = "";
        
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=LoadBrowerHistory",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    for (var i = 0; i < data.length; i++) {
                        var title = data[i].title;
                        if (data[i].title.length >= 30) {
                            title = data[i].title.substring(0, 30) + "...";
                        }
                        browerHistoryTwtenHtml += "<div class='PageNavigationLink'><a class='Button ButtonIcon Link NormalState HistoryClick'  onclick=\"window.open('" + data[i].url + "', '_blank', 'left=0,top=0,location=no,status=no,width=1280,height=750', false)\">" + title + "</a><span></span></div>";
                    }
                   
                }
            },
        });
        $("#MoreHistoryDiv").html(browerHistoryTwtenHtml);
        $(".HistoryClick").click(function () {
            setTimeout(function () { LoadBrowerHistory(); }, 2000)
        })
        $("#BackgroundOverLay").show();
        $("#NoticeHistory").show();
    }

    function LoadBrowerHistory() {
        var browerHistoryTwtenHtml = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=LoadBrowerHistory",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    var length = data.length;
                    if (data.length >= 20) {
                        length = 20;
                        $("#ShowHistoryFifty").show();
                    }
                    else {
                        $("#ShowHistoryFifty").hide();
                    }
                    for (var i = 0; i < length; i++) {
                        var title = data[i].title;
                        if (data[i].title.length >= 30) {
                            title = data[i].title.substring(0,30)+"...";
                        }
                        browerHistoryTwtenHtml += " <div class='Content'><a class='Button ButtonIcon NormalState HistoryClick' onclick=\"window.open('" + data[i].url + "', '_blank', 'left=0,top=0,location=no,status=no,width=900,height=750', false)\"><span class='Text'>" + title + "</span></a></div>";
                    }

                } else {
                    $("#ShowHistoryFifty").hide();
                }
            },
        });
        $("#BrowerHistoryDiv").html(browerHistoryTwtenHtml);
        $(".HistoryClick").click(function () {
            setTimeout(function () { LoadBrowerHistory(); }, 2000)
        })
    }
    $(".HistoryClick").click(function () {
        setTimeout(function () { LoadBrowerHistory();},2000)
    })

    function ShowManageBook() {
        var bookHtml = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=LoadBook",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    for (var i = 0; i < data.length; i++) {
                        bookHtml += "<div class='PageNavigationLink'><p><span style='display:inline-block'><input type='checkbox' value='" + data[i].id + "' class='CkBookMark'  /><span><span><a class='Button ButtonIcon Link NormalState'>" + data[i].title + "</a></span><p></div>";
                    }
                }
            },
        });
        $("#MoreBookDiv").html(bookHtml);
        $("#BackgroundOverLay").show();
        $("#BookManageNav").show();
    }

    function LoadBook() {
        var bookHtml = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=LoadBook",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    for (var i = 0; i < data.length; i++) {
                        bookHtml += " <div class='Content'><a class='Button ButtonIcon NormalState' onclick=\"window.open('" + data[i].url + "', '_blank', 'left=0,top=0,location=no,status=no,width=900,height=750', false)\"><span class='Text'>" + data[i].title + "</span></a></div>";
                    }

                }
            },
        });
        $("#BookDropListDiv").html(bookHtml);
    }
    function DeleteChooseBook() {
        LayerConfirm("该删除不可恢复，是否继续？", "是", "否", function () {
            var ids = "";
            $(".CkBookMark").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ",";
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/IndexAjax.ashx?act=DeleteChooseBook&ids="+ids,
                    dataType: "json",
                    success: function (data) {
                        if (data) {


                        }
                    },
                });   
            }
            LoadBook();
            $("#BackgroundOverLay").hide();
            $("#BookManageNav").hide();
        });
       

    }
    function DeleteAllBook() {
        LayerConfirm("该删除不可恢复，是否继续？", "是", "否", function () {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/IndexAjax.ashx?act=DeleteAllBook",
                dataType: "json",
                success: function (data) {
                    if (data) {
                       

                    }
                },
            });
            LoadBook();
            $("#BackgroundOverLay").hide();
            $("#BookManageNav").hide();
        });
    }
</script>
</html>

