--Toon Magic
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
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(scard.condition)
	e1:SetTarget(scard.target)
	e1:SetOperation(scard.activate)
	c:RegisterEffect(e1)
end
scard.card_code_list={21296502,90960358}
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(scard.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function scard.filter1(c,e,tp)
	return c:IsCode(21296502) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function scard.filter2(c,e,tp)
	return c:IsCode(90960358) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(scard.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(scard.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function scard.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,scard.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,scard.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)
	end
end
