--Vocalist Overlay Boost
function c66456867.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c66456867.con1)
	e1:SetOperation(c66456867.activate1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c66456867.con2)
	e2:SetOperation(c66456867.activate2)
	c:RegisterEffect(e2)
end
function c66456867.filter1(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function c66456867.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66456867.filter1,1,nil) and re:GetHandler():IsSetCard(0x0dac404)
end
function c66456867.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:Filter(c66456867.filter1,nil)
	local tc=re:GetHandler()
	if tc:IsFaceup() then
		Duel.Overlay(tc,c)
	end
end
function c66456867.filter2(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE) and c:GetBattleTarget():IsSetCard(0x0dac404)
end
function c66456867.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66456867.filter2,1,nil)
end
function c66456867.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:Filter(c66456867.filter2,nil)
	local tc=c:GetFirst():GetBattleTarget()
	if tc:IsFaceup() then
		Duel.Overlay(tc,c)
	end
end
