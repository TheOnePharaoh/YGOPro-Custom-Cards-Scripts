--Dabo Gong, Wealth God of the Sky Nirvana
function c44559834.initial_effect(c)
	c:SetUniqueOnField(1,0,44559834)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x2016),aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c44559834.tgvalue)
	c:RegisterEffect(e3)
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
	--check id
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(44559834)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
	--lock
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(44559834,0))
	e6:SetCode(EFFECT_DISABLE_FIELD)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,44559834)
	e6:SetCondition(c44559834.lkcon)
	e6:SetOperation(c44559834.lkop1)
	c:RegisterEffect(e6)
	--lock2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(44559834,1))
	e7:SetCode(EFFECT_DISABLE_FIELD)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCountLimit(1,44559834)
	e7:SetCondition(c44559834.lkcon)
	e7:SetOperation(c44559834.lkop2)
	c:RegisterEffect(e7)
end
function c44559834.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c44559834.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c44559834.lkop1(e,tp,eg,ep,ev,re,r,rp)
	--disable field1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c44559834.disop1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end
function c44559834.disop1(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(44559834,2)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
		dis1=bit.bor(dis1,dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(44559834,2)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,dis1)
			dis1=bit.bor(dis1,dis3)
		end
	end
	return dis1
end
function c44559834.lkop2(e,tp,eg,ep,ev,re,r,rp)
	--disable field2
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c44559834.disop2)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
end
function c44559834.disop2(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if c==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(44559834,3)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,dis1)
		dis1=bit.bor(dis1,dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(44559834,3)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,dis1)
			dis1=bit.bor(dis1,dis3)
		end
	end
	return dis1
end
