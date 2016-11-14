function c494476161.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
c:RegisterEffect(e1)
--negate
local e2=Effect.CreateEffect(c)
e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e2:SetCode(EVENT_BATTLE_START)
e2:SetRange(LOCATION_SZONE)
e2:SetCondition(c494476161.condition)
e2:SetTarget(c494476161.target)
e2:SetOperation(c494476161.activate)
c:RegisterEffect(e2)
end

function c494476161.condition(e,tp,eg,ep,ev,re,r,rp)
local a=Duel.GetAttacker()
local d=Duel.GetAttackTarget()
return a:GetControler()~=e:GetHandlerPlayer() and a:GetControler()~=d:GetControler() and a:GetAttribute()==d:GetAttribute()
end
function c494476161.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local tg=Duel.GetAttacker()
if chkc then return chkc==tg end
if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
Duel.SetTargetCard(tg)
end
function c494476161.activate(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetAttacker()
if tc:IsRelateToEffect(e) and Duel.NegateAttack() then
Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
end
