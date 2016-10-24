--Descent of Ynershia
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
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetCondition(scard.a_cd)
	e1:SetCost(scard.a_cs)
	e1:SetTarget(scard.a_tg)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
end

function scard.a_fil(c)
	return c:IsSetCard(sc_id) and c:IsFaceup() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end

function scard.a_cd(e,tp,eg,ep,ev,re,r,rp)
	if ev<3 then return false end
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if not te:GetHandler():IsSetCard(sc_id) and Duel.IsChainNegatable(i) then return true end
	end
	return false
end

function scard.a_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,scard.a_fil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,scard.a_fil,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local rg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if not tc:IsSetCard(sc_id) and Duel.IsChainNegatable(i) then
			ng:AddCard(tc)
			if tc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and tc:IsAbleToRemove(tp) then
				rg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(rg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local rg=Group.CreateGroup()
	for i=ev,1,-1 do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if not tc:IsSetCard(sc_id) and Duel.IsChainNegatable(i) then
			Duel.NegateActivation(i)
			if tc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and tc:IsAbleToRemove(tp) then
				tc:CancelToGrave()
				rg:AddCard(tc)
			end
		end
	end
	Duel.Remove(rg,nil,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(scard.b_op)
	Duel.RegisterEffect(e1,tp)
end

function scard.b_fil(c,e,tp)
	return c:IsSetCard(sc_id) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.b_fil,tp,LOCATION_GRAVE,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(s_id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummon(g:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
	e:Reset()
end
