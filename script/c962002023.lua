--Toon Meteor Black Dragon
--Created By ALANMAC95, Scripted By TheOnePharaoh
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	if not scard.reg then
	scard.reg=true
	end
	c:EnableReviveLimit()
	--special summon Proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(scard.spcon)
	e2:SetOperation(scard.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
end
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.CheckReleaseGroup(tp,nil,2,nil)
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.SelectReleaseGroup(tp,nil,2,2,nil)
	Duel.Release(g,REASON_COST)
end