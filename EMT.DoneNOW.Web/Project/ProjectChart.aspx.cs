﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System.Text;

namespace EMT.DoneNOW.Web.Project
{
    public partial class ProjectChart : BasePage
    {
        protected int showYearNum = 1;  // 页面上展示的日期范围（时间范围过长时-采用开始时间一年内）
        protected double DayWidth = 50; // 一天在页面上占的宽度 
        protected DateTime start_date;  // 页面上展示的最小时间
        protected DateTime end_date;    // 页面上展示的最大时间
        protected pro_project thisProject = null;
        protected List<sdk_task> taskList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var project_id = Request.QueryString["project_id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(project_id));
                var type = Request.QueryString["dateType"];
                if (string.IsNullOrEmpty(type))
                {
                    type = "day";
                }
                taskList = new sdk_task_dal().GetAllProTask(thisProject.id);
                if (taskList != null && taskList.Count > 0)
                {
                    start_date = Tools.Date.DateHelper.ConvertStringToDateTime((long)taskList.Min(_ => _.estimated_begin_time));
                    end_date = (DateTime)taskList.Max(_ => _.estimated_end_date);
                    if (GetDateDiffMonth(start_date, end_date, "month") > 12)
                    {
                        end_date = start_date.AddYears(showYearNum).AddDays(-1);
                    }
                    else if (GetDateDiffMonth(start_date, end_date, "month") <= 2)
                    {
                        end_date = end_date.AddMonths(1).AddDays(-1);  // 时间太少，增加宽度
                    }
                    // 页面上展示多少月份
                    var monthNum = GetDateDiffMonth(start_date, end_date, "month");
                    #region 日期展示说明
                    // 1.计算出具体显示多少月份，最多显示 showYearNum*12 的月份--循环添加
                    // 2.开始月份和结束月份可能不是整月，显示部分 --特殊处理
                    // 3.展示具体的天，周，月信息
                    #endregion

                    #region 上右日历列表
                    StringBuilder headInfo = new StringBuilder();
                  
                    switch (type)
                    {
                        case "day":
                            for (int i = 0; i < monthNum; i++)
                            {
                                headInfo.Append($"<div class='Gantt_dateMonthYear Gantt_titleFont Gantt_divTableHeader Gantt_header Gantt_date'>");
                                if ((i == 0 || i == monthNum - 1)) // 开始和结束时间以及特殊情况的处理
                                {
                                    if (i == 0)
                                    {
                                        var monthDayNum = RetuenMonthDay(start_date);  // 开始日期的月份的总天数
                                        var surplusDays = (monthDayNum - start_date.Day + 1);  // 开始结束时间 --剩余天数
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.Year.ToString() + '.' + start_date.Month.ToString()}</div>");
                                        int s;
                                        for (s = start_date.Day; s <= monthDayNum; s++)
                                        {
                                            headInfo.Append($"<div class='Gantt_divTableColumn Gantt_header Gantt_date'>{s}</div>");
                                        }
                                    }
                                    else if (i == monthNum - 1)
                                    {
                                        var monthDayNum = RetuenMonthDay(end_date);  // 开始日期的月份的总天数
                                        var surplusDays = end_date.Day;  // 开始结束时间
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{end_date.Year.ToString() + '.' + end_date.Month.ToString()}</div>");
                                        for (int s = 1; s <= surplusDays; s++)
                                        {
                                            headInfo.Append($"<div class='Gantt_divTableColumn Gantt_header Gantt_date'>{s}</div>");
                                        }
                                    }

                                }
                                else
                                {
                                    var monthDayNum = RetuenMonthDay(start_date.AddMonths(i));  // 开始日期的月份的总天数
                                    var thisMonthWidth = monthDayNum * DayWidth;
                                    headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.AddMonths(i).Year.ToString() + '.' + start_date.AddMonths(i).Month.ToString()}</div>");
                                    for (int s = 1; s <= monthDayNum; s++)
                                    {
                                        headInfo.Append($"<div class='Gantt_divTableColumn Gantt_header Gantt_date'>{s}</div>");
                                    }
                                }
                                headInfo.Append("</div>");
                            }
                            break;
                        case "week":
                            DayWidth = 10;
                            headInfo.Append($"<table border='0' cellspacing='0' cellpadding='0'><tbody><tr valign='top'><td><div class='grid TimelineGridHeader'><table border = '0' cellspacing='0' cellpadding='0'><tbody><tr height = '0'></tr></ tbody><thead> ");
                            // 添加月
                            headInfo.Append("<tr valign='middle' align='center'>");
                            for (int i = 0; i < monthNum; i++)
                            {
                                if ((i == 0 || i == monthNum - 1)) // 开始和结束时间以及特殊情况的处理
                                {
                                    if (i == 0)
                                    {
                                        var monthDayNum = RetuenMonthDay(start_date);  // 开始日期的月份的总天数
                                        var surplusDays = (monthDayNum - start_date.Day + 1);  // 开始结束时间 --剩余天数
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<td colspan='{surplusDays}' class='TextUppercase'>{start_date.Year + "." + start_date.Month}</ td>");
                                    }
                                    else if (i == monthNum - 1)
                                    {
                                        var monthDayNum = RetuenMonthDay(end_date);  // 开始日期的月份的总天数
                                        var surplusDays = end_date.Day;  // 开始结束时间
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<td colspan='{end_date.Day}' class='TextUppercase'>{end_date.Year.ToString() + '.' + end_date.Month.ToString()}</ td>");
                                    }

                                }
                                else
                                {
                                    var monthDayNum = RetuenMonthDay(start_date.AddMonths(i));  // 开始日期的月份的总天数
                                    var thisMonthWidth = monthDayNum * DayWidth;
                                    headInfo.Append($"<td colspan='{monthDayNum}' class='TextUppercase'>{start_date.AddMonths(i).Year.ToString() + '.' + start_date.AddMonths(i).Month.ToString()}</ td>");

                                }
                            }
                            headInfo.Append("</tr>");

                            // 添加周
                            headInfo.Append("<tr valign='middle' align='center'>");
                            var weekNum = GetDateDiffMonth(start_date, end_date, "week");
                            for (int s = 0; s < weekNum; s++)
                            {
                                if (s != (weekNum - 1))
                                {
                                    headInfo.Append($"<td colspan='7'><div class='TimelineSecondaryHeader' style='width: 49px;'>{start_date.AddDays(s * 7).Day}-{start_date.AddDays((s + 1) * 7 - 1).Day}</div></td>");
                                }
                                else
                                {
                                    headInfo.Append($"<td colspan='7'><div class='TimelineSecondaryHeader' style='width: 49px;'>{start_date.AddDays(s * 7).Day}-{end_date.Day}</div></td>");
                                }

                            }
                            headInfo.Append("</tr>");
                            headInfo.Append("</thead></table></div></td></tr></tbody></table> ");
                            break;
                        case "month":
                            DayWidth = 5;
                            for (int i = 0; i < monthNum; i++)
                            {
                                headInfo.Append($"<div class='Gantt_dateMonthYear Gantt_titleFont Gantt_divTableHeader Gantt_header Gantt_date'>");
                                if ((i == 0 || i == monthNum - 1)) // 开始和结束时间以及特殊情况的处理
                                {
                                    if (i == 0)
                                    {
                                        var monthDayNum = RetuenMonthDay(start_date);  // 开始日期的月份的总天数
                                        var surplusDays = (monthDayNum - start_date.Day + 1);  // 开始结束时间 --剩余天数
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.Year.ToString() + '.' + start_date.Month.ToString()}</div>");
                                    }
                                    else if (i == monthNum - 1)
                                    {
                                        var monthDayNum = RetuenMonthDay(end_date);  // 开始日期的月份的总天数
                                        var surplusDays = end_date.Day;  // 开始结束时间
                                        var thisMonthWidth = surplusDays * DayWidth;  // 计算出这个月份占的宽度
                                        headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{end_date.Year.ToString() + '.' + end_date.Month.ToString()}</div>");
                                    }

                                }
                                else
                                {
                                    var monthDayNum = RetuenMonthDay(start_date.AddMonths(i));  // 开始日期的月份的总天数
                                    var thisMonthWidth = monthDayNum * DayWidth;
                                    headInfo.Append($"<div class='Gantt_monthHolder' style='width: {thisMonthWidth}px;'>{start_date.AddMonths(i).Year.ToString() + '.' + start_date.AddMonths(i).Month.ToString()}</div>");
                                }
                                headInfo.Append("</div>");
                            }
                            break;
                        default:
                            break;
                    }
                    liCalendar.Text = headInfo.ToString();
                    #endregion


                    #region 下左列表
                    StringBuilder leftInfo = new StringBuilder();
                    leftInfo.Append($"<div class='Gantt_projectTitleFont Gantt_titleFont Gantt_divTableRow'><div class='Gantt_idFont Gantt_id Gantt_divTableColumnMonth'></div><div class='Gantt_projectFont Gantt_title Gantt_divTableColumnMonth Gantt_projectTitle'><div style = 'display: block; white-space:nowrap; overflow:inherit;'>{thisProject.name}</div></div></div> ");
                    AddTableHtml(null, taskList,"","",leftInfo);
                    liLeftTable.Text = leftInfo.ToString();
                    #endregion

                    #region 下右图形
                    StringBuilder rightInfo = new StringBuilder();
                    rightInfo.Append($"<div class='Gantt_divTableRow'><img src = '../Images/todayBarIndicator.png' class='Gantt_TodayBar' style='left: 670px;'><div class='Gantt_projectBar' id='Gantt_projectBar' style='width: 100%;'><div style='width: 0%;'></div></div></div>");
                    AddImgHtml(null, taskList,"", rightInfo);
                    liRightImg.Text = rightInfo.ToString();
                    #endregion


                }
                else
                {
                    liCalendar.Text = "暂无数据";
                }

            }
            catch (Exception msg)
            {
                Response.End();
            }
        }
        /// <summary>
        /// 表格追加
        /// </summary>
        private void AddTableHtml(long? parent_id,List<sdk_task> taskList,string no,string id, StringBuilder htmlInfo)
        {
            var subList = taskList.Where(_ => _.parent_id == parent_id).ToList();
            if (subList != null && subList.Count > 0)
            {
                subList = subList.OrderBy(_ => _.sort_order).ToList();
                foreach (var sub in subList)
                {
                    var thisNo = "";
                    var thisId = "";
                    if (!string.IsNullOrEmpty(no))
                    {
                        thisNo += no + "."+(subList.IndexOf(sub)+1);
                    }
                    else
                    {
                        thisNo = (subList.IndexOf(sub) + 1).ToString();
                    }
                    if (!string.IsNullOrEmpty(id))
                    {
                        thisId += id + "_" + (subList.IndexOf(sub) + 1);
                    }
                    else
                    {
                        thisId = (subList.IndexOf(sub) + 1).ToString();
                    }
                    htmlInfo.Append($"<div class='Gantt_parent Gantt_titleFont Gantt_divTableRow {thisId}' id='{thisId}'><div class='Gantt_idFont Gantt_id Gantt_divTableColumnMonth'>{thisNo}</div><div class='Gantt_projectFont Gantt_title Gantt_divTableColumnMonth Gantt_projectTitle'><div class='Gantt_ToggleDiv'><div class='Vertical' style='display: none;'></div><div class='Horizontal'></div></div><div style = 'display: block; white-space:nowrap; overflow:inherit;'>{sub.title}</div></div></div>");
                    AddTableHtml(sub.id,taskList, thisNo,thisId,htmlInfo);

                }
            }
        }

        /// <summary>
        /// div追加
        /// </summary>
        private void AddImgHtml(long? parent_id, List<sdk_task> taskList, string no, StringBuilder htmlInfo)
        {
            var subList = taskList.Where(_ => _.parent_id == parent_id).ToList();
            if (subList != null && subList.Count > 0)
            {
                subList = subList.OrderBy(_ => _.sort_order).ToList();
                foreach (var sub in subList)
                {
                    var thisNo = "";
                    if (!string.IsNullOrEmpty(no))
                    {
                        thisNo += no + "." + (subList.IndexOf(sub) + 1);
                    }
                    else
                    {
                        thisNo = (subList.IndexOf(sub) + 1).ToString();
                    }
                    var thisBeginDate = Tools.Date.DateHelper.ConvertStringToDateTime((long)sub.estimated_begin_time);
                    var diffDays = GetDateDiffMonth(start_date, thisBeginDate, "day"); // 开始时间距离最开始时间距离
                    var thisDays = GetDateDiffMonth(start_date, DateTime.Now, "day");
                    var proDays = GetDateDiffMonth(thisBeginDate, (DateTime)sub.estimated_end_date, "day"); // 项目持续的时间
                    proDays += 1;

                    htmlInfo.Append($"<div class='Gantt_divTableRow' id='inner_{thisNo}'><img src = '../Images/todayBarIndicator.png' class='Gantt_TodayBar' style='left: {thisDays*DayWidth+0.5*DayWidth}px;'><div class='Gantt_phaseBar' style='width:{proDays*DayWidth}px; left:{{diffDays* DayWidth}}px;'><span class='Gantt_leftCorner' style='background-position: 0 -32px;'></span><div class='Gantt_Completed' style='width:100%;'></div><span class='Gantt_rightCorner' style='background-position: 0 -110px;'></span></div></div>");

                }
            }
        }

        /// <summary>
        /// 根据开始时间和结束时间计算两个时间相差的月，周，天数
        /// </summary>
        protected int GetDateDiffMonth(DateTime startDate, DateTime endDate, string dateType)
        {
            int num = 0;
            TimeSpan ts1 = new TimeSpan(startDate.Ticks);
            TimeSpan ts2 = new TimeSpan(endDate.Ticks);
            TimeSpan ts = ts1.Subtract(ts2).Duration();
            num = ts.Days;
            switch (dateType)
            {
                case "day":
                    num = ts.Days;
                    break;
                case "week":
                    var week = num / 7;
                    if (num % 7 != 0)
                    {
                        num = week + 1;
                    }
                    else
                    {
                        num = week;
                    }
                    break;
                case "month":
                    num = (endDate.Year - startDate.Year) * 12 + (endDate.Month - startDate.Month + 1);
                    // + (endDate.Day >= startDate.Day ? 1 : 0)
                    break;
                default:
                    break;
            }
            return num;
        }
        /// <summary>
        /// 返回这个月的天数
        /// </summary>
        protected double RetuenMonthDay(DateTime date)
        {
            double dayNum = 0;
            switch (date.Month)
            {
                case 1:
                case 3:
                case 5:
                case 7:
                case 8:
                case 10:
                case 12:
                    dayNum = 31;
                    break;
                case 4:
                case 6:
                case 9:
                case 11:
                    dayNum = 30;
                    break;
                case 2:
                    var year = date.Year;
                    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
                    {
                        dayNum = 28;
                    }
                    else
                    {
                        dayNum = 29;
                    }
                    break;
                default:
                    break;
            }
            return dayNum;
        }
    }
}