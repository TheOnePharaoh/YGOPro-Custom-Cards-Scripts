--Arcana Force XX The Aeon
function c123213.initial_effect(c)
c:EnableReviveLimit()
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c123213.spcon)
	e0:SetOperation(c123213.spop)
	c:RegisterEffect(e0)
	--cannot special summon
	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(ea)
	--ATK/DEF UP
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c123213.up)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(123213,0))
	e3:SetCategory(CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c123213.cointg)
	e3:SetOperation(c123213.coinop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c123213.matfilter(c)
	return c:IsSetCard(0x5) and c:IsAbleToRemoveAsCost()
end
function c123213.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c123213.matfilter,c:GetControler(),LOCATION_GRAVE,0,3,nil)
end
function c123213.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c123213.matfilter,c:GetControler(),LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c123213.upfilter(c)
	return c:IsSetCard(0x5) 
end
function c123213.up(e,c)
	return Duel.GetMatchingGroupCount(c123213.upfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end
function c123213.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123213.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123213.arcanareg(c,res)
end
function c123213.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c123213.con)
	e1:SetReset(RESET_EVENT+0x1ff0000)
  	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c123213.atcost)
	e2:SetCondition(c123213.atcon)
	e2:SetOperation(c123213.atop)
	e2:SetReset(RESET_EVENT+0x1ff0000)	
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end	
function c123213.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123213.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function c123213.atcost(e,c,tp)
	return Duel.GetLP(tp)>=0
end
function c123213.atop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	Duel.SetLP(tp,Duel.GetLP(tp)/2,REASON_EFFECT)
end
