{$DEFINE debug}
//调试模式

{$DEFINE COM_MIT}
//定义系统模式

//通用中间件
{$IFDEF COM_MIT}
  {$DEFINE DBPool}
  //启用数据库支持
  {.$DEFINE SAPMIT}
  //启用SAP支持
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

//业务中间件
{$IFDEF BUS_MIT}
  {$DEFINE DBPool}
  //启用数据库支持
  {.$DEFINE SAPMIT}
  //启用SAP支持
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

//SAP中间件
{$IFDEF SAP_MIT}
  {.$DEFINE DBPool}
  //启用数据库支持
  {$DEFINE SAPMIT}
  //启用SAP支持 
  {.$DEFINE ClientMon}
  //支持守护服务
{$ENDIF}

{$DEFINE cxLibrary42}
//Ver4.2编译环境