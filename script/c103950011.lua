--Shadow-Eater Drago
function c103950011.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950011,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c103950011.spcon)
	e1:SetOperation(c103950011.spop)
	c:RegisterEffect(e1)
	
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950011,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c103950011.desreptg)
	e2:SetOperation(c103950011.desrepop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	
end
--Filter for Special-summoning
function c103950011.spfilter1(c, rc)
	return c:IsRace(rc) and c:IsAbleToRemoveAsCost()
end
--Special-summoning condition
function c103950011.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c103950011.spfilter1,tp,LOCATION_GRAVE,0,1,nil,RACE_DRAGON)
end
--Special-summoning procedure (banish the card)
function c103950011.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c103950011.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,RACE_DRAGON)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(2)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
--Filter for destruction replace
function c103950011.spfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
--Destruction replace target
function c103950011.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res = Duel.IsExistingMatchingCard(c103950011.spfilter2,tp,LOCATION_GRAVE,0,1,nil)
		return not c:IsReason(REASON_REPLACE) and res
	end
	if Duel.SelectYesNo(tp,aux.Stringid(103950011,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c103950011.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetTargetCard(g)
		return true
	else return false end
end
--Destruction replace operation
function c103950011.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end