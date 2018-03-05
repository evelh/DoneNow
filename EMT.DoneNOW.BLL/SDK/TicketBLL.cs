﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class TicketBLL
    {
        private sdk_task_dal _dal = new sdk_task_dal();
        /// <summary>
        /// 新增工单操作
        /// </summary>
        /// <param name="param"></param>
        /// <param name="userId"></param>
        /// <param name="faileReason"></param>
        /// <returns></returns>
        public bool AddTicket(TicketManageDto param, long userId, out string faileReason)
        {
            faileReason = "";
            try
            {
                var thisTicket = param.ticket;
                #region 1 新增工单
                if (thisTicket != null)
                {
                    InsertTicket(thisTicket, userId);
                }
                #endregion

                #region 2 新增自定义信息
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                    thisTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                #endregion

                #region 3 工单其他负责人
                TicketResManage(thisTicket.id, param.resDepIds, userId);
                #endregion

                #region 4 检查单信息
                CheckManage(param.ckList, thisTicket.id,userId);
                #endregion


            }
            catch (Exception msg)
            {
                faileReason = msg.Message;
                return false;
            }
            return true;
        }
        /// <summary>
        /// 修改工单操作
        /// </summary>
        /// <param name="param"></param>
        /// <param name="userId"></param>
        /// <param name="faileReason"></param>
        /// <returns></returns>
        public bool EditTicket(TicketManageDto param, long userId, out string faileReason)
        {
            faileReason = "";
            try
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                #region 工单信息处理
                var oldTicket = _dal.FindNoDeleteById(param.ticket.id);
                if (oldTicket == null)
                    return false;
                bool isComplete = false;   // 是否是完成
                bool isRepeat = false;     // 是否是重新打开
                // 状态从第一次从“新建”改为其他，会触发 存储响应时间
                var updateTicket = param.ticket;
                if (oldTicket.first_activity_time == null && oldTicket.status_id == (int)DicEnum.TICKET_STATUS.NEW)
                {
                    updateTicket.first_activity_time = timeNow;
                }
                // 重新打开判断  -- 从完成状态变为其他状态次数
                if (oldTicket.status_id== (int)DicEnum.TICKET_STATUS.DONE&& updateTicket.status_id!= (int)DicEnum.TICKET_STATUS.DONE)
                {
                    updateTicket.reopened_count = (oldTicket.reopened_count ?? 0) + 1;
                    updateTicket.date_completed = null;
                    updateTicket.reason = param.repeatReason;
                    isRepeat = true;
                }
                // 完成判断
                if(oldTicket.status_id != (int)DicEnum.TICKET_STATUS.DONE && updateTicket.status_id == (int)DicEnum.TICKET_STATUS.DONE)
                {
                    updateTicket.date_completed = timeNow;
                    updateTicket.reason = param.completeReason;
                    isComplete = true;
                    if (param.isAppSlo)
                    {
                        updateTicket.resolution = (oldTicket.resolution ?? "") + updateTicket.resolution;
                    }
                }
                if(oldTicket.sla_id==null&& updateTicket.sla_id != null)
                {
                    updateTicket.sla_start_time = timeNow;
                }
                if (oldTicket.sla_id != null && updateTicket.sla_id == null)
                {
                    // updateTicket.sla_start_time = null;
                }

                var statusGeneral = new d_general_dal().FindNoDeleteById(updateTicket.status_id);

                var oldStatusGeneral = new d_general_dal().FindNoDeleteById(oldTicket.status_id);

                if (statusGeneral != null && !string.IsNullOrEmpty(statusGeneral.ext1))
                {
                    // 根据状态事件，执行相应的操作
                    switch (int.Parse(statusGeneral.ext1))
                    {
                        case (int)SLA_EVENT_TYPE.RESOLUTIONPLAN:
                            updateTicket.resolution_plan_actual_time = timeNow;
                            break;
                        case (int)SLA_EVENT_TYPE.RESOLUTION:
                            updateTicket.resolution_actual_time = timeNow;
                            break;
                        default:
                            break;
                    }
                    TicketSlaEvent(updateTicket,userId);
                }
                EditTicket(updateTicket,userId);
                // 添加活动信息
                if (isComplete)
                {
                    AddCompleteActive(updateTicket,userId);
                }
                // 添加活动信息
                if (isRepeat)
                {
                    AddCompleteActive(updateTicket, userId,true);
                }
                #endregion

                #region 自定义字段处理
                var udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.TICKETS);  // 获取合同的自定义字段信息
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.TICKETS, userId,
                    updateTicket.id, udf_list, param.udfList, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK_INFORMATION);
                #endregion

                #region 员工相关处理
                TicketResManage(updateTicket.id, param.resDepIds, userId);
                #endregion

                #region 检查单相关处理
                CheckManage(param.ckList, updateTicket.id, userId);
                #endregion
            }
            catch (Exception msg)
            {
                faileReason = msg.Message;
                return false;
            }
            return true;
        }
        /// <summary>
        /// 新增工单
        /// </summary>
        public bool InsertTicket(sdk_task ticket, long user_id)
        {
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (ticket.sla_id != null)
            {
                ticket.sla_start_time = timeNow;
            }
            ticket.id = _dal.GetNextIdCom();
            ticket.create_time = timeNow;
            ticket.create_user_id = user_id;
            ticket.update_time = timeNow;
            ticket.update_user_id = user_id;
            ticket.no = new TaskBLL().ReturnTaskNo();
            _dal.Insert(ticket);
            OperLogBLL.OperLogAdd<sdk_task>(ticket, ticket.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "新增工单");
            return true;
        }
        /// <summary>
        /// 编辑工单信息
        /// </summary>
        public bool EditTicket(sdk_task ticket, long user_id)
        {
            bool result = false;
            var oldTicket = _dal.FindNoDeleteById(ticket.id);
            if (oldTicket != null)
            {
                ticket.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                ticket.update_user_id = user_id;
                _dal.Update(ticket);
                OperLogBLL.OperLogUpdate<sdk_task>(ticket, oldTicket, ticket.id, user_id, OPER_LOG_OBJ_CATE.PROJECT_TASK, "修改工单信息");
            }
            return result;
        }
        /// <summary>
        /// 工单员工的管理
        /// </summary>
        public void TicketResManage(long ticketId, string resDepIds, long userId)
        {
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
            {
                return;
            }
            var strDal = new sdk_task_resource_dal();
            var srdDal = new sys_resource_department_dal();
            var oldTaskResList = strDal.GetResByTaskId(ticketId);
            if (oldTaskResList != null && oldTaskResList.Count > 0)
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (!string.IsNullOrEmpty(resDepIds))   // 数据库中有，页面也有
                {
                    var thisIdList = resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var resDepId in thisIdList)
                    {
                        var roleDep = srdDal.FindById(long.Parse(resDepId));
                        if (roleDep != null)
                        {
                            var isHas = oldTaskResList.FirstOrDefault(_ => _.resource_id == roleDep.resource_id && _.role_id == roleDep.role_id);
                            if (isHas == null)  // 相同的员工角色如果已经存在则不重复添加
                            {
                                var item = new sdk_task_resource()
                                {
                                    id = strDal.GetNextIdCom(),
                                    task_id = ticketId,
                                    role_id = roleDep.role_id,
                                    resource_id = roleDep.resource_id,
                                    department_id = (int)roleDep.department_id,
                                    create_user_id = userId,
                                    update_user_id = userId,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                };
                                strDal.Insert(item);
                                OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增工单分配对象");
                            }
                            else
                            {
                                oldTaskResList.Remove(isHas);
                            }
                        }
                    }
                    if (oldTaskResList.Count > 0)
                    {
                        foreach (var oldTaskRes in oldTaskResList)
                        {
                            strDal.SoftDelete(oldTaskRes, userId);
                            OperLogBLL.OperLogDelete<sdk_task_resource>(oldTaskRes, oldTaskRes.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除工单团队成员");
                        }
                    }
                }
                else            // 原来有，页面没有（全部删除）
                {
                    foreach (var oldTaskRes in oldTaskResList)
                    {
                        strDal.SoftDelete(oldTaskRes, userId);
                        OperLogBLL.OperLogDelete<sdk_task_resource>(oldTaskRes, oldTaskRes.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "删除工单团队成员");
                    }
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(resDepIds))// 页面有，数据库没有（全部新增）
                {
                    var resDepList = resDepIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    if (resDepList != null && resDepList.Count() > 0)
                    {

                        foreach (var resDepId in resDepList)
                        {
                            var roleDep = srdDal.FindById(long.Parse(resDepId));
                            if (roleDep != null)
                            {
                                var isHas = strDal.GetSinByTasResRol(ticketId, roleDep.resource_id, roleDep.role_id);
                                if (isHas == null)  // 相同的员工角色如果已经存在则不重复添加
                                {
                                    var item = new sdk_task_resource()
                                    {
                                        id = strDal.GetNextIdCom(),
                                        task_id = ticketId,
                                        role_id = roleDep.role_id,
                                        resource_id = roleDep.resource_id,
                                        department_id = (int)roleDep.department_id,
                                        create_user_id = userId,
                                        update_user_id = userId,
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    };
                                    strDal.Insert(item);
                                    OperLogBLL.OperLogAdd<sdk_task_resource>(item, item.id, userId, OPER_LOG_OBJ_CATE.PROJECT_TASK_RESOURCE, "新增工单分配对象");
                                }


                            }
                        }
                    }
                }
            }
        }
        /// <summary>
        /// 工单的检查单管理
        /// </summary>
        public void CheckManage(List<CheckListDto> ckList, long ticketId, long userId)
        {
            var stcDal = new sdk_task_checklist_dal();
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket == null)
                return;
            var oldCheckList = stcDal.GetCheckByTask(ticketId);
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (oldCheckList != null && oldCheckList.Count > 0)
            {
                if (ckList != null && ckList.Count > 0)
                {
                    var editList = ckList.Where(_ => _.ckId > 0).ToList();
                    var addList = ckList.Where(_ => _.ckId < 0).ToList();
                    if (editList != null && editList.Count > 0)
                    {
                        foreach (var thisEnt in editList)
                        {
                            var oldThisEdit = oldCheckList.FirstOrDefault(_ => _.id == thisEnt.ckId);
                            var thisEdit = stcDal.FindNoDeleteById(thisEnt.ckId);
                            if (oldThisEdit != null && thisEdit != null)
                            {
                                oldCheckList.Remove(oldThisEdit);
                                thisEdit.is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0);
                                thisEdit.is_important = (sbyte)(thisEnt.isImport ? 1 : 0);
                                thisEdit.item_name = thisEnt.itemName;
                                thisEdit.kb_article_id = thisEnt.realKnowId;
                                thisEdit.sort_order = thisEnt.sortOrder;
                                thisEdit.update_user_id = userId;
                                thisEdit.update_time = timeNow;
                                stcDal.Update(thisEdit);
                                OperLogBLL.OperLogUpdate<sdk_task_checklist>(thisEdit, oldThisEdit, thisEdit.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "修改检查单信息");
                            }
                        }
                    }
                    if (addList != null && addList.Count > 0)
                    {
                        foreach (var thisEnt in addList)
                        {
                            var thisCheck = new sdk_task_checklist()
                            {
                                id = stcDal.GetNextIdCom(),
                                is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0),
                                is_important = (sbyte)(thisEnt.isImport ? 1 : 0),
                                item_name = thisEnt.itemName,
                                kb_article_id = thisEnt.realKnowId,
                                update_user_id = userId,
                                update_time = timeNow,
                                create_time = timeNow,
                                create_user_id = userId,
                                task_id = ticketId,
                                sort_order = thisEnt.sortOrder,
                            };
                            stcDal.Insert(thisCheck);
                            OperLogBLL.OperLogAdd<sdk_task_checklist>(thisCheck, thisCheck.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "新增检查单信息");
                        }
                    }
                }
                if (oldCheckList.Count > 0)
                {
                    oldCheckList.ForEach(_ =>
                    {
                        stcDal.SoftDelete(_, userId);
                        OperLogBLL.OperLogDelete<sdk_task_checklist>(_, _.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "删除检查单信息");
                    });
                }
            }
            else
            {
                if(ckList!=null&& ckList.Count > 0)
                {
                    foreach (var thisEnt in ckList)
                    {
                        var thisCheck = new sdk_task_checklist()
                        {
                            id = stcDal.GetNextIdCom(),
                            is_competed = (sbyte)(thisEnt.isComplete ? 1 : 0),
                            is_important = (sbyte)(thisEnt.isImport ? 1 : 0),
                            item_name = thisEnt.itemName,
                            kb_article_id = thisEnt.realKnowId,
                            update_user_id = userId,
                            update_time = timeNow,
                            create_time = timeNow,
                            create_user_id = userId,
                            task_id = ticketId,
                            sort_order = thisEnt.sortOrder,
                        };
                        stcDal.Insert(thisCheck);
                        OperLogBLL.OperLogAdd<sdk_task_checklist>(thisCheck, thisCheck.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST, "新增检查单信息");
                    }
                }
            }
        }
        /// <summary>
        /// 工单完成时，保存活动信息
        /// </summary>
        public void AddCompleteActive(sdk_task ticket,long userId,bool isRepeat = false)
        {
            if(ticket!=null&& (ticket.status_id == (int)DicEnum.TICKET_STATUS.DONE|| isRepeat))
            {
                var activity = new com_activity()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE,
                    action_type_id = (int)ACTIVITY_TYPE.TASK_INFO,
                    object_id = ticket.id,
                    object_type_id = (int)OBJECT_TYPE.TICKETS,
                    account_id = ticket.account_id,
                    contact_id = ticket.contact_id,
                    name = isRepeat? "重新打开原因" : "完成原因",
                    description = ticket.reason,
                    publish_type_id = (int)NOTE_PUBLISH_TYPE.TASK_ALL_USER,
                    ticket_id = ticket.id,
                    create_user_id = userId,
                    update_user_id = userId,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    is_system_generate = 0,
                    task_status_id = (int)DicEnum.TICKET_STATUS.DONE,
                };
                new com_activity_dal().Insert(activity);
                OperLogBLL.OperLogAdd<com_activity>(activity, activity.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, isRepeat?"重新打开工单":"完成工单");
            }
            
        }
        /// <summary>
        /// 改变检查单的状态
        /// </summary>
        public bool ChangeCheckIsCom(long ckId,bool icCom,long userId)
        {
            var result = false;
            var stcDal = new sdk_task_checklist_dal();
            var thisCk = stcDal.FindNoDeleteById(ckId);
            var newIsCom = (sbyte)(icCom?1:0);
            if(thisCk!=null&& thisCk.is_competed!= newIsCom)
            {
                var oldCk = stcDal.FindNoDeleteById(ckId);
                thisCk.is_competed = newIsCom;
                thisCk.update_user_id = userId;
                thisCk.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                stcDal.Update(thisCk);
                OperLogBLL.OperLogUpdate<sdk_task_checklist>(thisCk, oldCk, thisCk.id, userId, OPER_LOG_OBJ_CATE.TICKET_CHECK_LIST,"修改检查单");
                result = true;
            }
            return result;

        }

        /// <summary>
        /// 新增工单备注
        /// </summary>
        public bool AddTicketNote(TaskNoteDto param,long ticket_id, long user_id)
        {
            try
            {
                var thisTicket = _dal.FindNoDeleteById(ticket_id);
                if (thisTicket == null)
                    return false;
                if (thisTicket.status_id != (int)DicEnum.TICKET_STATUS.DONE && thisTicket.status_id != param.status_id)
                {
                    thisTicket.status_id = param.status_id;
                    EditTicket(thisTicket,user_id);
                }

                var caDal = new com_activity_dal();
                var thisActivity = param.taskNote;
                thisActivity.ticket_id = ticket_id;
                thisActivity.id = caDal.GetNextIdCom();
                thisActivity.oid = 0;
                thisActivity.object_id = thisTicket.id;
                thisActivity.account_id = thisTicket.account_id;
                thisActivity.task_status_id = thisTicket.status_id;
                caDal.Insert(thisActivity);
                OperLogBLL.OperLogAdd<com_activity>(thisActivity, thisActivity.id, user_id, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

                if (param.filtList != null && param.filtList.Count > 0)
                {
                    var attBll = new AttachmentBLL();
                    foreach (var thisFile in param.filtList)
                    {
                        if (thisFile.type_id == ((int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT).ToString())
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisActivity.id, (int)DicEnum.ATTACHMENT_TYPE.ATTACHMENT, thisFile.new_filename, "", thisFile.old_filename, thisFile.fileSaveName, thisFile.conType, thisFile.Size, user_id);
                        }
                        else
                        {
                            attBll.AddAttachment((int)ATTACHMENT_OBJECT_TYPE.NOTES, thisActivity.id, int.Parse(thisFile.type_id), thisFile.new_filename, thisFile.old_filename, null, null, null, 0, user_id);
                        }
                    }
                }
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 删除工单，返回不可删除的原因，返回多条
        /// </summary>
        public bool DeleteTicket(long ticketId,long userId,out string failReason)
        {
            failReason = "";
            var couldDelete = true;   // 校验是否可以删除
            var thisTicket = _dal.FindNoDeleteById(ticketId);
            if (thisTicket != null)
            {
                // 如果做过外包，且未被取消，不能删除，提醒“工单被外包，不能删除”
                // 如果有工时，不能删除，提醒“工单有工时，不能删除”
                // 如果有费用，不能删除，提醒“工单有费用，不能删除”
                // 如果有成本，不能删除，提醒“工单有成本，不能删除”
                // 如果有员工对变更申请进行了审批（同意或拒绝），提醒“有员工对变更申请进行了审批（同意或拒绝），不能删除”
                var entryList = new sdk_work_entry_dal().GetByTaskId(thisTicket.id);
                if(entryList!=null&& entryList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有工时，不能删除;";
                }

                var expList = new sdk_expense_dal().GetExpByTaskId(thisTicket.id);
                if(expList!=null&& expList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有费用，不能删除;";
                }

                var costList = new ctt_contract_cost_dal().GetListByTicketId(thisTicket.id);
                if(costList!=null&& costList.Count > 0)
                {
                    couldDelete = false;
                    failReason += "工单有成本，不能删除;";
                }

                if (couldDelete)
                {
                    #region 删除工单间关联关系
                    var subTicketList = new sdk_task_dal().GetTaskByParentId(thisTicket.id);
                    if(subTicketList!=null&& subTicketList.Count > 0)
                    {
                        foreach (var subTicket in subTicketList)
                        {
                            subTicket.parent_id = null;
                            EditTicket(subTicket,userId);
                        }
                    }
                    #endregion

                    #region 删除备注 
                    var caDal = new com_activity_dal();
                    var actList = caDal.GetActiList(" and ticket_id="+ thisTicket.id.ToString());
                    if(actList!=null&& actList.Count > 0)
                    {
                        actList.ForEach(_ => {
                            caDal.SoftDelete(_,userId);
                            OperLogBLL.OperLogDelete<com_activity>(_,_.id,userId, DicEnum.OPER_LOG_OBJ_CATE.ACTIVITY,"删除活动");
                        });
                    }
                    #endregion

                    #region 删除附件
                    var comAttDal = new com_attachment_dal();
                    var attList = comAttDal.GetAttListByOid(thisTicket.id);
                    if(attList!=null&& attList.Count > 0)
                    {
                        attList.ForEach(_ => {
                            comAttDal.SoftDelete(_, userId);
                            OperLogBLL.OperLogDelete<com_attachment>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.ATTACHMENT, "删除附件");
                        });
                    }
                    #endregion

                    #region 删除待办

                    #endregion

                    #region 删除服务预定

                    #endregion

                    #region 删除变更信息
                    var stoDal = new sdk_task_other_dal();
                    var otherList = stoDal.GetTicketOther(thisTicket.id);
                    if(otherList!=null&& otherList.Count > 0)
                    {
                        otherList.ForEach(_ => {
                            stoDal.SoftDelete(_,userId);
                            OperLogBLL.OperLogDelete<sdk_task_other>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK, "删除工单");
                        });
                    }
                    #endregion


                    #region 删除审批人信息
                    var stopDal = new sdk_task_other_person_dal();
                    var appList = stopDal.GetTicketOther(thisTicket.id);
                    if (appList != null && appList.Count > 0)
                    {
                        appList.ForEach(_ => {
                            stopDal.SoftDelete(_, userId);
                            OperLogBLL.OperLogDelete<sdk_task_other_person>(_, _.id, userId, DicEnum.OPER_LOG_OBJ_CATE.TICKET_SERVICE_REQUEST, "删除审批人");
                        });
                    }
                    #endregion


                    #region 删除工单信息

                    _dal.SoftDelete(thisTicket,userId);
                    OperLogBLL.OperLogDelete<sdk_task>(thisTicket, thisTicket.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_TASK, "删除工单");
                    #endregion
                }
                else
                {
                    return false;
                }

            }
            return true;
        }

        /// <summary>
        /// 工单Sla事件管理
        /// </summary>
        public void TicketSlaEvent(sdk_task thisTicket,long userId)
        {
            var statusGeneral = new d_general_dal().FindNoDeleteById(thisTicket.status_id);
            if (thisTicket.sla_id != null&& statusGeneral!=null)
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                // sdk_task_sla_event
                var stseDal = new sdk_task_sla_event_dal();
                var thisTaskSla = stseDal.GetTaskSla(thisTicket.id);
                if (thisTaskSla == null)
                {
                    thisTaskSla = new sdk_task_sla_event()
                    {
                        id = stseDal.GetNextIdCom(),
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = userId,
                        update_user_id = userId,
                        task_id = thisTicket.id,
                    };
                    stseDal.Insert(thisTaskSla);
                    OperLogBLL.OperLogAdd<sdk_task_sla_event>(thisTaskSla, thisTaskSla.id, userId, OPER_LOG_OBJ_CATE.TICKET_SLA_EVENT, "新增工单sla事件");
                }

                if (thisTicket.sla_start_time != null && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.FIRSTRESPONSE).ToString())
                {
                    thisTaskSla.first_response_resource_id = userId;
                    thisTaskSla.first_response_elapsed_hours = GetDiffHours((long)thisTicket.sla_start_time,timeNow);
                }
                if(thisTicket.resolution_plan_actual_time!=null && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.RESOLUTIONPLAN).ToString())
                {
                    thisTaskSla.resolution_plan_resource_id = userId;
                    thisTaskSla.resolution_plan_elapsed_hours = GetDiffHours((long)thisTicket.resolution_plan_actual_time,timeNow);
                }
                if (thisTicket.resolution_actual_time != null && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.RESOLUTION).ToString())
                {
                    thisTaskSla.resolution_resource_id = userId;
                    thisTaskSla.resolution_elapsed_hours = GetDiffHours((long)thisTicket.resolution_actual_time, timeNow);
                }
                // todo 计算 sla 目标
                #region 计算等待客户时长相关
                var oldTicket = _dal.FindNoDeleteById(thisTicket.id);
                if (oldTicket != null)
                {
                    var oldStatusGeneral = new d_general_dal().FindNoDeleteById(oldTicket.status_id);
                    if (oldStatusGeneral != null && !string.IsNullOrEmpty(oldStatusGeneral.ext1))
                    {
                        if(oldStatusGeneral.ext1 != ((int)SLA_EVENT_TYPE.WAITINGCUSTOMER).ToString() && statusGeneral.ext1 == ((int)SLA_EVENT_TYPE.WAITINGCUSTOMER).ToString())
                        {
                            thisTaskSla.total_waiting_customer_hours += GetDiffHours(oldTicket.update_time,timeNow);
                        }
                    }
                }
                #endregion

                var oldEvent = stseDal.FindNoDeleteById(thisTaskSla.id);
                if (oldEvent != null)
                {
                
                }
                stseDal.Update(thisTaskSla);
                OperLogBLL.OperLogUpdate<sdk_task_sla_event>(thisTaskSla, oldEvent, thisTaskSla.id, userId, OPER_LOG_OBJ_CATE.TICKET_SLA_EVENT, "修改工单sla事件");
            }
        }

        /// <summary>
        /// 获取到两个时间相差的小时数
        /// </summary>
        public int GetDiffHours(long startDate,long endDate)
        {
            int hours = 0;
            var thisStartDate = Tools.Date.DateHelper.ConvertStringToDateTime(startDate);
            var thisEndDate = Tools.Date.DateHelper.ConvertStringToDateTime(endDate);
            TimeSpan ts1 = new TimeSpan(thisStartDate.Ticks);
            TimeSpan ts2 = new TimeSpan(thisEndDate.Ticks);
            TimeSpan ts = ts1.Subtract(ts2).Duration();
            if (ts.Days > 0)
            {
                hours += ts.Days * 24;
            }
            if (ts.Hours > 0)
            {
                hours += ts.Hours;
            }
            return hours;
        }


        #region 工单工时管理
        /// <summary>
        /// 添加工单工时信息
        /// </summary>
        public bool AddLabour(sdk_work_entry thisEntry,long userId)
        {
            var sweDal = new sdk_work_entry_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            thisEntry.id = sweDal.GetNextIdCom();
            thisEntry.create_time = timeNow;
            thisEntry.update_time = timeNow;
            thisEntry.create_user_id = userId;
            thisEntry.update_user_id = userId;
            sweDal.Insert(thisEntry);
            OperLogBLL.OperLogAdd<sdk_work_entry>(thisEntry, thisEntry.id, userId, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "新增工时");
            return true;
        }
        public bool EditLabour(sdk_work_entry thisEntry, long userId)
        {
            var sweDal = new sdk_work_entry_dal();
            var oldLabour = sweDal.FindNoDeleteById(thisEntry.id);
            if (oldLabour != null)
            {
                thisEntry.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                thisEntry.update_user_id = userId;
                sweDal.Update(thisEntry);
                OperLogBLL.OperLogUpdate<sdk_work_entry>(thisEntry, oldLabour,thisEntry.id, userId, OPER_LOG_OBJ_CATE.SDK_WORK_ENTRY, "修改工时");
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// 工单工时的添加处理
        /// </summary>
        public bool AddTicketLabour(SdkWorkEntryDto param,long userId,ref string failReason)
        {
            try
            {
                #region  添加工时
                AddLabour(param.workEntry,userId);
                #endregion

                #region 保存工单相关
                var oldTicket = _dal.FindNoDeleteById(param.ticketId);
                if (oldTicket != null)
                {
                    if (oldTicket.status_id != param.status_id)
                    {
                        oldTicket.status_id = param.status_id;
                    }
                    if (param.isAppthisResoule)
                    {
                        oldTicket.resolution += "\r\n" + param.workEntry.summary_notes;
                    }
                    EditTicket(oldTicket, userId);
                }

                #endregion

                #region 更新相关事故的解决方案
                var proTicketList = _dal.GetSubTaskByType(param.ticketId,DicEnum.TICKET_TYPE.PROBLEM);
                if (proTicketList != null && proTicketList.Count > 0)
                {
                    proTicketList.ForEach(_ => {
                        if (param.isAppOtherResoule)
                        {
                            _.resolution += "\r\n" + param.workEntry.summary_notes;
                        }
                        if (param.isAppOtherNote)
                        {
                            if (_.status_id != (int)DicEnum.TICKET_STATUS.DONE)
                            {
                                _.status_id = param.status_id;
                            }
                            if (!string.IsNullOrEmpty(param.workEntry.summary_notes)&&!string.IsNullOrEmpty(param.workEntry.internal_notes))
                            {
                                long noteId;
                                AppNoteLabour(_, param.workEntry.summary_notes,userId ,out noteId,true);
                                if (noteId != 0)
                                {
                                    AppNoteLabour(_, param.workEntry.internal_notes, userId, out noteId, false, noteId);
                                }
                                
                            }
                        }
                        EditTicket(_, userId);
                    });
                }
                #endregion

                #region 通知相关

                #endregion

                #region 根据合同设置 是否立刻审批并提交
                if (param.workEntry.contract_id != null)
                {
                    var contract = new ctt_contract_dal().FindNoDeleteById((long)param.workEntry.contract_id);
                    if(contract!=null && contract.bill_post_type_id == (int)DicEnum.BILL_POST_TYPE.BILL_NOW)
                    {
                        new ApproveAndPostBLL().PostWorkEntry(param.workEntry.id, Convert.ToInt32(DateTime.Now.ToString("yyyyMMdd")), userId, "A");
                    }
                }
                #endregion

                #region 新增合同成本相关
                AddTicketLabourCost(param.thisCost,userId);
                #endregion


            }
            catch (Exception msg)
            {
                failReason = msg.Message;
                return false;
            }

            return true;
        }
        /// <summary>
        /// 添加工单工时时，附件相关备注 isSummary 代表是工时说明备注，还是内部说明备注
        /// </summary>
        public void AppNoteLabour(sdk_task thisTicket, string note, long userId,out long thisNoteId, bool isSummary = false, long? noteId = null)
        {
            var activ = new com_activity();
            var caDal = new com_activity_dal();
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            activ.id = caDal.GetNextIdCom();
            if (isSummary)
            {
                thisNoteId = activ.id;
            }
            else
            {
                thisNoteId = 0;
            }
            activ.cate_id = (int)DicEnum.ACTIVITY_CATE.TICKET_NOTE;
            activ.object_type_id = (int)DicEnum.OBJECT_TYPE.TICKETS;
            activ.account_id = thisTicket.account_id;
            activ.contact_id = thisTicket.contact_id;
            activ.ticket_id = thisTicket.id;
            activ.description = note;
            activ.create_time = timeNow;
            activ.update_time = timeNow;
            activ.create_user_id = userId;
            activ.update_user_id = userId;
            if (isSummary)
            {
                activ.object_type_id = (int)DicEnum.OBJECT_TYPE.TICKETS;
                activ.object_id = thisTicket.id;
                activ.publish_type_id = (int)NOTE_PUBLISH_TYPE.TASK_ALL_USER;
            }
            else
            {
                activ.object_type_id = (int)DicEnum.OBJECT_TYPE.NOTES;
                activ.object_id = (long)noteId;
                activ.publish_type_id = (int)NOTE_PUBLISH_TYPE.TASK_INTERNA_USER;
            }
            caDal.Insert(activ);
            OperLogBLL.OperLogAdd<com_activity>(activ, activ.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");
        }
        /// <summary>
        /// 新增 项目工时成本
        /// </summary>
        public void AddTicketLabourCost(ctt_contract_cost thisCost,long userId)
        {
            if (thisCost != null)
            {
                var costCode = new d_cost_code_dal().FindNoDeleteById(thisCost.cost_code_id);
                if (costCode != null)
                {
                    var cccDal = new ctt_contract_cost_dal();
                    thisCost.id = cccDal.GetNextIdCom();
                    thisCost.is_billable = 1;
                    thisCost.name = costCode.name;
                    thisCost.unit_cost = costCode.unit_cost;
                    thisCost.sub_cate_id = (int)DicEnum.BILLING_ENTITY_SUB_TYPE.CONTRACT_COST;
                    thisCost.cost_type_id = (int)COST_TYPE.OPERATIONA;
                    thisCost.status_id = (int)COST_STATUS.UNDETERMINED;
                    cccDal.Insert(thisCost);
                    OperLogBLL.OperLogAdd<ctt_contract_cost>(thisCost, thisCost.id, userId, OPER_LOG_OBJ_CATE.CONTRACT_COST, "新增合同成本");
                }
            }
        }

        /// <summary>
        /// 修改工单工时信息
        /// </summary>
        public bool EditTicketLabour(SdkWorkEntryDto param, long userId, ref string failReason)
        {
            var oldLaour = new sdk_work_entry_dal().FindNoDeleteById(param.workEntry.id);
            if (oldLaour == null )
            {
                failReason = "未查询到该工时信息";
                return false;
            }
            if(oldLaour.approve_and_post_date != null || oldLaour.approve_and_post_user_id != null)
            {
                failReason = "该工时已经进行审批提交，不可进行更改";
                return false;
            }
            var thisTicket = _dal.FindNoDeleteById(param.ticketId);
            if (thisTicket == null)
            {
                failReason = "相关工单已删除";
                return false;
            }
            if (thisTicket.status_id == (int)TICKET_STATUS.DONE)
            {
                failReason = "已完成工单不能进行编辑工时相关操作";
                return false;
            }

                #region 修改工单相关
                EditLabour(param.workEntry,userId);
            #endregion

            #region 保存工单相关
            var oldTicket = _dal.FindNoDeleteById(param.ticketId);
            if (oldTicket != null)
            {
                if (oldTicket.status_id != param.status_id)
                {
                    oldTicket.status_id = param.status_id;
                }
                if (param.isAppthisResoule)
                {
                    oldTicket.resolution += "\r\n" + param.workEntry.summary_notes;
                }
                EditTicket(oldTicket, userId);
            }

            #endregion

            #region 更新相关事故的解决方案
            var proTicketList = _dal.GetSubTaskByType(param.ticketId, DicEnum.TICKET_TYPE.PROBLEM);
            if (proTicketList != null && proTicketList.Count > 0)
            {
                proTicketList.ForEach(_ => {
                    if (param.isAppOtherResoule)
                    {
                        _.resolution += "\r\n" + param.workEntry.summary_notes;
                    }
                    if (param.isAppOtherNote)
                    {
                        if (_.status_id != (int)DicEnum.TICKET_STATUS.DONE)
                        {
                            _.status_id = param.status_id;
                        }
                        if (!string.IsNullOrEmpty(param.workEntry.summary_notes) && !string.IsNullOrEmpty(param.workEntry.internal_notes))
                        {
                            long noteId;
                            AppNoteLabour(_, param.workEntry.summary_notes, userId, out noteId, true);
                            if (noteId != 0)
                            {
                                AppNoteLabour(_, param.workEntry.internal_notes, userId, out noteId, false, noteId);
                            }

                        }
                    }
                    EditTicket(_, userId);
                });
            }
            #endregion

            #region 新增合同成本相关
            AddTicketLabourCost(param.thisCost, userId);
            #endregion

            return true;
        }



        #endregion


        /// <summary>
        /// 快速新增工单备注
        /// </summary>
        public bool SimpleAddTicketNote(long ticketId,long userId,int noteTypeId,string noteDes,bool isInter,string notifiEmail)
        {
            var result = false;
            try
            {
                var thisTicket = _dal.FindNoDeleteById(ticketId);
                var caDal = new com_activity_dal();
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var thisNote = new com_activity()
                {
                    id= caDal.GetNextIdCom(),
                    account_id = thisTicket.account_id,
                    object_id = thisTicket.id,
                    ticket_id = thisTicket.id,
                    action_type_id = noteTypeId,
                    publish_type_id= isInter?((int)NOTE_PUBLISH_TYPE.TASK_INTERNA_USER) :((int)NOTE_PUBLISH_TYPE.TASK_ALL_USER),
                    cate_id = (int)ACTIVITY_CATE.TICKET_NOTE,
                    name = noteDes.Length>=40? noteDes.Substring(0,39): noteDes,
                    description = noteDes,
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = userId,
                    update_user_id = userId,
                    object_type_id = (int)OBJECT_TYPE.TICKETS,
                    task_status_id =thisTicket.status_id,
                    resource_id = thisTicket.owner_resource_id,
                };
                caDal.Insert(thisNote);
                OperLogBLL.OperLogAdd<com_activity>(thisNote, thisNote.id, userId, OPER_LOG_OBJ_CATE.ACTIVITY, "新增备注");

                #region todo 工单备注事件的默认模板，如果不设置则不发送
                #endregion
                result = true;
            }
            catch (Exception)
            {
                result = false;
            }

            return result;
        }
        /// <summary>
        /// 快速新增中，获取相关的通知人邮箱
        /// </summary>
        public string GetNotiEmail(long ticketId,bool notiContact,bool notiPriRes,bool noriInterAll)
        {
            return "";
        }
    }
}
