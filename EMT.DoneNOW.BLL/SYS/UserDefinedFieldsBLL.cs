﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 用户自定义字段处理
    /// </summary>
    public class UserDefinedFieldsBLL
    {
        /// <summary>
        /// 获取一个对象包含的用户自定义字段信息
        /// </summary>
        /// <param name="cate">对象分类</param>
        /// <returns></returns>
        public List<UserDefinedFieldDto> GetUdf(DicEnum.UDF_CATE cate)
        {
            var dal = new sys_udf_field_dal();
            var udfListDal = new sys_udf_list_dal();
            string sql=dal.QueryStringDeleteFlag($"SELECT id,col_name,col_comment as name,description,data_type_id as cate,default_value,decimal_length,is_required as required FROM sys_udf_field WHERE is_active=1 and cate_id = {(int)cate}");
            var list = dal.FindListBySql<UserDefinedFieldDto>(sql);
            foreach (var udf in list)
            {
                if (udf.data_type == (int)DicEnum.UDF_DATA_TYPE.LIST)
                {
                    var valList = udfListDal.FindListBySql<DictionaryEntryDto>(udfListDal.QueryStringDeleteFlag($"SELECT id as 'val',name as 'show',is_default as 'select' FROM sys_udf_list WHERE udf_field_id={udf.id} status_id=0"));
                    if (valList != null && valList.Count != 0)
                        udf.value_list = valList;
                }
            }

            return list;
        }

        /// <summary>
        /// 增加自定义字段
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="udf"></param>
        /// <returns></returns>
        public bool AddUdf(DicEnum.UDF_CATE cate, UserDefinedFieldDto udf, string token)
        {
            string table = GetTableName(cate);
            var dal = new sys_udf_field_dal();

            var field = new sys_udf_field();
            field.id = dal.GetNextIdSys();
            field.col_name = GetNextColName();
            field.col_comment = udf.name;
            field.description = udf.description;
            field.cate_id = udf.cate;
            field.data_type_id = udf.data_type;
            field.default_value = udf.default_value;
            field.is_protected = 0;
            field.is_required = udf.required;
            field.is_active = 1;
            field.display_format_id = udf.display_format;
            field.decimal_length = udf.decimal_length;
            field.create_user_id = CachedInfoBLL.GetUserInfo(token).id;
            field.update_user_id = field.create_user_id;
            field.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            field.update_time = field.create_time;
            dal.Insert(field);

            if (udf.data_type == (int)DicEnum.UDF_DATA_TYPE.LIST)       // 字段为列表类型，保存列表值
            {
                if (udf.value_list != null && udf.value_list.Count > 0)
                {
                    var listDal = new sys_udf_list_dal();
                    foreach(var listVal in udf.value_list)
                    {
                        sys_udf_list val = new sys_udf_list();
                        val.id = listDal.GetNextIdSys();
                        val.is_default = (sbyte)listVal.select;
                        val.name = listVal.show;
                        val.status_id = 0;
                        val.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        val.update_time = val.create_time;
                        val.create_user_id = field.create_user_id;
                        val.update_user_id = val.create_user_id;
                        listDal.Insert(val);
                    }
                }
            }
            return true;
        }

        /// <summary>
        /// 保存记录中的自定义字段值
        /// </summary>
        /// <param name="cate">客户、联系人等类别</param>
        /// <param name="objId">记录的id</param>
        /// <param name="fields">自定义字段信息</param>
        /// <param name="value">自定义字段值</param>
        /// <returns></returns>
        public bool SaveUdfValue(DicEnum.UDF_CATE cate, long objId, List<UserDefinedFieldDto> fields, List<UserDefinedFieldValue> value)
        {
            if (value == null || value.Count == 0)
                return true;

            StringBuilder select = new StringBuilder();
            StringBuilder values = new StringBuilder();
            foreach (var val in value)
            {
                var field = fields.FindAll(s => s.id == val.id);
                if (field == null || field.Count == 0)
                    continue;
                select.Append(",").Append(field.First().col_name);
                values.Append(",").Append(val.value);
            }
            if (values.Length == 0)
                return false;

            string table = GetTableName(cate);
            var dal = new sys_udf_field_dal();
            string insert = $"INSERT INTO {table} (id,parent_id{select.ToString()}) VALUES ({dal.GetNextIdSys()},{objId}{values.ToString()})";
            dal.ExecuteSQL(insert);

            return true;
        }

        /// <summary>
        /// 根据记录id获取字段值
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="objId"></param>
        /// <param name="fields"></param>
        /// <returns></returns>
        public List<UserDefinedFieldValue> GetUdfValue(DicEnum.UDF_CATE cate, long objId, List<UserDefinedFieldDto> fields)
        {
            var list = new List<UserDefinedFieldValue>();
            string table = GetTableName(cate);

            string sql = $"SELECT * FROM {table} WHERE parent_id={objId}";
            var tb = new sys_udf_field_dal().ExecuteDataTable(sql);
            if (tb == null)
                return list;

            if (tb.Rows.Count>0)
            {
                var dal = new sys_udf_field_dal();
                foreach (var field in fields)
                {
                    var udfField = dal.FindById(field.id);
                    list.Add(new UserDefinedFieldValue { id = field.id, value = tb.Rows[0][udfField.col_name] });
                }
            }
            return list;
        }

        /// <summary>
        /// 根据多个记录id获取字段值
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="ids">记录的id值，如 2,5,6</param>
        /// <param name="fields"></param>
        /// <returns></returns>
        public Dictionary<long, List<UserDefinedFieldValue>> GetUdfValue(DicEnum.UDF_CATE cate, string ids, List<UserDefinedFieldDto> fields)
        {
            var dic = new Dictionary<long, List<UserDefinedFieldValue>>();
            string table = GetTableName(cate);

            string sql = $"SELECT * FROM {table} WHERE parent_id IN ({ids})";
            var tb = new sys_udf_field_dal().ExecuteDataTable(sql);
            if (tb == null)
                return dic;

            var dal = new sys_udf_field_dal();
            foreach (System.Data.DataRow row in tb.Rows)
            {
                var list = new List<UserDefinedFieldValue>();
                foreach (var field in fields)
                {
                    var udfField = dal.FindById(field.id);
                    list.Add(new UserDefinedFieldValue { id = field.id, value = row[udfField.col_name] });
                }
                dic.Add(long.Parse(row["parent_id"].ToString()), list);
            }

            return dic;
        }

        /// <summary>
        /// 更新自定义字段值，并记录日志
        /// </summary>
        /// <param name="cate"></param>
        /// <param name="fields"></param>
        /// <param name="id"></param>
        /// <param name="vals"></param>
        /// <param name="userId"></param>
        /// <param name="userMobile"></param>
        /// <returns></returns>
        public bool UpdateUdfValue(DicEnum.UDF_CATE cate, List<UserDefinedFieldDto> fields, long id, List<UserDefinedFieldValue> vals, long userId, string userMobile)
        {
            var oldVal = GetUdfValue(cate, id, fields);
            Dictionary<string, string> dict = new Dictionary<string, string>();
            StringBuilder updateSb = new StringBuilder();
            foreach (var val in vals)
            {
                var oldv = oldVal.Find(f => f.id == val.id);
                if (object.Equals(oldv.value, val.value))
                    continue;
                var fld = fields.Find(f => f.id == val.id);
                updateSb.Append(fld.col_name).Append("='").Append(val.value).Append("',"); // 组合sql更新语句
                dict.Add(fld.col_name, oldv.value + "→" + val.value);       // 生成操作日志
            }
            if (dict.Count == 0)        // 无修改
                return true;
            
            string updateStr = updateSb.Remove(updateSb.Length - 1, 1).ToString();
            string sql = $"UPDATE {GetTableName(cate)} SET {updateStr} WHERE parent_id={id}";
            if (new sys_udf_field_dal().ExecuteSQL(sql) <= 0)
                return false;

            sys_oper_log log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = userId,
                name = "",
                phone = userMobile == null ? "" : userMobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = id,        // 操作对象id
                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                oper_description = new Tools.Serialize().SerializeJson(dict),
                remark = "修改自定义字段"

            };          // 创建日志
            new sys_oper_log_dal().Insert(log);       // 插入日志

            return true;
        }

        /// <summary>
        /// 获取用户自定义字段表名
        /// </summary>
        /// <param name="cate"></param>
        /// <returns></returns>
        private string GetTableName(DicEnum.UDF_CATE cate)
        {
            string table = "";
            switch (cate)
            {
                case DicEnum.UDF_CATE.COMPANY:
                    table = "crm_account_ext";
                    break;
                case DicEnum.UDF_CATE.CONTACT:
                    table = "crm_contact_ext";
                    break;
                // TODO: 其他类别
                default:
                    break;
            }
            return table;
        }

        /// <summary>
        /// 获取一个未使用的字段名
        /// </summary>
        /// <returns></returns>
        private string GetNextColName()
        {
            var dal = new sys_udf_field_dal();
            var field = dal.FindSignleBySql<sys_udf_field>($"SELECT * FROM sys_udf_field ORDER BY id DESC LIMIT 1");
            if (field == null)
                return "col001";
            int index = int.Parse(field.col_name.Remove(0, 3));
            ++index;
            
            return "col" + index.ToString().PadLeft(3, '0');
        }
    }
}
