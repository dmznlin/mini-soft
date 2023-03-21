{*******************************************************************************
  作者: dmzn@163.com 2023-03-21
  描述: 防火墙规则
*******************************************************************************}
unit UFirewall;

interface

uses
  System.SysUtils, System.Variants, System.Classes, ActiveX, ComObj,
  UFirewallLib;

function AddExe2Firewall(nCaption,nExe: string): Boolean;
//添加防火墙规则

implementation

function AddExe2Firewall(nCaption,nExe: string): Boolean;
const
  cRullName = 'Fihe_NetChecker';
var
  fwPolicy2      : INetFwPolicy2;
  RulesObject    : OleVariant;
  RObject        : OleVariant;
  Profile        : Integer;
  NewRule        : INetFwRule;
begin
  if nCaption = '' then
    nCaption := cRullName;
  //default name

  CoInitialize(nil);
  try
    fwPolicy2   := INetFwPolicy2(CreateOleObject('HNetCfg.FwPolicy2'));
    Profile := fwPolicy2.CurrentProfileTypes;
    //Profile := NET_FW_PROFILE2_PRIVATE OR NET_FW_PROFILE2_PUBLIC;

    RulesObject := fwPolicy2.Rules;

    NewRule := INetFwRule(CreateOleObject('HNetCfg.FWRule'));
    NewRule.Name        := nCaption;
    NewRule.Description := nCaption;
    NewRule.Applicationname := nExe;
    NewRule.Protocol := NET_FW_IP_PROTOCOL_TCP;
    NewRule.Direction := NET_FW_RULE_DIR_OUT;
    NewRule.Enabled := TRUE;
    NewRule.Profiles := Profile;
    NewRule.Action := NET_FW_ACTION_ALLOW;
    RulesObject.Add(NewRule);
  finally
    NewRule := nil;
    RulesObject := Unassigned;
  end;
end;

end.
