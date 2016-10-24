--The State of Ynershia
--  By Shad3

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()
local sc_id=0x73d

function scard.initial_effect(c)
	c:EnableCounterPermit(sc_id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Must Attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(scard.a_cd)
	c:RegisterEffect(e2)
	--Gain counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(scard.b_op)
	c:RegisterEffect(e3)
	--Inc ATK
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(scard.c_tg)
	e4:SetValue(scard.c_val)
	c:RegisterEffect(e4)
	--Search
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetCountLimit(1,s_id)
	e5:SetDescription(aux.Stringid(s_id,0))
	e5:SetCost(scard.d_cs)
	e5:SetTarget(scard.d_tg)
	e5:SetOperation(scard.d_op)
	c:RegisterEffect(e5)
end

function scard.a_cd(e)
	return Duel.GetFlagEffect(Duel.GetTurnPlayer(),s_id)==0
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(ep,s_id)==0 then Duel.RegisterFlagEffect(ep,s_id,RESET_PHASE+PHASE_END,0,1) end
	e:GetHandler():AddCounter(sc_id,1)
end

function scard.c_tg(e,c)
	return c:IsSetCard(sc_id)
end

function scard.c_val(e,c)
	return 100*e:GetHandler():GetCounter(sc_id)
end

function scard.d_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,sc_id,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,sc_id,2,REASON_COST)
end

function scard.d_fil(c)
	return c:IsSetCard(sc_id) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(s_id)
end

function scard.d_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.d_fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function scard.d_op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.SelectMatchingCard(tp,scard.d_fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
