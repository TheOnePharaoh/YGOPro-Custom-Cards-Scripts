--Ynershia Gate
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
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,s_id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(scard.a_tg)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local c=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Select(tp,1,1,nil):GetFirst()
	local n=1
	if c:IsFacedown() then
		n=1
	elseif c:IsRankAbove(1) then
		n=c:GetRank()
	elseif c:IsLevelAbove(1) then
		n=c:GetLevel()
	end
	Duel.Hint(HINT_NUMBER,tp,n)
	Duel.SetTargetParam(n)
end

function scard.sfil(c,e,tp)
	return c:IsSetCard(sc_id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.DisableShuffleCheck()
	local g=Duel.GetDecktopGroup(tp,n)
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(scard.sfil,nil,e,tp)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(s_id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummon(sg:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
	end
end
