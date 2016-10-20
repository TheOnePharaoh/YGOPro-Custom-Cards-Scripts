--Evil HERO Volcano
function c888000006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,98266377,95362816,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000006.splimit)
	c:RegisterEffect(e1)
	--Blaze Counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000006,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c888000006.btg)
	e2:SetOperation(c888000006.bop)
	c:RegisterEffect(e2)
	--ATK Up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c888000006.atktg)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--Anti-Burn Counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888000006,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c888000006.acost)
	e4:SetTarget(c888000006.atg)
	e4:SetOperation(c888000006.aop)
	c:RegisterEffect(e4)
	--Unaffected
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTarget(c888000006.ltg)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--Lose ATK
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetTarget(c888000006.wtg)
	e6:SetValue(-500)
	c:RegisterEffect(e6)
end
c888000006.dark_calling=true
function c888000006.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000006.wtg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c888000006.gfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:GetCounter(0x1888)==0
end
function c888000006.atktg(e,c)
	return c:GetCounter(0x1888)>0
end
function c888000006.ltg(e,c)
	return c:GetCounter(0x1889)>0
end
function c888000006.btg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c888000006.gfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c888000006.gfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c888000006.bop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e)  then
		tc:AddCounter(0x1888,1)
	end
end
function c888000006.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c888000006.lfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:GetCounter(0x1889)==0
end
function c888000006.atg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c888000006.lfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c888000006.lfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c888000006.aop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
		tc:AddCounter(0x1889,1)
	end
end
