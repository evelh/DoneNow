﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 查询条件信息
    /// </summary>
    public class QueryConditionParaDto
    {
        public long id;             // 查询条件id
        public int data_type;       // 查询条件值类型
        public string defaultValue; // 查询条件默认值
        public string description;  // 查询条件描述
        public string ref_url;      // 查找带回的打开地址
        public List<DictionaryEntryDto> values;     // 查询条件值为列表时的值列表
    }

    /// <summary>
    /// 工作流的条件参数
    /// </summary>
    public class WorkflowConditionParaDto
    {
        public long id;             // 查询条件id
        public int data_type;       // 查询条件值类型
        public string defaultValue; // 查询条件默认值
        public string description;  // 查询条件描述
        public string ref_url;      // 查找带回的打开地址
        public string operator_type_id;             // 操作符id
        public string operatorName;     // 操作符
        public string ref_sql;      // 列表的取值语句
        public List<DictionaryEntryDto> values;     // 查询条件值为列表时的值列表
    }
}
