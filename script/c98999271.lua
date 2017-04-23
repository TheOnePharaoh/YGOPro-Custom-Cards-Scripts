--No. 98 Number 98: Vocalists Last Story - Melody of Happiness
function c98999271.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),9,2)
	c:EnableReviveLimit()
	--absorb
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98999271,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98999271)
	e1:SetCondition(c98999271.abcon)
	e1:SetTarget(c98999271.abtg)
	e1:SetOperation(c98999271.abop)
	c:RegisterEffect(e1)
	--atk,def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c98999271.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--change lp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98999271,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c98999271.lpcon)
	e4:SetOperation(c98999271.lpop)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98999271,2))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE,EFFECT_FLAG2_XMDETACH)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c98999271.discost)
	e5:SetTarget(c98999271.distg)
	e5:SetOperation(c98999271.disop)
	c:RegisterEffect(e5)
	--add setcode
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x48)
	c:RegisterEffect(e6)
end
c98999271.xyz_number=98
function c98999271.abfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c98999271.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98999271.abfilter,1,nil,tp)
end
function c98999271.abtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not eg then return false end
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if chk==0 then return ep~=tp and tc:IsFaceup() and c:IsType(TYPE_XYZ) and not tc:IsType(TYPE_TOKEN) and tc:IsOnField()
		and tc:IsCanBeEffectTarget(e) and tc:IsAbleToChangeControler() end
	Duel.SetTargetCard(eg)
end
function c98999271.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if c:IsRelateToEffect(e) and c:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c98999271.atkval(e,c)
	return e:GetHandler():GetOverlayCount()*300
end
function c98999271.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c98999271.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,4000)
end
function c98999271.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98999271.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c98999271.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
