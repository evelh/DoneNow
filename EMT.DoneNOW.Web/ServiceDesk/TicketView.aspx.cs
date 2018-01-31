﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class TicketView : BasePage
    {
        protected sdk_task thisTicket = null;                // 当前工单
        protected bool isAdd = true;                         // 新增还是编辑
        protected crm_account thisAccount = null;            // 工单的客户
        protected crm_contact thisContact = null;            // 工单的联系人
        protected sys_resource priRes = null;                // 工单的主负责人
        protected sys_resource createRes = null;             // 工单的创建人
        protected crm_opportunity thisOppo = null;           // 工单的商机
        protected sys_resource_department proResDep = null;  // 工单的主负责人
        protected crm_installed_product insPro = null;       // 工单的配置项
        protected ctt_contract thisContract = null;          // 工单的合同
        protected ivt_service thisService = null;            // 工单的服务
        protected ivt_service_bundle thisServiceBun = null;  // 工单的服务包
        protected d_cost_code thisCostCode = null;           //  工单的工作类型
        protected List<d_sla> slaList = new d_sla_dal().GetList();
        protected List<d_general> ticStaList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_STATUS);          // 工单状态集合
        protected List<d_general> priorityList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_PRIORITY_TYPE);   // 工单优先级集合
        protected List<d_general> issueTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_ISSUE_TYPE);     // 工单问题类型
        protected List<d_general> sourceTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TASK_SOURCE_TYPES);     // 工单来源
        protected List<d_general> ticketCateList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_CATE);     // 工单种类
        protected List<d_general> ticketTypeList = new d_general_dal().GetGeneralByTableId((long)GeneralTableEnum.TICKET_TYPE);     // 工单类型
        protected List<sys_department> depList = new sys_department_dal().GetDepartment("", (int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE);
        protected List<sys_resource_department> ticketResList = null;  // 工单的员工
        protected List<UserDefinedFieldDto> tickUdfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);
        protected List<UserDefinedFieldValue> ticketUdfValueList = null;
        protected List<sdk_task_checklist> ticketCheckList = null;   // 工单的检查单集合
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var taskId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(taskId))
                {
                    thisTicket = new sdk_task_dal().FindNoDeleteById(long.Parse(taskId));
                    if (thisTicket != null)
                    {
                        isAdd = false;
                        
                        ticketUdfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.TASK, thisTicket.id, tickUdfList);
                        thisAccount = new CompanyBLL().GetCompany(thisTicket.account_id);
                        if (thisTicket.contact_id != null)
                        {
                            thisContact = new crm_contact_dal().FindNoDeleteById((long)thisTicket.contact_id);
                        }

                        if (thisTicket.owner_resource_id != null && thisTicket.role_id != null)
                        {

                            var resDepList = new sys_resource_department_dal().GetResDepByResAndRole((long)thisTicket.owner_resource_id, (long)thisTicket.role_id);
                            if (resDepList != null && resDepList.Count > 0)
                            {
                                proResDep = resDepList[0];
                                priRes = new sys_resource_dal().FindNoDeleteById((long)thisTicket.owner_resource_id);
                            }
                        }

                        if (thisTicket.installed_product_id != null)
                        {
                            insPro = new crm_installed_product_dal().FindNoDeleteById((long)thisTicket.installed_product_id);
                        }

                        if (thisTicket.contract_id != null)
                        {
                            thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisTicket.contract_id);
                        }

                        if (thisTicket.cost_code_id != null)
                        {
                            thisCostCode = new d_cost_code_dal().FindNoDeleteById((long)thisTicket.cost_code_id);
                        }
                        ticketCheckList = new sdk_task_checklist_dal().GetCheckByTask(thisTicket.id);
                        if (ticketCheckList != null && ticketCheckList.Count > 0)
                        {
                            ticketCheckList = ticketCheckList.OrderBy(_ => _.sort_order).ToList();
                        }
                        var otherResList = new sdk_task_resource_dal().GetTaskResByTaskId(thisTicket.id);
                        if(otherResList!=null&& otherResList.Count > 0)
                        {
                            ticketResList = new List<sys_resource_department>();
                            var srdDal = new sys_resource_department_dal();
                            foreach (var resRole in otherResList)
                            {
                                if (resRole.resource_id == null || resRole.role_id == null)
                                    continue;
                                var thisResDep = srdDal.GetResDepByResAndRole((long)resRole.resource_id,(long)resRole.role_id);
                                if(thisResDep!=null&& thisResDep.Count > 0)
                                {
                                    ticketResList.Add(thisResDep[0]);
                                }
                            }
                        }

                        if (thisTicket.service_id != null)
                        {
                            thisService = new ivt_service_dal().FindNoDeleteById((long)thisTicket.service_id);
                            if (thisService == null)
                            {
                                thisServiceBun = new ivt_service_bundle_dal().FindNoDeleteById((long)thisTicket.service_id);
                            }
                        }
                        createRes = new sys_resource_dal().FindNoDeleteById(thisTicket.create_user_id);
                    }
                }
            }
            catch (Exception msg)
            {

                Response.Write("<script>alert('" + msg.Message + "');window.close();</script>");
            }
        }
        
        /// <summary>
        /// 获取到两个时间之间相差的时分秒
        /// </summary>
        protected string GetDiffDate(DateTime startDate,DateTime endDate)
        {
            TimeSpan ts1 = new TimeSpan(startDate.Ticks);
            TimeSpan ts2 = new TimeSpan(endDate.Ticks);
            TimeSpan ts = ts1.Subtract(ts2).Duration();
            string diffString = "（";
            if (ts.Days > 0)
            {
                diffString += ts.Days.ToString()+ "天";
            }
            if (ts.Hours > 0)
            {
                diffString += ts.Hours.ToString() + "小时";
            }
            diffString += ts.Minutes.ToString() + "分钟 前）";


            return diffString;
        }
    }
}