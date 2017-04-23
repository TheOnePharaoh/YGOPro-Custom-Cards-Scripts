--The Future Gear Reina the Dimension Traveler
function c99199046.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--composition material
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c99199046.concon)
	e0:SetOperation(c99199046.conop)
	e0:SetValue(SUMMON_TYPE_SPECIAL+330)
	c:RegisterEffect(e0)
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xff17)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99199046,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c99199046.condition)
	e3:SetTarget(c99199046.target)
	e3:SetOperation(c99199046.operation)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199046,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e4:SetCountLimit(1)
	e4:SetCondition(c99199046.modcon)
	e4:SetCost(c99199046.modcost)
	e4:SetOperation(c99199046.modop)
	c:RegisterEffect(e4)
	--cannot attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetCondition(c99199046.atcon)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e6:SetCondition(c99199046.atcon)
	d:RegisterEffect(e6)
end
function c99199046.atcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c99199046.spfilter1(c,tp)
	return c:IsFaceup() and c:GetLevel()==4 and c:IsSetCard(0xff16) and Duel.IsExistingMatchingCard(c99199046.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c99199046.spfilter2(c)
	return c:IsFaceup() and c:GetLevel()==4 and not c:IsSetCard(0xff16)
end
function c99199046.concon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c99199046.spfilter1,tp,LOCATION_MZONE,0,2,nil,tp)
end
function c99199046.conop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99199046,2))
	local g1=Duel.SelectMatchingCard(tp,c99199046.spfilter1,tp,LOCATION_MZONE,0,2,2,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99199046,3))
	local g2=Duel.SelectMatchingCard(tp,c99199046.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	local tc=g2:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g2:GetNext()
	end
	Duel.Overlay(c,g1)
	Duel.Release(g2,REASON_COST+REASON_MATERIAL)
end
function c99199046.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+330
end
function c99199046.filter(c)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL and c:IsAbleToDeck()
end
function c99199046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c99199046.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local sg=Duel.GetMatchingGroup(c99199046.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c99199046.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c99199046.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c99199046.modcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,6) and not Duel.GetFieldCard(tp,LOCATION_SZONE,7) or not Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) or not Duel.GetFieldCard(tp,LOCATION_SZONE,6) and not Duel.GetFieldCard(tp,LOCATION_SZONE,7)
end
function c99199046.modcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99199046.modfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xff15) and not c:IsForbidden()
end
function c99199046.modop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c99199046.modfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_SZONE,6) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_SZONE,7) then ct=ct+1 end
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,ct,nil)
		local sc=sg:GetFirst()
		while sc do
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			sc=sg:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c99199046.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c99199046.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_LIGHT) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end